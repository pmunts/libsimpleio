{ I2C bus controller services using libsimpleio                               }

{ Copyright (C)2017-2023, Philip Munts dba Munts Technologies.                }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT I2C_libsimpleio;

INTERFACE

  USES
    I2C;

  TYPE
    BusSubclass = CLASS(TInterfacedObject, I2C.Bus)
      CONSTRUCTOR Create(name : String);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Read
       (addr     : I2C.Address;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      PROCEDURE Write
       (addr     : I2C.Address;
        cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal);

      PROCEDURE Transaction
       (addr     : I2C.Address;
        cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal;
        delayus  : Cardinal = 0);
    PRIVATE
      fd : Integer;
    END;

IMPLEMENTATION

  USES
    Errors,
    libI2C,
    libLinux;

  { I2C_libsimpleio.BusSubclass constructor }

  CONSTRUCTOR BusSubclass.Create(name : String);

  VAR
    error  : Integer;

  BEGIN
    libI2C.Open(PChar(name), Self.fd, error);

    IF error <> 0 THEN
      RAISE I2C.Error.Create('ERROR: libI2C.Open() failed, ' +
        Errors.StrError(error));
  END;

  { I2C_libsimpleio.BusSubclass destructor }

  DESTRUCTOR BusSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libI2C.Close(Self.fd, error);
    INHERITED;
  END;

  { I2C read method }

  PROCEDURE BusSubclass.Read
   (addr     : I2C.Address;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libI2C.Transaction(Self.fd, addr, NIL, 0, @resp, resplen, error);

    IF error <> 0 THEN
      RAISE I2C.Error.Create('ERROR: libI2C.Transaction() failed, ' +
        Errors.StrError(error));
  END;

  { I2C write method }

  PROCEDURE BusSubclass.Write
   (addr     : I2C.Address;
    cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libI2C.Transaction(Self.fd, addr, @cmd, cmdlen, NIL, 0, error);

    IF error <> 0 THEN
      RAISE I2C.Error.Create('ERROR: libI2C.Transaction() failed, ' +
        Errors.StrError(error));
  END;

  { I2C write/read transaction method }

  PROCEDURE BusSubclass.Transaction
   (addr     : I2C.Address;
    cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal;
    delayus  : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    IF delayus > 65535 THEN
      RAISE I2C.Error.Create('ERROR: delayus parameter is invalid');

    IF delayus > 0 THEN
      BEGIN
        libI2C.Transaction(Self.fd, addr, @cmd, cmdlen, NIL, 0, error);

        IF error <> 0 THEN
          RAISE I2C.Error.Create('ERROR: libI2C.Transaction() failed, ' +
            Errors.StrError(error));

        libLinux.usleep(delayus, error);

        IF error <> 0 THEN
          RAISE I2C.Error.Create('ERROR: libLiux.usleep() failed, ' +
            Errors.StrError(error));

        libI2C.Transaction(Self.fd, addr, NIL, 0, @resp, resplen, error);

        IF error <> 0 THEN
          RAISE I2C.Error.Create('ERROR: libI2C.Transaction() failed, ' +
            Errors.StrError(error));
      END
    ELSE
      BEGIN
        libI2C.Transaction(Self.fd, addr, @cmd, cmdlen, @resp, resplen, error);

        IF error <> 0 THEN
          RAISE I2C.Error.Create('ERROR: libI2C.Transaction() failed, ' +
            Errors.StrError(error));
      END;
  END;

END.

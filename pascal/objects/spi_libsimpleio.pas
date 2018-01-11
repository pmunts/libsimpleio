{ SPI devices services using libsimpleio                                      }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT SPI_libsimpleio;

INTERFACE

  USES SPI;

  CONST
    AUTOCHIPSELECT = -1;

  TYPE
    Modes = 0 .. 3;

    { Define a class implementing the SPI.Device interface }

    DeviceSubclass = CLASS(TInterfacedObject, SPI.Device)
      CONSTRUCTOR Create
       (name     : String;
        mode     : Modes;
        wordsize : Cardinal;
        speed    : Cardinal;
        cspin    : Integer = AUTOCHIPSELECT);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Read
       (VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      PROCEDURE Write
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal);

      PROCEDURE Transaction
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal;n
        delayus  : Cardinal;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);
    PRIVATE
      fd   : Integer;
      fdcs : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libGPIO,
    libSPI;

  { SPI_libsimpleio.DeviceSubclass constructor }

  CONSTRUCTOR DeviceSubclass.Create
   (name     : String;
    mode     : Modes;
    wordsize : Cardinal;
    speed    : Cardinal;
    cspin    : Integer);

  VAR
    error  : Integer;

  BEGIN
    libSPI.Open(PChar(name), mode, wordsize, speed, Self.fd, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libSPI.Open() failed, ' +
        strerror(error));

    IF cspin = AUTOCHIPSELECT THEN
      BEGIN
        fdcs := SPI_CS_AUTO;
        EXIT;
      END;

    libGPIO.Configure(cspin, DIRECTION_OUTPUT, 1, EDGE_NONE,
      POLARITY_ACTIVEHIGH, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libGPIO.Configure() failed, ' +
        strerror(error));

    libGPIO.Open(cspin, Self.fdcs, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libGPIO.Open() failed, ' +
        strerror(error));
  END;

  { SPI_libsimpleio.DeviceSubclass destructor }

  DESTRUCTOR DeviceSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libSPI.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libSPI.Close() failed, ' +
        strerror(error));

    IF Self.fdcs = SPI_CS_AUTO THEN
      EXIT;

    libGPIO.Close(Self.fdcs, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libGPIO.Close() failed, ' +
        strerror(error));

    INHERITED;
  END;

  { SPI read method }

  PROCEDURE DeviceSubclass.Read
   (VAR resp : ARRAY OF Byte;
    resplen  : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libSPI.Transaction(Self.fd, Self.fdcs, NIL, 0, 0, @resp, resplen, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libSPI.Transaction() failed, ' +
        strerror(error));
  END;

  { SPI write method }

  PROCEDURE DeviceSubclass.Write
   (cmd    : ARRAY OF Byte;
    cmdlen : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libSPI.Transaction(Self.fd, Self.fdcs, @cmd, cmdlen, 0, NIL, 0, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libSPI.Transaction() failed, ' +
        strerror(error));
  END;

  { SPI write/read transaction method }

  PROCEDURE DeviceSubclass.Transaction
   (cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal;
    delayus  : Cardinal;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libSPI.Transaction(Self.fd, Self.fdcs, @cmd, cmdlen, delayus, @resp,
      resplen, error);

    IF error <> 0 THEN
      RAISE SPI_Error.create('ERROR: libSPI.Transaction() failed, ' +
        strerror(error));
  END;

END.

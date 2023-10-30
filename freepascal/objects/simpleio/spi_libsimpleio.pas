{ SPI devices services using libsimpleio                                      }

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

UNIT SPI_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    GPIO_libsimpleio,
    SPI,
    SysUtils;

  CONST
    AUTOCHIPSELECT : libsimpleio.Designator =
      (chip : High(Cardinal); chan : High(Cardinal));

  TYPE
    Modes = 0 .. 3;

    { Define a class implementing the SPI.Device interface }

    DeviceSubclass = CLASS(TInterfacedObject, SPI.Device)
      CONSTRUCTOR Create
       (desg     : libsimpleio.Designator;
        mode     : Modes;
        wordsize : Cardinal;
        speed    : Cardinal);

      CONSTRUCTOR Create
       (desg     : libsimpleio.Designator;
        mode     : Modes;
        wordsize : Cardinal;
        speed    : Cardinal;
        cspin    : libsimpleio.Designator);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Read
       (VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      PROCEDURE Write
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal);

      PROCEDURE Transaction
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal;
        delayus  : Cardinal = 0);

    PRIVATE
      fd   : Integer;
      fdcs : Integer;
    END;

IMPLEMENTATION

  USES
    Errors,
    libGPIO,
    libSPI;

  { SPI_libsimpleio.DeviceSubclass constructors }

  CONSTRUCTOR DeviceSubclass.Create
   (desg     : libsimpleio.Designator;
    mode     : Modes;
    wordsize : Cardinal;
    speed    : Cardinal);

  VAR
    name   : String;
    error  : Integer;

  BEGIN
    name := Format('/dev/spidev%d.%d', [desg.chip, desg.chan]);

    libSPI.Open(PChar(name), mode, wordsize, speed, Self.fd, error);

    IF error <> 0 THEN
      RAISE SPI.Error.Create('ERROR: libSPI.Open() failed, ' +
        StrError(error));

    Self.fdcs := libSPI.SPI_CS_AUTO;
  END;

  CONSTRUCTOR DeviceSubclass.Create
   (desg     : libsimpleio.Designator;
    mode     : Modes;
    wordsize : Cardinal;
    speed    : Cardinal;
    cspin    : libsimpleio.Designator);

  VAR
    name   : String;
    error  : Integer;

  BEGIN
    name := Format('/dev/spidev%d.%d', [desg.chip, desg.chan]);

    libSPI.Open(PChar(name), mode, wordsize, speed, Self.fd, error);

    IF error <> 0 THEN
      RAISE SPI.Error.Create('ERROR: libSPI.Open() failed, ' +
        StrError(error));

    IF (cspin.chip = AUTOCHIPSELECT.chip) AND
       (cspin.chan = AUTOCHIPSELECT.chan) THEN
      Self.fdcs := libSPI.SPI_CS_AUTO
    ELSE
      BEGIN
        libGPIO.LineOpen(cspin.chip, cspin.chan, LINE_REQUEST_OUTPUT, 0, 1,
          Self.fdcs, error);

        IF error <> 0 THEN
          RAISE SPI.Error.Create('ERROR: libSPI.LineOpen() failed, ' +
            StrError(error));
      END;
  END;

  { SPI_libsimpleio.DeviceSubclass destructor }

  DESTRUCTOR DeviceSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libSPI.Close(Self.fd, error);
    libGPIO.Close(Self.fdcs, error);
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
      RAISE SPI.Error.Create('ERROR: libSPI.Transaction() failed, ' +
        StrError(error));
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
      RAISE SPI.Error.Create('ERROR: libSPI.Transaction() failed, ' +
        StrError(error));
  END;

  { SPI write/read transaction method }

  PROCEDURE DeviceSubclass.Transaction
   (cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal;
    delayus  : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    IF delayus > 65535 THEN
      RAISE SPI.Error.Create('ERROR: delayus parameter is invalid');

    libSPI.Transaction(Self.fd, Self.fdcs, @cmd, cmdlen, delayus, @resp,
      resplen, error);

    IF error <> 0 THEN
      RAISE SPI.Error.Create('ERROR: libSPI.Transaction() failed, ' +
        StrError(error));
  END;

END.

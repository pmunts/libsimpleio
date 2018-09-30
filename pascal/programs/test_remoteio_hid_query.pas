{ Remote I/O Device Information Query                                         }

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

PROGRAM test_remoteio_hid_query;

USES
  HID_libsimpleio,
  Message64,
  RemoteIO,
  SysUtils;

VAR
  m          : HID_libsimpleio.MessengerSubclass;
  d          : RemoteIO.Device;
  bustype    : Integer;
  vendor     : Integer;
  product    : Integer;
  chans      : ChannelArray;
  c          : Cardinal;

BEGIN
  Writeln;
  Writeln('Remote I/O Device Information Query');
  Writeln;

  m := HID_libsimpleio.MessengerSubclass.Create;
  d := RemoteIO.Device.Create(m);

  m.GetInfo(bustype, vendor, product);

  Writeln('HID device name: ', m.GetName);
  Writeln('HID bus type:    ', bustype);
  Writeln('HID vendor ID:   ', IntToHex(vendor, 4));
  Writeln('HID product ID:  ', IntToHex(product, 4));
  Writeln;
  Writeln('Remote I/O device version:    ', d.Version);
  Writeln('Remote I/O device capability: ', d.Capability);
  Writeln;

  chans := d.ADC_Inputs;

  IF chans <> NIL THEN
    BEGIN
      Write('ADC inputs: ');
      
      FOR c := 0 TO Length(chans) - 1 DO
        Write(' ', chans[c]);

      Writeln;
    END;

  chans := d.GPIO_Pins;

  IF chans <> NIL THEN
    BEGIN
      Write('GPIO pins:  ');
      
      FOR c := 0 TO Length(chans) - 1 DO
        Write(' ', chans[c]);

      Writeln;
    END;

  chans := d.I2C_Buses;

  IF chans <> NIL THEN
    BEGIN
      Write('I2C buses:  ');
      
      FOR c := 0 TO Length(chans) - 1 DO
        Write(' ', chans[c]);

      Writeln;
    END;

  chans := d.SPI_Devices;

  IF chans <> NIL THEN
    BEGIN
      Write('SPI Devices:');
      
      FOR c := 0 TO Length(chans) - 1 DO
        Write(' ', chans[c]);

      Writeln;
    END;
END.

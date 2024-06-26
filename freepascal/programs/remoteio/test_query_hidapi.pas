{ Remote I/O Device Information Query using hidapi }

{ Copyright (C)2020-2023, Philip Munts dba Munts Technologies.                }
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

PROGRAM test_query_hidapi;

USES
  HID_Munts,
  HID_hidapi,
  Message64,
  RemoteIO,
  RemoteIO_Client,
  SysUtils;

VAR
  msg    : HID_hidapi.MessengerSubclass;
  remdev : RemoteIO_Client.Device;
  chans  : RemoteIO.ChannelArray;
  c      : Cardinal;

BEGIN
  Writeln;
  Writeln('Remote I/O Device Information Query');
  Writeln;

  msg    := HID_hidapi.MessengerSubclass.Create(HID_Munts.VID, HID_Munts.PID);
  remdev := RemoteIO_Client.Device.Create(msg);

  Writeln('HID device name:              ', msg.Name);
  Writeln('HID device manufacturer:      ', msg.Manufacturer);
  Writeln('HID device product:           ', msg.Product);
  Writeln('HID device serial number:     ', msg.SerialNumber);
  Writeln;

  Writeln('Remote I/O device version:    ', remdev.Version);
  Writeln('Remote I/O device capability: ', remdev.Capability);
  Writeln;

  IF Pos('ADC', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.ADC_Inputs;

      IF chans <> NIL THEN
        BEGIN
          Write('ADC inputs:  ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  IF Pos('DAC', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.DAC_Outputs;

      IF chans <> NIL THEN
        BEGIN
          Write('DAC outputs: ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  IF Pos('GPIO', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.GPIO_Pins;

      IF chans <> NIL THEN
        BEGIN
          Write('GPIO pins:   ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  IF Pos('I2C', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.I2C_Buses;

      IF chans <> NIL THEN
        BEGIN
          Write('I2C buses:   ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  IF Pos('PWM', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.PWM_Outputs;

      IF chans <> NIL THEN
        BEGIN
          Write('PWM outputs: ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  IF Pos('SPI', remdev.Capability) <> 0 THEN
    BEGIN
      chans := remdev.SPI_Devices;

      IF chans <> NIL THEN
        BEGIN
          Write('SPI slaves:  ');

          FOR c := 0 TO Length(chans) - 1 DO
            Write(' ', chans[c]);

          Writeln;
        END;
    END;

  Writeln;
END.

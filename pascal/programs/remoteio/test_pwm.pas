{ Remote I/O PWM Output Test }

{ Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.             }
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

PROGRAM test_pwm;

USES
  PWM,
  RemoteIO,
  RemoteIO_Client,
  RemoteIO_Client_libusb,
  SysUtils;

VAR
  remdev  : RemoteIO_Client.Device;
  chans   : ChannelArray;
  outputs : ARRAY OF PWM.Output;
  i       : Cardinal;
  duty    : Cardinal;

BEGIN
  Writeln;
  Writeln('Remote I/O PWM Output Test');
  Writeln;

  { Create objects }

  remdev := RemoteIO_Client_libusb.Create;
  chans  := remdev.PWM_Outputs;

  SetLength(outputs, Length(chans));

  FOR i := 0 TO Length(chans) - 1 DO
    outputs[i] := remdev.PWM(chans[i], 1000);

  { Sweep the pulse width back and forth }

  REPEAT
    FOR duty := 0 TO 1000 DO
      FOR i := 0 TO Length(chans) - 1 DO
        outputs[i].dutycycle := duty/10.0;

    FOR duty := 1000 DOWNTO 0 DO
      FOR i := 0 TO Length(chans) - 1 DO
        outputs[i].dutycycle := duty/10.0;
  UNTIL False;
END.

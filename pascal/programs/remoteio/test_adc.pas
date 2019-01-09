{ Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  }
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

PROGRAM test_adc;

USES
  ADC,
  RemoteIO,
  SysUtils;

VAR
  remdev   : RemoteIO.Device;
  chanlist : RemoteIO.ChannelArray;
  numchans : Cardinal;
  samplers : ARRAY OF ADC.Sample;
  chan     : Cardinal;

BEGIN
  Writeln;
  Writeln('Remote Analog Input Test');
  Writeln;

  { Create objects }

  remdev := RemoteIO.Device.Create;

  { Configure analog inputs }

  chanlist := remdev.ADC_Inputs;
  numchans := Length(chanlist);

  SetLength(samplers, numchans);

  FOR chan := 0 TO numchans - 1 DO
    samplers[chan] := remdev.ADC(chan);

  REPEAT
    FOR chan := 0 TO numchans - 1 DO
      Write(samplers[chan].sample : 5, ' ');

    Writeln;

    sleep(1000);
  UNTIL False;
END.

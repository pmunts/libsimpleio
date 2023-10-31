{ ADC Input Test using libsimpleio }

{ Copyright (C)2019-2023, Philip Munts dba Munts Technologies.                }
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

namespace test_adc;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('ADC Input Test using libsimpleio');
    writeLn;

    { Create an ADC input object }

    var desg : IO.Objects.SimpleIO.Device.Designator;

    write('ADC chip number?             ');
    desg.chip := Integer.Parse(readLn());

    write('ADC input channel number?    ');
    desg.chan := Integer.Parse(readLn());

    write('ADC input resolution?        ');
    var res  : Integer := Integer.Parse(readLn());

    write('ADC input reference voltage? ');
    var Vref : Real := Real.Parse(readLn());

    write('ADC input voltage gain?      ');
    var gain : Real := Real.Parse(readLn());

    var samp : IO.Interfaces.ADC.Sample :=
      new IO.Objects.SimpleIO.ADC.Sample(desg, res);

    var volts : IO.Interfaces.ADC.Input :=
      new IO.Interfaces.ADC.Input(samp, Vref, gain);

    { Display the analog input voltage }

    writeLn;

    loop begin
      writeLn(String.Format('Sample: {0,5}  Voltage: {1,6:F4}', samp.sample,
        volts.voltage));
      RemObjects.Elements.RTL.Thread.Sleep(1000);
    end;
  end;

end.

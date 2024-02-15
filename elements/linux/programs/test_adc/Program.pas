{ Analog Input Test using libsimpleio }

{ Copyright (C)2024, Philip Munts dba Munts Technologies.                     }
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

  procedure Main(args : array of String);

  begin
    writeLn;
    writeLn('Analog Input Test using libsimpleio');
    writeLn;

    var desg       : IO.Objects.SimpleIO.Resources.Designator;
    var resolution : Cardinal;
    var Vref       : Double;

    try
      desg := IO.Objects.SimpleIO.Resources.GetDesignator2('Enter ADC');

      write('Enter resolution (bits):  ');
      resolution := Cardinal.Parse(readLn);

      write('Enter reference voltage:  ');
      Vref := Double.Parse(readLn);
      writeLn;
    except
      on E : Exception do
        begin
          writeLn('ERROR: Illegal numeric input');
          writeLn(E.Message);
          exit;
        end;
    end;

    var inp : IO.Objects.SimpleIO.ADC.Input;

    try
      inp := new IO.Objects.SimpleIO.ADC.Input(desg, resolution, Vref);
    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot create analog input');
          writeLn(E.Message);
          exit;
        end;
    end;

    writeLn('Press CONTROL-C to quit');
    writeLn;

    repeat
      writeLn('Voltage => ' + inp.voltage.ToString + ' V');
      RTL.Sleep(1);
    until false;
  end;

end.

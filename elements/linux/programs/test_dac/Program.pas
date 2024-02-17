{ Analog Output Test using libsimpleio }

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

namespace test_dac;

  procedure Main(args : array of String);

  begin
    writeLn;
    writeLn('Analog Output Test using libsimpleio');
    writeLn;

    var desg       : IO.Objects.SimpleIO.Resources.Designator;
    var resolution : Cardinal;
    var Vref       : Double;

    try
      desg := IO.Objects.SimpleIO.Resources.GetDesignator2('Enter DAC');

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

    var outp : IO.Objects.SimpleIO.DAC.Output;

    try
      outp := new IO.Objects.SimpleIO.DAC.Output(desg, resolution, Vref);
    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot create analog output');
          writeLn(E.Message);
          exit;
        end;
    end;

    writeLn('Press CONTROL-C to quit');
    writeLn;

    var V : IO.Interfaces.Voltage.Volts;

    repeat
      V := 0.0;

      while V < Vref do begin
        outp.voltage := V;
        V := V + 0.01;
      end;
    until False;
  end;

end.

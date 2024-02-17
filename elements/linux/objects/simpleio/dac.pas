{ Copyright (C)2024, Philip Munts dba Munts Technologies.                }
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

{ Implement GPIO pin services using libsimpleio }

namespace IO.Objects.SimpleIO.DAC;

interface

  type Output = public class(IO.Interfaces.Sample.OutputInterface,
    IO.Interfaces.Voltage.OutputInterface)
    public constructor
     (desg : IO.Objects.SimpleIO.Resources.Designator;
      bits : Cardinal;
      Vref : IO.Interfaces.Voltage.Volts;
      Vout : IO.Interfaces.Voltage.Volts := 0.0);

    private function GetResolution : Cardinal;

    public property resolution: Cardinal read GetResolution;

    private function Getfd : Int32;

    public property fd : Int32 read Getfd;

    private function GetSample : IO.Interfaces.Sample.Sample;

    private procedure SetSample(S : IO.Interfaces.Sample.Sample);

    public property sample : IO.Interfaces.Sample.Sample read GetSample write SetSample;

    private function GetVoltage : IO.Interfaces.Voltage.Volts;

    private procedure SetVoltage(Vout : IO.Interfaces.Voltage.Volts);

    public property voltage: IO.Interfaces.Voltage.Volts read GetVoltage write SetVoltage;

    { Private internal state }

    private myfd         : Int32;
    private myresolution : Cardinal;
    private mystepsize   : IO.Interfaces.Voltage.Volts;
    private mysample     : IO.Interfaces.Sample.Sample;
  end;

implementation

  constructor Output
   (desg : IO.Objects.SimpleIO.Resources.Designator;
    bits : Cardinal;
    Vref : IO.Interfaces.Voltage.Volts;
    Vout : IO.Interfaces.Voltage.Volts := 0.0);

  begin
    var error : Int32;

    IO.Bindings.libsimpleio.DAC_open(desg.chip, desg.channel, @self.myfd,
      @error);

    if error <> 0 then
      raise new Exception('DAC_open() failed, ' + errno.strerror(error));

    self.myresolution := bits;
    self.mystepsize   := Vref/(2**bits);
  end;

  function Output.GetResolution: Cardinal;

  begin
    GetResolution := self.myresolution;
  end;

  function Output.Getfd: Int32;

  begin
    Getfd := self.myfd;
  end;

  function Output.GetSample: IO.Interfaces.Sample.Sample;

  begin
    GetSample := self.mysample;
  end;

  procedure Output.SetSample(S: IO.Interfaces.Sample.Sample);

  begin
    var error : Int32;

    IO.Bindings.libsimpleio.DAC_write(self.myfd, S, @error);

    if error <> 0 then
      raise new Exception('DAC_write() failed, ' + errno.strerror(error));

    self.mysample := S;
  end;

  function Output.GetVoltage: IO.Interfaces.Voltage.Volts;

  begin
    GetVoltage := self.sample*self.mystepsize;
  end;

  procedure Output.SetVoltage(Vout: IO.Interfaces.Voltage.Volts);

  begin
    self.sample := Int32(Vout/self.mystepsize);
  end;

end.

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

namespace IO.Objects.SimpleIO.ADC;

interface

  type Input = public class(IO.Interfaces.Sample.InputInterface, IO.Interfaces.Voltage.InputInterface)
    public constructor
     (desg : IO.Objects.SimpleIO.Resources.Designator;
      bits : Cardinal;
      Vref : IO.Interfaces.Voltage.Volts);

    private function GetSample : IO.Interfaces.Sample.Sample;

    public property sample : IO.Interfaces.Sample.Sample read GetSample;

    private function GetResolution : Cardinal;

    public property resolution: Cardinal read GetResolution;

    private function Getfd : Int32;

    public property fd : Int32 read Getfd;

    private function GetVoltage : IO.Interfaces.Voltage.Volts;

    public property voltage: IO.Interfaces.Voltage.Volts read GetVoltage;

    { Private internal state }

    private myfd         : Int32;
    private myresolution : Cardinal;
    private mystepsize   : IO.Interfaces.Voltage.Volts;
  end;

implementation

  constructor Input
   (desg : IO.Objects.SimpleIO.Resources.Designator;
    bits : Cardinal;
    Vref : IO.Interfaces.Voltage.Volts);

  begin
    var error : Int32;

    IO.Bindings.libsimpleio.ADC_open(desg.chip, desg.channel, @self.myfd,
      @error);

    if error <> 0 then
      raise new Exception('ADC_open() failed, ' + errno.strerror(error));

    self.myresolution := bits;
    self.mystepsize   := Vref/(2**bits);
  end;

  function Input.GetSample: IO.Interfaces.Sample.Sample;

  begin
    var data  : Int32;
    var error : Int32;

    IO.Bindings.libsimpleio.ADC_read(self.myfd, @data, @error);

    if error <> 0 then
      raise new Exception('ADC_read() failed, ' + errno.strerror(error));

    GetSample := data;
  end;

  function Input.GetResolution: Cardinal;

  begin
    GetResolution := self.myresolution;
  end;

  function Input.GetVoltage: IO.Interfaces.Voltage.Volts;

  begin
    GetVoltage := self.sample*self.mystepsize;
  end;

  function Input.Getfd: Int32;

  begin
    Getfd := self.myfd;
  end;

end.

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

UNIT ADC_libsimpleio;

INTERFACE

  USES
    ADC,
    Voltage;

  TYPE

    { Analog input subclass }

    InputSubclass = CLASS(TInterfacedObject, ADCInput, VoltageInput)
      CONSTRUCTOR Create
       (chip       : Cardinal;
        channel    : Cardinal;
        resolution : Cardinal;
        reference  : Real;
        gain       : Real = 1.0;
        offset     : Real = 0.0);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION Read : Integer;

      FUNCTION ReadVoltage : Real;

    PRIVATE

      fd       : Integer;
      stepsize : Real;
      gain     : Real;
      offset   : Real;
    END;

IMPLEMENTATION

  USES
    errno,
    libADC,
    Math;

  CONSTRUCTOR InputSubclass.Create
   (chip       : Cardinal;
    channel    : Cardinal;
    resolution : Cardinal;
    reference  : Real;
    gain       : Real;
    offset     : Real);

  VAR
    error : Integer;

  BEGIN
    libADC.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE ADC_Error.create('ERROR: libADC.Open() failed, ' + strerror(error));

    self.stepsize := reference/power(2, resolution);
    Self.gain := gain;
    Self.offset := offset;
  END;

  DESTRUCTOR InputSubclass.Destroy;

  VAR
    error : Integer;

  BEGIN
    libADC.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE ADC_Error.create('ERROR: libADC.Close() failed, ' +
        strerror(error));

    INHERITED;
  END;

  { Method implementing ADC.ADCInput.Read }

  FUNCTION InputSubclass.Read : Integer;

  VAR
    sample : Integer;
    error  : Integer;

  BEGIN
    libADC.Read(Self.fd, sample, error);

    IF error <> 0 THEN
      RAISE ADC_Error.create('ERROR: libADC.Read() failed, ' + strerror(error));

    Read := sample;
  END;

  { Method implementing Voltage.VoltageInput.ReadVoltage }

  FUNCTION InputSubclass.ReadVoltage : Real;

  BEGIN
    ReadVoltage := Self.Read*Self.stepsize/Self.gain - Self.offset;
  END;

END.

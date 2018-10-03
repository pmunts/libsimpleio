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

UNIT ADS1015;

INTERFACE

  USES
    ADC,
    I2C;

  { Intrinsic characteristics of the ADS1015 A/D converter }

  CONST
    MaxChannels     = 4;
    ResolutionBits  = 12;
    ResolutionSteps = 4096;

  TYPE

    { Input channel selectors }

    Channels = (AIN0, AIN1, AIN2, AIN3, DIFF01, DIFF03, DIFF13, DIFF23);

    { Full scale range (in millivolts) selectors }

    Ranges   = (FSR6144, FSR4096, FSR2048, FSR1024, FSR512, FSR256);

    { ADS1015 device class }

    Device = CLASS
      CONSTRUCTOR Create
       (bus  : I2C.Bus;
        addr : I2C.Address);
    PRIVATE
      bus  : I2C.Bus;
      addr : I2C.Address;

      { Private methods }

      FUNCTION ReadRegister(regaddr : Byte) : Word;

      PROCEDURE WriteRegister(regaddr : Byte; regdata : Word);
    END;

    { ADS1015 analog input class }

    InputSubclass = CLASS(TInterfacedObject, ADC.Sample, ADC.Voltage)
      CONSTRUCTOR Create
       (dev     : Device;
        channel : Channels;
        range   : Ranges;
        gain    : Real = 1.0);

      { Public methods }

      FUNCTION sample : Integer;

      FUNCTION resolution : Cardinal;

      FUNCTION voltage : Real;
    PRIVATE
      dev     : Device;
      channel : Cardinal;
      range   : Cardinal;
      gain    : Real;
    END;

IMPLEMENTATION

  { ADS1015 register addresses }

  CONST
    CONVERSION     = 0;
    CONFIG         = 1;
    LOW_THRESHOLD  = 2;
    HIGH_THRESHOLD = 3;

  { ADS1015 device constructor }

  CONSTRUCTOR Device.Create
   (bus  : I2C.Bus;
    addr : I2C.Address);

  BEGIN
    Self.bus := Bus;
    Self.addr := addr;
  END;

  { ADS1015 device read register method }

  FUNCTION Device.ReadRegister(regaddr : Byte) : Word;

  VAR
    cmd  : ARRAY [0 .. 0] OF Byte;
    resp : ARRAY [0 .. 1] OF Byte;

  BEGIN
    IF regaddr > HIGH_THRESHOLD THEN
      RAISE ADC.Error.Create('ERROR: Invalid register address');

    cmd[0] := regaddr;
    Self.bus.Transaction(Self.addr, cmd, SizeOf(cmd), resp, SizeOf(resp));
    ReadRegister := (resp[0] SHL 8) + resp[1];
  END;

  { ADS1015 device write register method }

  PROCEDURE Device.WriteRegister(regaddr : Byte; regdata : Word);

  VAR
    cmd : ARRAY [0 .. 2] OF Byte;

  BEGIN
    IF regaddr > HIGH_THRESHOLD THEN
      RAISE ADC.Error.Create('ERROR: Invalid register address');

    cmd[0] := regaddr;
    cmd[1] := regdata DIV 256;
    cmd[2] := regdata MOD 256;

    Self.bus.Write(Self.addr, cmd, SizeOf(cmd));
  END;

  { ADS1015 analog input constructor }

  CONSTRUCTOR InputSubclass.Create
   (dev     : Device;
    channel : Channels;
    range   : Ranges;
    gain    : Real);

  BEGIN
    Self.dev := dev;
    IF (channel >= AIN0) AND (channel <= AIN3) THEN
      Self.channel := Ord(channel) + 4
    ELSE
      Self.channel := Ord(channel) - 4;
    Self.range := Ord(range);
    Self.gain := gain;
  END;

  { Method implementing ADC.Sample.sample }

  FUNCTION InputSubclass.sample : Integer;

  BEGIN
    { Start conversion }

    Self.dev.WriteRegister(CONFIG, (1 SHL 15) + (Self.channel SHL 12) +
      (Ord(Self.range) SHL 9) + (1 SHL 8));

    { Wait until conversion complete }

    REPEAT
    UNTIL (Self.dev.ReadRegister(CONFIG) AND $8000) <> 0;

    sample := SmallInt(Self.dev.ReadRegister(CONVERSION) SHR 4);
  END;

  { Method implementing ADC.sample.resolution }

  FUNCTION InputSubclass.resolution : Cardinal;

  BEGIN
    resolution := ResolutionBits;
  END;

  { Method implementing ADC.Voltage.voltage }

  FUNCTION InputSubclass.voltage : Real;

  CONST
    RangeValues : ARRAY [0 .. 5] OF Real =
     (6.144, 4.096, 2.048, 1.024, 0.512, 0.256);

  BEGIN
    voltage := Self.sample*RangeValues[Self.range]/ResolutionSteps*2.0/gain;
  END;

END.

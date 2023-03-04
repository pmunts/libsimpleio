-- BMP280 pressure and temperature sensor services

-- Copyright (C)2016-2023, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Unchecked_Conversion;

WITH I2C;

USE TYPE I2C.Byte;

PACKAGE BODY BMP280 IS
  PRAGMA Warnings(Off, "constant ""*"" is not referenced");

  -- BMP280 Registers

  REG_CALIB0  : CONSTANT I2C.Byte := 16#88#;
  REG_ID      : CONSTANT I2C.Byte := 16#D0#;
  REG_RESET   : CONSTANT I2C.Byte := 16#E0#;
  REG_STATUS  : CONSTANT I2C.Byte := 16#F3#;
  REG_CONTROL : CONSTANT I2C.Byte := 16#F4#;
  REG_CONFIG  : CONSTANT I2C.Byte := 16#F5#;
  REG_PMSB    : CONSTANT I2C.Byte := 16#F7#;
  REG_PLSB    : CONSTANT I2C.Byte := 16#F8#;
  REG_PXLSB   : CONSTANT I2C.Byte := 16#F9#;
  REG_TMSB    : CONSTANT I2C.Byte := 16#FA#;
  REG_TLSB    : CONSTANT I2C.Byte := 16#FB#;
  REG_TXLSB   : CONSTANT I2C.Byte := 16#FC#;

  -- Control register settings

  CONTROL_SLEEP  : CONSTANT I2C.Byte := 2#001_001_00#; -- Sleep mode
  CONTROL_SAMPLE : CONSTANT I2C.Byte := 2#001_001_01#; -- Force sample mode

  -- Write to a single BMP280 register

  PROCEDURE WriteRegister
   (Self    : IN OUT DeviceSubclass;
    regaddr : I2C.Byte;
    regdata : I2C.Byte) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := regaddr;
    cmd(1) := regdata;

    Self.bus.Write(Self.address, cmd, cmd'Length);
  END WriteRegister;

  -- Read from one or more BMP280 registers

  PROCEDURE ReadRegisters
   (Self    : IN OUT DeviceSubclass;
    regaddr : I2C.Byte;
    regdata : OUT I2C.Response) IS

    cmd  : I2C.Command(0 .. 0);

  BEGIN
    cmd(0) :=  regaddr;

    Self.bus.Transaction(Self.address, cmd, cmd'Length, regdata, regdata'Length);
  END ReadRegisters;

  -- Define conversions for calibration data

  FUNCTION ToSigned16 IS NEW
    Ada.Unchecked_Conversion
     (Source => Unsigned16,
      Target => Signed16);

  FUNCTION ToUnsigned16(lsb : I2C.Byte; msb : I2C.Byte) RETURN Unsigned16 IS
   (Unsigned16(lsb) + Unsigned16(msb)*256);

  FUNCTION ToSigned16(lsb : I2C.Byte; msb : I2C.Byte) RETURN Signed16 IS
   (ToSigned16(ToUnsigned16(lsb, msb)));

  -- BMP280 sensor object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address) RETURN Device IS

    Self    : CONSTANT Device := NEW DeviceSubclass'(bus, addr,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    status  : I2C.Response(0 .. 0);
    caldata : I2C.Response(0 .. 25);

  BEGIN
    Self.WriteRegister(REG_CONTROL, CONTROL_SLEEP);
    Self.WriteRegister(REG_CONFIG,  2#0000_0000#);

    -- Wait while the BMP280 is busy

    LOOP
      Self.ReadRegisters(REG_STATUS, status);
      EXIT WHEN (status(0) AND 16#03#) = 16#00#;
    END LOOP;

    -- Read calibration data

    Self.ReadRegisters(REG_CALIB0, caldata);

    -- Extract calibration data

    Self.dig_T1 := ToUnsigned16(caldata(0), caldata(1));
    Self.dig_T2 := ToSigned16(caldata(2),   caldata(3));
    Self.dig_T3 := ToSigned16(caldata(4),   caldata(5));
    Self.dig_P1 := ToUnsigned16(caldata(6), caldata(7));
    Self.dig_P2 := ToSigned16(caldata(8),   caldata(9));
    Self.dig_P3 := ToSigned16(caldata(10),  caldata(11));
    Self.dig_P4 := ToSigned16(caldata(12),  caldata(13));
    Self.dig_P5 := ToSigned16(caldata(14),  caldata(15));
    Self.dig_P6 := ToSigned16(caldata(16),  caldata(17));
    Self.dig_P7 := ToSigned16(caldata(18),  caldata(19));
    Self.dig_P8 := ToSigned16(caldata(20),  caldata(21));
    Self.dig_P9 := ToSigned16(caldata(22),  caldata(23));

    RETURN Self;
  END Create;

  -- Convert 20-bit temperature sample to Celsius

  FUNCTION ToCelsius
   (Self    : IN OUT DeviceSubclass;
    regdata : I2C.Response) RETURN Float IS

    adc_T   : Integer;
    A1      : Float;
    A2      : Float;
    C1      : Float;
    C2      : Float;
    C3      : Float;
    C4      : Float;
    var1    : Float;
    var2    : Float;

  BEGIN
    -- // Returns temperature in DegC, double precision. Output value of “51.23” equals 51.23 DegC.
    -- double bmp280_compensate_T_double(BMP280_S32_t adc_T)
    -- {
    --   double var1, var2, T;
    --   var1 = (((double)adc_T)/16384.0 – ((double)dig_T1)/1024.0) * ((double)dig_T2);
    --   var2 = ((((double)adc_T)/131072.0 – ((double)dig_T1)/8192.0) *
    --     (((double)adc_T)/131072.0 – ((double) dig_T1)/8192.0)) * ((double)dig_T3);
    --   T = (var1 + var2) / 5120.0;
    --   return T;
    -- }

    adc_T := Integer(regdata(3))*4096 + Integer(regdata(4))*16 +
      Integer(regdata(5))/16;

    A1 := Float(adc_T)/16384.0;
    A2 := Float(adc_T)/131072.0;

    C1 := Float(Self.dig_T1)/1024.0;
    C2 := Float(Self.dig_T1)/8192.0;
    C3 := Float(Self.dig_T2);
    C4 := Float(Self.dig_T3);

    var1 := (A1 - C1)*C3;
    var2 := (A2 - C2)*(A2 - C2)*C4;

    RETURN (var1 + var2)/5120.0;
  END ToCelsius;

  -- Convert 20-bit pressure sample to Pascals

  FUNCTION ToPascals
   (Self    : IN OUT DeviceSubclass;
    regdata : I2C.Response) RETURN Float IS

    adc_P : Integer;
    var1  : Float;
    var2  : Float;
    p     : Float;

  BEGIN
    -- // Returns pressure in Pa as double. Output value of “96386.2” equals 96386.2 Pa = 963.862 hPa
    -- double bmp280_compensate_P_double(BMP280_S32_t adc_P)
    -- {
    --   double var1, var2, p;
    --   var1 = ((double)t_fine/2.0) – 64000.0;
    --   var2 = var1 * var1 * ((double)dig_P6) / 32768.0;
    --   var2 = var2 + var1 * ((double)dig_P5) * 2.0;
    --   var2 = (var2/4.0)+(((double)dig_P4) * 65536.0);
    --   var1 = (((double)dig_P3) * var1 * var1 / 524288.0 + ((double)dig_P2) * var1) / 524288.0;
    --   var1 = (1.0 + var1 / 32768.0)*((double)dig_P1);
    --   if (var1 == 0.0)
    --   {
    --     return 0; // avoid exception caused by division by zero
    --   }
    --   p = 1048576.0 – (double)adc_P;
    --   p = (p – (var2 / 4096.0)) * 6250.0 / var1;
    --   var1 = ((double)dig_P9) * p * p / 2147483648.0;
    --   var2 = p * ((double)dig_P8) / 32768.0;
    --   p = p + (var1 + var2 + ((double)dig_P7)) / 16.0;
    --   return p;
    -- }

    adc_P := Integer(regdata(0))*4096 + Integer(regdata(1))*16 +
      Integer(regdata(2))/16;

    var1 := Self.ToCelsius(regdata)*2560.0 - 64000.0;
    var2 := var1*var1*Float(Self.dig_P6)/32768.0;
    var2 := var2 + var1*Float(Self.dig_P5)*2.0;
    var2 := var2/4.0 + Float(Self.dig_P4)*65536.0;
    var1 := (Float(Self.dig_P3)*var1*var1/524288.0 + Float(Self.dig_P2)*var1)/524288.0;
    var1 := (1.0 + var1/32768.0)*Float(Self.dig_P1);

    p    := 1048576.0 - Float(adc_P);
    p    := (p - (var2/4096.0))*6250.0/var1;
    var1 := Float(Self.dig_P9)*p*p/2147483648.0;
    var2 := p*Float(Self.dig_P8)/32768.0;
    p    := p + (var1 + var2 + Float(Self.dig_P7))/16.0;

    RETURN p;
  END ToPascals;

  -- Read BMP280 pressure

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Pressure.Pascals IS

    status  : I2C.Response(0 .. 0);
    regdata : I2C.Response(0 .. 5);

  BEGIN

    -- Initiate sampling

    Self.WriteRegister(REG_CONTROL, CONTROL_SAMPLE);

    -- Wait while the BMP280 is busy

    LOOP
      Self.ReadRegisters(REG_STATUS, status);
      EXIT WHEN (status(0) AND 16#03#) = 16#00#;
    END LOOP;

    -- Read sample data

    Self.ReadRegisters(REG_PMSB, regdata);

    -- Convert to Pascals

    RETURN Pressure.Pascals(Self.ToPascals(regdata));
  END Get;

  -- Read BMP280 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    status  : I2C.Response(0 .. 0);
    regdata : I2C.Response(0 .. 5);

  BEGIN

    -- Initiate sampling

    Self.WriteRegister(REG_CONTROL, CONTROL_SAMPLE);

    -- Wait while the BMP280 is busy

    LOOP
      Self.ReadRegisters(REG_STATUS, status);
      EXIT WHEN (status(0) AND 16#03#) = 16#00#;
    END LOOP;

    -- Read sample data

    Self.ReadRegisters(REG_PMSB, regdata);

    -- Convert to Celsius

    RETURN Temperature.Celsius(Self.ToCelsius(regdata));
  END Get;

END BMP280;

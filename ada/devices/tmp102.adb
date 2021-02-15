-- TMP102 temperature sensor services

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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
WITH Temperature;

USE TYPE Temperature.Celsius;

PACKAGE BODY TMP102 IS

  -- Conversions between RegisterData and Celsius require an
  -- intermediate signed integer step

  TYPE SignedRegisterData IS RANGE -32768 .. 32767;
  FOR SignedRegisterData'Size USE 16;

  FUNCTION ToSigned IS NEW
    Ada.Unchecked_Conversion
     (Source => RegisterData,
      Target => SignedRegisterData);

  FUNCTION ToUnsigned IS NEW
    Ada.Unchecked_Conversion
     (Source => SignedRegisterData,
      Target => RegisterData);

  -- Object constructor

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address) RETURN Device IS

    d : Device;

  BEGIN
    d := NEW DeviceSubclass'(bus, addr);
    d.WriteRegister(ConfigReg, CONFIG_FAULTS_1 OR CONFIG_1HZ);

    RETURN d;
  END Create;

  -- Read TMP102 register

  PROCEDURE ReadRegister
   (Self : DeviceSubclass;
    reg  : RegisterName;
    data : OUT RegisterData) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(RegisterName'Pos(reg));
    Self.bus.Transaction(Self.address, cmd, 1, resp, 2);
    data := RegisterData(resp(0))*256 + RegisterData(resp(1));
  END ReadRegister;

  -- Write TMP102 register

  PROCEDURE WriteRegister
   (Self : DeviceSubclass;
    reg  : RegisterName;
    data : RegisterData) IS

    cmd  : I2C.Command(0 .. 2);

  BEGIN
    cmd(0) := I2C.Byte(RegisterName'Pos(reg));
    cmd(1) := I2C.Byte(data / 256);
    cmd(2) := I2C.Byte(data MOD 256);

    Self.bus.Write(Self.address, cmd, 3);
  END WriteRegister;

  -- Configure the alert output pin

  PROCEDURE ConfigureAlert
   (Self     : DeviceSubclass;
    mode     : AlertMode;
    polarity : AlertPolarity;
    lowtemp  : Temperature.Celsius;
    hightemp : Temperature.Celsius) IS

    config   : RegisterData;

  BEGIN
    Self.ReadRegister(ConfigReg, config);

    IF mode = Interrupt THEN
      config := config OR CONFIG_TM;
    ELSE
      config := config AND NOT CONFIG_TM;
    END IF;

    IF polarity = ActiveHigh THEN
      config := config OR CONFIG_POL;
    ELSE
      config := config AND NOT CONFIG_POL;
    END IF;

    Self.WriteRegister(ConfigReg, config);
    Self.WriteRegister(LowLimit, RegisterData(ToUnsigned(SignedRegisterData(lowtemp/SCALE_FACTOR))));
    Self.WriteRegister(HighLimit, RegisterData(ToUnsigned(SignedRegisterData(hightemp/SCALE_FACTOR))));
  END ConfigureAlert;

  -- Sample TMP102 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    rawtemp : RegisterData;

  BEGIN
    Self.ReadRegister(TempReg, rawtemp);
    RETURN Temperature.Celsius(ToSigned(rawtemp))*SCALE_FACTOR;
  END Get;

END TMP102;

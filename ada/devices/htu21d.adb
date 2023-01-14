-- HTU21D temperature and humidity sensor services

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

PACKAGE BODY HTU21D IS
  PRAGMA Warnings(Off, "named number ""*"" is not referenced");

  -- Per datasheet, maximum reset time is 15 ms
  ResetTime : CONSTANT Duration := 20.0/1000.0;

  -- Per datasheet, maximum conversion time is 50 ms
  TemperatureConversionTime : CONSTANT I2C.Microseconds := 54000;

  -- Per datasheet, maximum conversion time is 16 ms
  HumidityConversionTime    : CONSTANT I2C.Microseconds := 20000;

  -- Per datasheet
  DefaultAddress : CONSTANT I2C.Address := 16#40#;

  TYPE SensorData IS MOD 65536;

  -- Command definitions

  CMD_GET_CONFIG           : CONSTANT := 16#E7#;
  CMD_GET_TEMPERATURE_HOLD : CONSTANT := 16#E3#;
  CMD_GET_HUMIDITY_HOLD    : CONSTANT := 16#E5#;
  CMD_GET_TEMPERATURE_WAIT : CONSTANT := 16#F3#;
  CMD_GET_HUMIDITY_WAIT    : CONSTANT := 16#F5#;
  CMD_PUT_CONFIG           : CONSTANT := 16#E6#;
  CMD_PUT_RESET            : CONSTANT := 16#FE#;

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus;
    clockstretch : Boolean := False) RETURN Device IS

    Self : Device;
    cmd  : I2C.Command(0 .. 1);

  BEGIN
    Self := NEW DeviceSubclass'(bus, DefaultAddress, clockstretch);

    -- Issue reset command

    cmd(0) := CMD_PUT_RESET;
    Self.bus.Write(Self.address, cmd, 1);
    DELAY ResetTime;

    -- Configure resolutions

    cmd(0) := CMD_PUT_CONFIG;
    cmd(1) := 16#00#; -- 12 bits humidity, 14 bits temperature
    Self.bus.Write(Self.address, cmd, 2);

    RETURN Self;
  END Create;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    cmd      : I2C.Command(0 .. 0);
    resp     : I2C.Response(0 .. 1);
    rawvalue : SensorData;

  BEGIN
    IF Self.stretch THEN
      cmd(0) := CMD_GET_TEMPERATURE_HOLD;
      Self.bus.Transaction(Self.address, cmd, 1, resp, 2);
    ELSE
      cmd(0) := CMD_GET_TEMPERATURE_WAIT;
      Self.bus.Transaction(Self.address, cmd, 1, resp, 2,
        TemperatureConversionTime);
    END IF;

    rawvalue := (SensorData(resp(0))*256 + SensorData(resp(1))) AND 16#FFFC#;

    RETURN Temperature.Celsius(175.72*Float(rawvalue)/65536.0 - 46.85);
  END Get;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative IS

    cmd      : I2C.Command(0 .. 0);
    resp     : I2C.Response(0 .. 1);
    rawvalue : SensorData;

  BEGIN
    IF Self.stretch THEN
      cmd(0) := CMD_GET_HUMIDITY_HOLD;
      Self.bus.Transaction(Self.address, cmd, 1, resp, 2);
    ELSE
      cmd(0) := CMD_GET_HUMIDITY_WAIT;
      Self.bus.Transaction(Self.address, cmd, 1, resp, 2,
        HumidityConversionTime);
    END IF;

    rawvalue := (SensorData(resp(0))*256 + SensorData(resp(1))) AND 16#FFF0#;

    IF rawvalue > 55574 THEN -- Clip high value to 100%
      rawvalue := 55574;
    END IF;

    IF rawvalue < 3146 THEN -- Clip low value to 0%
      rawvalue := 3146;
    END IF;

    RETURN Humidity.Relative(125.0*Float(rawvalue)/65536.0 - 6.0);
  END Get;

END HTU21D;

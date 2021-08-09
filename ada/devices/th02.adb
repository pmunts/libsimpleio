-- TH02 temperature and humidity sensor services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH Temperature;

USE TYPE Temperature.Celsius;

PACKAGE BODY TH02 IS

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Device IS

    dev : Device;

  BEGIN
    dev := NEW DeviceSubclass'(bus, 16#40#);
    dev.Put(RegConfig, cmdInit);

    RETURN dev;
  END Create;

  -- Read from an TH02 device register

  FUNCTION Get
   (Self : DeviceSubclass;
    addr : RegisterAddress) RETURN RegisterData IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    IF (addr > RegID) THEN
      RAISE TH02_Error WITH "Invalid register address";
    END IF;

    IF (addr > RegConfig) AND (addr < RegID) THEN
      RAISE TH02_Error WITH "Invalid register address";
    END IF;

    cmd(0) := I2C.Byte(addr);

    Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length, 0);

    RETURN (RegisterData(resp(0)));
  END Get;

  -- Write to an TH02 device register

  PROCEDURE Put
   (Self : DeviceSubclass;
    addr : RegisterAddress;
    data : RegisterData) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    IF (addr > RegID) THEN
      RAISE TH02_Error WITH "Invalid register address";
    END IF;

    IF (addr > RegConfig) AND (addr < RegID) THEN
      RAISE TH02_Error WITH "Invalid register address";
    END IF;

    cmd(0) := I2C.Byte(addr);
    cmd(1) := I2C.Byte(data);

    Self.bus.Write(Self.address, cmd, cmd'Length);
  END Put;

  -- Request a raw data sample

  FUNCTION Get
   (Self : DeviceSubclass;
    what : RegisterData) RETURN RawData IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    -- Start conversion

    Self.Put(RegConfig, what);

    -- Wait until conversion is complete

    LOOP
      EXIT WHEN (Self.Get(RegStatus) AND mskBusy) = 0;
    END LOOP;

    -- Fetch result

    cmd(0) := I2C.Byte(RegDataH);
    Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length);

    -- Return result

    RETURN RawData(resp(0))*256 + RawData(resp(1));
  END Get;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

  BEGIN
    RETURN Temperature.Celsius(Self.Get(cmdTemp)/4)/32.0 - 50.0;
  END Get;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative IS

    RHvalue  : Float;
    RHlinear : Float;
    RHcomp   : Float;

  BEGIN
    -- Calculate unlinearized uncompensated humidity

    RHvalue := Float(Self.Get(cmdHumid)/16)/16.0 - 24.0;

    -- Calculate linearized but uncompensated humidity

    RHlinear := RHvalue - (RHvalue*RHvalue*A2 + RHvalue*A1 + A0);

    -- Calculate linearized and compensated humidity

    RHcomp := RHlinear +
      (Float(Temperature.Celsius'(Self.Get)) - 30.0)*(RHlinear*Q1 + Q0);

    -- Clip insane humidity values

    IF RHcomp < Float(Humidity.Relative'First) THEN
      RETURN Humidity.Relative'First;
    ELSIF RHcomp > Float(Humidity.Relative'Last) THEN
      RETURN Humidity.Relative'Last;
    ELSE
      RETURN Humidity.Relative(RHcomp);
    END IF;
  END Get;

  -- Get device ID

  FUNCTION DeviceID(Self : IN OUT DeviceSubclass) RETURN Natural IS

  BEGIN
    RETURN Natural(Self.Get(RegID));
  END DeviceID;

END TH02;

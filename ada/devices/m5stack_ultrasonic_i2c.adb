-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

-- See https://shop.m5stack.com/products/ultrasonic-distance-unit-i2c-rcwl-9620
-- for more information.

WITH Distance;

USE TYPE Distance.meters;

PACKAGE BODY M5Stack_Ultrasonic_I2C IS

  -- Device object constructor

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Distance.Input IS

  BEGIN
    RETURN NEW Sensor'(bus, addr);
  END Create;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self : OUT Sensor;
    bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := DefaultAddress) IS

  BEGIN
    Self.bus     := bus;
    Self.address := addr;
  END Initialize;

  -- Get distance in meters

  FUNCTION Get(Self : IN OUT Sensor) RETURN Distance.meters IS

    cmd     : I2C.Command(0 .. 0);
    resp    : I2C.Response(0 .. 2);
    rawdist : Natural;

  BEGIN
    LOOP
      -- For some reason, the first I2C transaction from a Raspberry Pi to the
      -- M5 Stack Ultrasonic-I2C module after system power up always fails.
      -- The following exception handling code is a work-around.
      --
      -- It also has the interesting side effect of recovering silently from
      -- hot unplugging and plugging the module's Grove I2C cable.
      BEGIN
        -- Transmit ping, wait 5 milliseconds for signal processing, receive echo:
        cmd(0) := 16#01#;
        Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length, 5000);
        EXIT;
      EXCEPTION
        WHEN OTHERS =>
          NULL;
      END;
    END LOOP;

    rawdist := Natural(resp(0))*65536 + Natural(resp(1))*256 + Natural(resp(2));

    RETURN Distance.meters(rawdist)/1000000.0;
  END Get;

END M5Stack_Ultrasonic_I2C;

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

WITH CPUInfo;
WITH Distance;

USE TYPE CPUInfo.Kinds;
USE TYPE Distance.meters;

PACKAGE BODY M5Stack_Ultrasonic_I2C IS

  -- Raspberry Pi 1 to 4 (cores BCM2708 to BCM2711) have a notoriously broken
  -- I2C master controller that cannot handle I2C slave clock stretching.

  I2C_Clock_Stretch_Works : CONSTANT Boolean :=
   (IF CPUInfo.Kind >= CPUInfo.BCM2708 AND CPUInfo.Kind <= CPUInfo.BCM2711 THEN False ELSE True);

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
    -- Transmit ping command

    cmd(0) := 16#01#;
    Self.bus.Write(Self.address, cmd, cmd'Length);

    -- The M5 Stack Ultrasonic-I2C module pulls SCL low (i.e. I2C slave clock
    -- stretch) for 50 milliseconds after accepting the ping command.  On
    -- Raspberry Pi's 1 to 4, which do not support I2C slave clock stretch,
    -- we have to wait it out with a safe margin before reading the echo
    -- response bytes.

    DELAY (IF I2C_Clock_Stretch_Works THEN 0.005 ELSE 0.100);

    -- Receive echo data

    Self.bus.Read(Self.address, resp, resp'Length);

    -- Process echo data

    rawdist := Natural(resp(0))*65536 + Natural(resp(1))*256 + Natural(resp(2));

    RETURN Distance.meters(rawdist)/1000000.0;
  END Get;

END M5Stack_Ultrasonic_I2C;

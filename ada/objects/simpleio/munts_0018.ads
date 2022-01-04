-- I/O Resources provided by the MUNTS-0018 Raspberry Pi Tutorial I/O Board

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

-- Each resource designator constant declared here is named relative to the
-- connector providing that resource.  Application programs should use the
-- designator constants declared here instead of literals or constants from
-- the RaspberryPi package.
--
-- The following device tree overlay statements must be added to
-- /boot/config.txt:
--
-- dtparam=i2c=on
-- dtparam=spi=on
-- dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000
-- dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2
--
-- GPIO12 and GPIO19 will be unavailable for GPIO, as they will be mapped
-- as PWM outputs.  If you need to use these pins for GPIO, omit the pwm-2chan
-- device tree overlay.

WITH Device;
WITH RaspberryPi;

PACKAGE MUNTS_0018 IS

  Error : EXCEPTION;

  TYPE ConnectorID IS (J2, J3, J4, J5, J6, J7, J8, J9, J10, J11);

  -- Servo headers

  J2PWM  : Device.Designator RENAMES RaspberryPi.PWM0;
  J3PWM  : Device.Designator RENAMES RaspberryPi.PWM1;

  -- Grove GPIO Connectors

  J4D0   : Device.Designator RENAMES RaspberryPi.GPIO23;
  J4D1   : Device.Designator RENAMES RaspberryPi.GPIO24;

  J5D0   : Device.Designator RENAMES RaspberryPi.GPIO5;
  J5D1   : Device.Designator RENAMES RaspberryPi.GPIO4;

  J6D0   : Device.Designator RENAMES RaspberryPi.GPIO12;
  J6D1   : Device.Designator RENAMES RaspberryPi.GPIO13;

  J7D0   : Device.Designator RENAMES RaspberryPi.GPIO19;
  J7D1   : Device.Designator RENAMES RaspberryPi.GPIO18;

  -- DC Motor control outputs

  J6PWM  : Device.Designator RENAMES RaspberryPi.PWM0;
  J6DIR  : Device.Designator RENAMES J6D1;

  J7PWM  : Device.Designator RENAMES RaspberryPi.PWM1;
  J7DIR  : Device.Designator RENAMES J7D1;

  -- Serial ports

  J8UART : CONSTANT String := "/dev/ttyAMA0";

  -- I2C buses

  J5I2C  : Device.Designator RENAMES RaspberryPi.I2C3; -- Raspberry Pi 4 only
  J9I2C  : Device.Designator RENAMES RaspberryPi.I2C1;

  -- Grove ADC Connector J10

  J10A0  : CONSTANT Device.Designator := (0, 2); -- MCP3204 CH2
  J10A1  : CONSTANT Device.Designator := (0, 3); -- MCP3204 CH3

  -- Grove ADC Connector J11

  J11A0  : CONSTANT Device.Designator := (0, 0); -- MCP3204 CH0
  J11A1  : CONSTANT Device.Designator := (0, 1); -- MCP3204 CH1

  -- On board momentary switch

  SW1    : Device.Designator RENAMES RaspberryPi.GPIO6;

  -- On board LED indicator

  D1    : Device.Designator RENAMES RaspberryPi.GPIO26;

PRIVATE

  -- Map a connector to a Device.Designator

  TYPE ConnectorMap IS ARRAY (ConnectorID) OF Device.Designator;

  PROCEDURE CheckConnector
   (map       : ConnectorMap;
    connector : ConnectorID);

END MUNTS_0018;

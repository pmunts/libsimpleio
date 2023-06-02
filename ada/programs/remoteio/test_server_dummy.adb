-- Remote I/O Protocol Dummy Server

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

WITH RemoteIO.ADC;
WITH RemoteIO.DAC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.I2C;
WITH RemoteIO.PWM;
WITH RemoteIO.SPI;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;

PROCEDURE test_server_dummy IS

  title  : CONSTANT String := "Remote I/O Protocol Dummy Server";
  caps   : CONSTANT String := "ADC DAC GPIO I2C PWM SPI";
  exec   : RemoteIO.Executive.Executor;

  PRAGMA Warnings(Off, "* assigned but never read");

  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  dac    : RemoteIO.DAC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;
  i2c    : RemoteIO.I2C.Dispatcher;
  pwm    : RemoteIO.PWM.Dispatcher;
  spi    : RemoteIO.SPI.Dispatcher;

BEGIN
  RemoteIO.Server.Foundation.Initialize(title, caps);
  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  PRAGMA Warnings(Off, "possibly useless assignment to *");

  srvh := RemoteIO.Server.Dev.Create(exec, "Raw HID", "/dev/hidg0");
  srvs := RemoteIO.Server.Serial.Create(exec, "Serial Port", "/dev/ttyGS0");
  srvu := RemoteIO.Server.UDP.Create(exec, "UDP");

  -- Create I/O subsystem objects

  PRAGMA Warnings(Off, "possibly useless assignment to *");

  adc  := RemoteIO.ADC.Create(exec);
  dac  := RemoteIO.DAC.Create(exec);
  gpio := RemoteIO.GPIO.Create(exec);
  i2c  := RemoteIO.I2C.Create(exec);
  pwm  := RemoteIO.PWM.Create(exec);
  spi  := RemoteIO.SPI.Create(exec);

  -- Register I/O resources here

  -- See https://github.com/pmunts/muntsos/blob/master/examples/ada/programs/remoteio_server.adb
  -- for examples of how to register some common I/O resources.

END test_server_dummy;

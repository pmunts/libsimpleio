-- Stub program to force compiling all of the static object packages

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH ADC.libsimpleio;
WITH DAC.libsimpleio;
WITH GPIO.libsimpleio;
WITH HID.hidapi;
WITH HID.libsimpleio;
WITH HID.libusb;
WITH I2C.libsimpleio;
WITH Logging.libsimpleio;
WITH PWM.libsimpleio;
WITH SPI.libsimpleio;
WITH Watchdog.libsimpleio;

PROCEDURE test_static_objects IS

  adc0    : ADC.libsimpleio.InputSubclass      := ADC.libsimpleio.Destroyed;
  dac0    : DAC.libsimpleio.OutputSubclass     := DAC.libsimpleio.Destroyed;
  gpio0   : GPIO.libsimpleio.PinSubclass       := GPIO.libsimpleio.Destroyed;
  hid0    : HID.hidapi.MessengerSubclass       := HID.hidapi.Destroyed;
  hid1    : HID.libsimpleio.MessengerSubclass  := HID.libsimpleio.Destroyed;
  hid2    : HID.libusb.MessengerSubclass       := HID.libusb.Destroyed;
  i2c0    : I2C.libsimpleio.BusSubclass        := I2C.libsimpleio.Destroyed;
  log0    : Logging.libsimpleio.LoggerSubclass := Logging.libsimpleio.Destroyed;
  pwm0    : PWM.libsimpleio.OutputSubclass     := PWM.libsimpleio.Destroyed;
  spidev0 : SPI.libsimpleio.DeviceSubclass     := SPI.libsimpleio.Destroyed;
  wd0     : Watchdog.libsimpleio.TimerSubclass := Watchdog.libsimpleio.Destroyed;

BEGIN
  ADC.libsimpleio.Destroy(adc0);
  DAC.libsimpleio.Destroy(dac0);
  GPIO.libsimpleio.Destroy(gpio0);
  HID.hidapi.Destroy(hid0);
  HID.libsimpleio.Destroy(hid1);
  HID.libusb.Destroy(hid2);
  I2C.libsimpleio.Destroy(i2c0);
  Logging.libsimpleio.Destroy(log0);
  PWM.libsimpleio.Destroy(pwm0);
  SPI.libsimpleio.Destroy(spidev0);
  Watchdog.libsimpleio.Destroy(wd0);
END test_static_objects;

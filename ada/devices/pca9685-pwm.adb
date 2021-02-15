-- PCA9685 PWM output services

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

WITH PWM;

USE TYPE PWM.DutyCycle;

PACKAGE BODY PCA9685.PWM IS

  -- PCA9685 PWM output object constructor

  FUNCTION Create
   (device  : NOT NULL PCA9685.Device;
    channel : PCA9685.ChannelNumber;
    duty    : Standard.PWM.DutyCycle := 0.0)
   RETURN Standard.PWM.Output IS

    p : Standard.PWM.Output;

  BEGIN
    p := NEW OutputSubclass'(device, channel);
    p.Put(duty);
    RETURN p;
  END Create;

 -- PCA9685 PWM output methods

  PROCEDURE Put(Self : IN OUT OutputSubclass;
    duty : Standard.PWM.DutyCycle) IS

    offtime : Natural;
    data    : ChannelData;

  BEGIN
    offtime := Natural(duty*40.95);

    data(0) := 0;
    data(1) := 0;
    data(2) := RegisterData(offtime MOD 256);
    data(3) := RegisterData(offtime / 256);

    Self.device.WriteChannel(Self.channel, data);
  END Put;

  PROCEDURE Put
   (Self    : IN OUT OutputSubclass;
    ontime  : Duration) IS

  BEGIN
    Self.Put(Standard.PWM.DutyCycle(ontime*Self.device.frequency*100.0));
  END Put;

  FUNCTION GetPeriod
   (Self    : IN OUT OutputSubclass) RETURN Duration IS

  BEGIN
    RETURN 1.0/Self.device.frequency;
  END GetPeriod;

END PCA9685.PWM;

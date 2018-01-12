-- PCA9685 Servo output services

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Servo;

USE TYPE Servo.Position;

PACKAGE BODY PCA9685.Servo IS

  -- PCA9685 servo output object constructor

  FUNCTION Create
   (device   : PCA9685.Device;
    channel  : ChannelNumber;
    position : Standard.Servo.Position := Standard.Servo.NeutralPosition)
  RETURN Standard.Servo.Interfaces.Output IS

    s : Standard.Servo.Interfaces.Output;

  BEGIN
    s := NEW OutputSubclass'(device, channel);
    s.Put(position);
    RETURN s;
  END Create;

  -- PCA9685 servo output method

  PROCEDURE Put
   (self : IN OUT OutputSubclass;
    pos  : Standard.Servo.Position) IS

    offtime : Natural;
    data    : ChannelData;

  BEGIN
    offtime := Natural((2.0475*Float(pos) + 6.1425)*Float(self.device.frequency));

    data(0) := 0;
    data(1) := 0;
    data(2) := RegisterData(offtime MOD 256);
    data(3) := RegisterData(offtime / 256);

    self.device.WriteChannel(self.channel, data);
  END Put;

END PCA9685.Servo;

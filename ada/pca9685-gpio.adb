-- PCA9685 GPIO output services

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

PACKAGE BODY PCA9685.GPIO IS

  -- Predefined channel settings

  GPIO_ON  : CONSTANT ChannelData := (16#00#, 16#10#, 16#00#, 16#00#);
  GPIO_OFF : CONSTANT ChannelData := (16#00#, 16#00#, 16#00#, 16#10#);

  -- PCA9685 GPIO output object constructor

  FUNCTION Create
   (device  : PCA9685.Device;
    channel : PCA9685.ChannelNumber;
    state   : Boolean := False) RETURN Standard.GPIO.Pin IS

    self : Standard.GPIO.Pin;

  BEGIN
    self := NEW PinSubclass'(device, channel);
    self.Put(state);

    RETURN self;
  END Create;

 -- PCA9685 GPIO read method

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

    data : ChannelData;

  BEGIN
    self.device.ReadChannel(self.channel, data);

    IF data = GPIO_ON THEN
      RETURN True;
    ELSIF data = GPIO_OFF THEN
      RETURN False;
    ELSE
      RAISE PCA9685_ERROR WITH "Unexpected channel settings";
    END IF;
  END Get;

 -- PCA9685 GPIO write method

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

  BEGIN
    IF state THEN
      self.device.WriteChannel(self.channel, GPIO_ON);
    ELSE
      self.device.WriteChannel(self.channel, GPIO_OFF);
    END IF;
  END Put;

END PCA9685.GPIO;

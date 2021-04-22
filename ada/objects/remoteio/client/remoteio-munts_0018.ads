-- Remote I/O Resources available from a MUNTS-0018 Raspberry Pi Tutorial Board

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

WITH Voltage;

PACKAGE RemoteIO.MUNTS_0018 IS

  -- Analog inputs

  ADC0   : CONSTANT RemoteIO.ChannelNumber := 0;
  ADC1   : CONSTANT RemoteIO.ChannelNumber := 1;
  ADC2   : CONSTANT RemoteIO.ChannelNumber := 2;
  ADC3   : CONSTANT RemoteIO.ChannelNumber := 3;

  J10A0  : RemoteIO.ChannelNumber RENAMES ADC2;
  J10A1  : RemoteIO.ChannelNumber RENAMES ADC3;
  J11A0  : RemoteIO.ChannelNumber RENAMES ADC0;
  J11A1  : RemoteIO.ChannelNumber RENAMES ADC1;

  SUBTYPE AnalogInputChannelRange IS RemoteIO.ChannelNumber RANGE ADC0 .. ADC3;

  AnalogInputReference : CONSTANT Voltage.Volts := 3.3;

  -- GPIO pins

  GPIO0  : CONSTANT RemoteIO.ChannelNumber := 0;
  GPIO4  : CONSTANT RemoteIO.ChannelNumber := 4;
  GPIO5  : CONSTANT RemoteIO.ChannelNumber := 5;
  GPIO6  : CONSTANT RemoteIO.ChannelNumber := 6;
  GPIO12 : CONSTANT RemoteIO.ChannelNumber := 12;
  GPIO13 : CONSTANT RemoteIO.ChannelNumber := 13;
  GPIO18 : CONSTANT RemoteIO.ChannelNumber := 18;
  GPIO19 : CONSTANT RemoteIO.ChannelNumber := 19;
  GPIO23 : CONSTANT RemoteIO.ChannelNumber := 23;
  GPIO24 : CONSTANT RemoteIO.ChannelNumber := 24;
  GPIO26 : CONSTANT RemoteIO.ChannelNumber := 26;

  LED    : RemoteIO.ChannelNumber RENAMES GPIO0;  -- Raspberry Pi user LED

  D1     : RemoteIO.ChannelNumber RENAMES GPIO26; -- LED
  SW1    : RemoteIO.ChannelNumber RENAMES GPIO6;  -- Pushbutton switch

  J4D0   : RemoteIO.ChannelNumber RENAMES GPIO23;
  J4D1   : RemoteIO.ChannelNumber RENAMES GPIO24;
  J5D0   : RemoteIO.ChannelNumber RENAMES GPIO5;
  J5D1   : RemoteIO.ChannelNumber RENAMES GPIO4;
  J6D0   : RemoteIO.ChannelNumber RENAMES GPIO12; -- aka PWM0
  J6D1   : RemoteIO.ChannelNumber RENAMES GPIO13;
  J7D0   : RemoteIO.ChannelNumber RENAMES GPIO19; -- aka PWM1
  J7D1   : RemoteIO.ChannelNumber RENAMES GPIO18;

  -- I2C buses

  I2C0   : CONSTANT RemoteIO.ChannelNumber := 0; -- /dev/i2c-1

  J9I2C  : RemoteIO.ChannelNumber RENAMES I2C0;

  -- PWM outputs

  PWM0   : CONSTANT RemoteIO.ChannelNumber := 0;
  PWM1   : CONSTANT RemoteIO.ChannelNumber := 1;

  SUBTYPE PWMOutputChannelRange IS RemoteIO.ChannelNumber RANGE PWM0 .. PWM1;

  J2PWM  : RemoteIO.ChannelNumber RENAMES PWM0;
  J3PWM  : RemoteIO.ChannelNumber RENAMES PWM1;

  J6PWM  : RemoteIO.ChannelNumber RENAMES PWM0;
  J6DIR  : RemoteIO.ChannelNumber RENAMES GPIO13;

  J7PWM  : RemoteIO.ChannelNumber RENAMES PWM1;
  J7DIR  : RemoteIO.ChannelNumber RENAMES GPIO18;

END RemoteIO.MUNTS_0018;

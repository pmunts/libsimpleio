-- Servo output services using the Raspberry Pi LPC1114 I/O Processor Expansion
-- Board MUNTS-0004 (http://git.munts.com/rpi-mcu/expansion/LPC1114)
-- SPI Agent Firmware library libspiagent.so

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

-- NOTE: All four LPC1114 PWM outputs must share the same PWM pulse frequency.
-- The default PWM pulse frequency is 50 Hz and can be changed by calling
-- PWM.SetFrequency().

WITH Servo;
WITH LPC11xx;

PACKAGE Servo.libspiagent IS

  -- LPC1114 I/O Processor Expansion Board servo output pins

  Servo1 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_1; -- aka GPIO1 or PWM1
  Servo2 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_2; -- aka GPIO2 or PWM2
  Servo3 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_3; -- aka GPIO3 or PWM3
  Servo4 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_9; -- aka GPIO7 or PWM4

  -- Type definitions

  TYPE OutputSubclass IS NEW Standard.Servo.Interfaces.OutputInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (id       : LPC11xx.pin_id_t;
    position : Standard.Servo.Position := NeutralPosition;
    defer    : Boolean := False) RETURN Servo.Interfaces.Output;

  -- Methods

  PROCEDURE Put
   (self     : IN OUT OutputSubclass;
    position : Standard.Servo.Position);

PRIVATE

  TYPE OutputSubclass IS NEW Standard.Servo.Interfaces.OutputInterface WITH RECORD
    ID         : LPC11xx.pin_id_t;
    configured : Boolean;
  END RECORD;

END Servo.libspiagent;

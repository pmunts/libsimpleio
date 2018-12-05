-- PWM output services using the Raspberry Pi LPC1114 I/O Processor Expansion
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

WITH PWM;
WITH LPC11xx;

PACKAGE PWM.libspiagent IS

  -- LPC1114 I/O Processor Expansion Board PWM output pins

  PWM1 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_1; -- aka GPIO1
  PWM2 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_2; -- aka GPIO2
  PWM3 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_3; -- aka GPIO3
  PWM4 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_9; -- aka GPIO7

  -- Type definitions

  TYPE Frequency IS NEW Positive RANGE 50 .. 50_000;

  TYPE OutputSubclass IS NEW Standard.PWM.Interfaces.OutputInterface WITH PRIVATE;

  -- Instantiate a text I/O package for Frequency

  PACKAGE Frequency_IO IS NEW Ada.Text_IO.Integer_IO(Frequency);

  -- Constructors

  FUNCTION Create
   (id    : LPC11xx.pin_id_t;
    duty  : Standard.PWM.DutyCycle := 0.0;
    defer : Boolean := False) RETURN PWM.Interfaces.Output;

  -- Methods

  PROCEDURE Put
   (self : IN OUT OutputSubclass;
    duty : Standard.PWM.DutyCycle);

  -- If you don't call SetFrequency(), the default PWM pulse frequency is
  -- 50 Hz. All LPC1114 PWM outputs operate at the same pulse frequency.

  PROCEDURE SetFrequency(freq : Frequency);

PRIVATE

  TYPE OutputSubclass IS NEW Standard.PWM.Interfaces.OutputInterface WITH RECORD
    ID         : LPC11xx.pin_id_t;
    configured : Boolean;
  END RECORD;

END PWM.libspiagent;

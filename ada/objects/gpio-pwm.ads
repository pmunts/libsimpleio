-- GPIO pin services using the PWM outputs

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

-- Use cases for this package include on/off things like an LED or a solenoid
-- valve driven from a PWM output.

-- WARNING: Depending on the PWM hardware implementation, the off duty cycle
-- may be slightly greater than 0 % and/or the on duty cycle may be slightly
-- less than 100 %.

WITH PWM;

PACKAGE GPIO.PWM IS

  TYPE PinSubclass IS NEW PinInterface WITH PRIVATE;

  Destroyed : CONSTANT PinSubclass;

  -- GPIO pin object constructor

  FUNCTION Create
   (outp  : NOT NULL Standard.PWM.Output;
    state : Boolean := False;
    duty  : Standard.PWM.DutyCycle := Standard.PWM.MaximumDutyCycle) RETURN Pin;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (Self  : IN OUT PinSubclass;
    outp  : NOT NULL Standard.PWM.Output;
    state : Boolean := False;
    duty  : Standard.PWM.DutyCycle := Standard.PWM.MaximumDutyCycle);

  -- GPIO pin object destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass);

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  TYPE PinSubclass IS NEW PinInterface WITH RECORD
    outp  : Standard.PWM.Output := NULL;
    duty  : Standard.PWM.DutyCycle := Standard.PWM.MinimumDutyCycle;
    state : Boolean := False;
  END RECORD;

  Destroyed : CONSTANT PinSubclass :=
    PinSubclass'(NULL, Standard.PWM.MaximumDutyCycle, False);

END GPIO.PWM;

-- Template for servos controlled by a variable width control pulse
-- realized with an underlying PWM output

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Servo.PWM_Template IS

  Swing    : CONSTANT Duration := (MaximumWidth - MinimumWidth)/2;
  Midpoint : CONSTANT Duration := MinimumWidth + Swing;

  -- Servo output object constructor

  FUNCTION Create
   (output   : NOT NULL PWM.Output;
    position : Servo.Position := Servo.NeutralPosition)
    RETURN Servo.Output IS

    outp : Servo.Output;

  BEGIN
    IF MaximumWidth > output.GetPeriod THEN
      RAISE Servo_Error WITH "PWM pulse frequency is too high";
    END IF;

    outp := NEW OutputSubclass'(output => output);
    outp.Put(position);

    RETURN outp;
  END Create;

  -- Servo output write method

  PROCEDURE Put
   (Self     : IN OUT OutputSubclass;
    position : Servo.Position) IS

  BEGIN
    Self.output.Put(Midpoint + Swing*Duration(position));
  END Put;

END Servo.PWM_Template;

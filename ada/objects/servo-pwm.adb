-- Servo output services using a PWM output

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

PACKAGE BODY Servo.PWM IS

  -- Servo output object constructor

  FUNCTION Create
   (output    : Standard.PWM.Interfaces.Output;
    frequency : Positive := 50;
    position  : Servo.Position := Servo.NeutralPosition)
    RETURN Servo.Interfaces.Output IS

    outp : Servo.Interfaces.Output;

  BEGIN
    IF frequency > Servo.MaximumFrequency THEN
      RAISE Servo_Error WITH "Frequency parameter is out of range";
    END IF;

    outp := NEW OutputSubclass'(output, 1000000000/frequency);
    outp.Put(position);

    RETURN outp;
  END Create;

  -- Servo output write method

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    position  : Servo.Position) IS

    ontime : Positive; -- nanoseconds

  BEGIN
    ontime := 1500000 + Integer(500000.0*position + 0.5);
    Self.output.Put(Standard.PWM.DutyCycle(Float(ontime)/Float(Self.period)*100.0));
  END Put;

END Servo.PWM;

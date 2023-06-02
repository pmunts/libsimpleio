-- I/O Resources provided by the MUNTS-0018 Raspberry Pi Tutorial I/O Board

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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
WITH Motor;
WITH Servo;

PACKAGE MUNTS_0018.PWM IS

  FUNCTION Create_PWM_Output
   (connector : ConnectorID;
    frequency : Positive;
    dutycycle : Standard.PWM.DutyCycle := Standard.PWM.MinimumDutyCycle)
    RETURN Standard.PWM.Output;

  FUNCTION Create_Motor_Output
   (connector : ConnectorID;
    frequency : Positive;
    velocity  : Motor.Velocity := 0.0) RETURN Motor.Output;

  FUNCTION Create_MD13S_Output
   (connector : ConnectorID;
    frequency : Positive;
    velocity  : Motor.Velocity := 0.0) RETURN Motor.Output;

  FUNCTION Create_Servo_Output
   (connector : ConnectorID;
    frequency : Positive := 50;
    position  : Servo.Position := Servo.NeutralPosition) RETURN Servo.Output;

END MUNTS_0018.PWM;

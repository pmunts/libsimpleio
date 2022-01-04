-- I/O Resources provided by the MUNTS-0018 Raspberry Pi Tutorial I/O Board

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

WITH Cytron_MD13S;
WITH Device;
WITH GPIO.libsimpleio;
WITH Motor.PWM;
WITH PWM.libsimpleio;
WITH Servo.PWM;

PACKAGE BODY MUNTS_0018.PWM IS

  -- Connector to Device.Designator maps

  PWM_Designators : CONSTANT ConnectorMap :=
   (J2     => J2PWM,
    J3     => J3PWM,
    J6     => J6PWM,
    J7     => J7PWM,
    OTHERS => Device.Unavailable);

  Motor_PWM_Designators : CONSTANT ConnectorMap :=
   (J6     => J6PWM,
    J7     => J7PWM,
    OTHERS => Device.Unavailable);

  Motor_Direction_Designators : CONSTANT ConnectorMap :=
   (J6     => J6DIR,
    J7     => J7DIR,
    OTHERS => Device.Unavailable);

  Motor_Enable_Designators : CONSTANT ConnectorMap :=
   (J6     => J6DIR,
    J7     => J7DIR,
    OTHERS => Device.Unavailable);

  Servo_Designators : CONSTANT ConnectorMap :=
   (J2     => J2PWM,
    J3     => J3PWM,
    OTHERS => Device.Unavailable);

  -----------------------------------------------------------------------------

  FUNCTION Create_PWM_Output
   (connector : ConnectorID;
    frequency : Positive;
    dutycycle : Standard.PWM.DutyCycle := Standard.PWM.MinimumDutyCycle)
    RETURN Standard.PWM.Output IS

  BEGIN
    CheckConnector(PWM_Designators, connector);

    RETURN Standard.PWM.libsimpleio.Create
     (PWM_Designators(connector), frequency, dutycycle);
  END Create_PWM_Output;

  FUNCTION Create_Motor_Output
   (connector : ConnectorID;
    frequency : Positive;
    velocity  : Motor.Velocity := 0.0) RETURN Motor.Output IS

  BEGIN
    CheckConnector(Motor_PWM_Designators, connector);
    CheckConnector(Motor_Direction_Designators, connector);

    RETURN Motor.PWM.Create
     (Standard.PWM.libsimpleio.Create
       (Motor_PWM_Designators(connector), frequency),
      GPIO.libsimpleio.Create
       (Motor_Direction_Designators(connector), GPIO.Output), velocity);
  END Create_Motor_Output;

  FUNCTION Create_MD13S_Output
   (connector : ConnectorID;
    frequency : Positive;
    velocity  : Motor.Velocity := 0.0) RETURN Motor.Output IS

  BEGIN
    CheckConnector(Motor_PWM_Designators, connector);
    CheckConnector(Motor_Enable_Designators, connector);

    RETURN Cytron_MD13S.Create
     (Standard.PWM.libsimpleio.Create
       (Motor_PWM_Designators(connector), frequency),
      GPIO.libsimpleio.Create
       (Motor_Enable_Designators(connector), GPIO.Output), velocity);
  END Create_MD13S_Output;

  FUNCTION Create_Servo_Output
   (connector : ConnectorID;
    frequency : Positive := 50;
    position  : Servo.Position := Servo.NeutralPosition) RETURN Servo.Output IS

  BEGIN
    CheckConnector(Servo_Designators, connector);

    RETURN Servo.PWM.Create
     (Standard.PWM.libsimpleio.Create
      (Servo_Designators(connector), frequency), position);
  END Create_Servo_Output;

END MUNTS_0018.PWM;

-- Raspberry Pi LPC1114 I/O Processor Ada
-- H-bridge DC motor driver output test program

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

-- Direction out on GPIO0
-- PWM       out on GPIO1 aka PWM1

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;

WITH Motor;
WITH LPC1114IOP.Pins;        USE LPC1114IOP.Pins;
WITH LPC1114IOP.PWM;         USE LPC1114IOP.PWM;
WITH LPC1114IOP.Transport;

PROCEDURE test_lpc1114iop_motor IS

  servername : Unbounded_String;
  Frequency  : pwm_frequency_t;
  Motor1     : Motor.Output;
  Velocity   : Motor.Velocity;

  PACKAGE Frequency_IO IS NEW Integer_IO(pwm_frequency_t);
  PACKAGE Velocity_IO  IS NEW Float_IO(Motor.Velocity);

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor DC Motor Test");
  New_Line;

  -- Analyze command line parameters

  IF Argument_Count = 0 THEN
    servername := To_Unbounded_String("localhost");
  ELSIF Argument_Count = 1 THEN
    servername := To_Unbounded_String(Argument(1));
  ELSE
    Put_Line("Usage: " & Command_Name & " [hostname]");
    RETURN;
  END IF;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Open(To_String(servername));

  -- Get PWM frequency from user

  Put("Enter PWM frequency: (50-50000)   ");
  Frequency_IO.Get(Frequency, 0);

  -- Configure I/O pins

  Motor1 := Create(LPC1114IOP.Pins.LPC1114_PWM1, LPC1114IOP.Pins.LPC1114_GPIO0, Frequency);

  -- Set motor speed

  Mainloop : LOOP
    Put("Enter motor speed (-1.0 to +1.0): ");
    Velocity_IO.Get(Velocity, 0);
    Motor1.Put(Velocity);
  END LOOP Mainloop;
END test_lpc1114iop_motor;

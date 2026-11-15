-- Raspberry Pi LPC1114 I/O Processor Expansion Board Ada
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

WITH spi_agent.pins;        USE spi_agent.pins;
WITH spi_agent.pwm;         USE spi_agent.pwm;
WITH spi_agent.transport;

PROCEDURE test_motor IS

  servername : Unbounded_String;
  error      : Integer;
  Frequency  : pwm_frequency_t;
  Motor1     : Motor;
  Speed      : motor_speed_t;

  PACKAGE frequency_io IS NEW Integer_IO(pwm_frequency_t);
  USE frequency_io;

  PACKAGE speed_io IS NEW Float_IO(motor_speed_t);
  USE speed_io;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board DC Motor Test");
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

  spi_agent.transport.open(To_String(servername) & ASCII.NUL, error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.open() failed, error:" & Integer'IMAGE(error);
  END IF;

  -- Get PWM frequency from user

  Put("Enter PWM frequency: (50-50000)   ");
  Get(Frequency, 0);

  -- Configure I/O pins

  Motor1 := Create(LPC1114_PWM1, LPC1114_GPIO0, Frequency);

  -- Set motor speed

  Mainloop : LOOP
    Put("Enter motor speed (-1.0 to +1.0): ");
    Get(Speed, 0);
    Motor1.Put(Speed);
  END LOOP Mainloop;
END test_motor;

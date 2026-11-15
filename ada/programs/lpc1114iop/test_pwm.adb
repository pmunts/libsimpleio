-- Raspberry Pi LPC1114 I/O Processor Expansion Board Ada PWM test program

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

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;

WITH spi_agent.pwm;         USE spi_agent.pwm;
WITH spi_agent.transport;

PROCEDURE test_pwm IS

  servername : Unbounded_String;
  error      : Integer;
  Frequency  : pwm_frequency_t;
  Outputs    : ARRAY (pwm_channel_t) OF PWM;
  Channel    : Integer;
  DutyCycle  : pwm_dutycycle_t;

  PACKAGE frequency_io IS NEW Integer_IO(pwm_frequency_t);
  USE frequency_io;

  PACKAGE int_io IS NEW Integer_IO(Integer);
  USE int_io;

  PACKAGE dutycycle_io IS NEW Float_IO(pwm_dutycycle_t);
  USE dutycycle_io;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board PWM Output Test");
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

  Put("Enter PWM frequency:              ");
  Get(Frequency, 0);

  -- Configure PWM outputs

  FOR c IN pwm_channel_t LOOP
    Outputs(c) := Create(c, Frequency);
  END LOOP;

  -- Set duty cycles

  Mainloop : LOOP
    Put("Enter PWM channel number (1-4):   ");
    Get(Channel, 0);

    IF Channel = 0 THEN
      EXIT Mainloop;
    ELSIF Channel >= 1 AND Channel <= 4 THEN
      Put("Enter PWM duty cycle % (0-100.0): ");
      Get(DutyCycle, 0);
      Outputs(pwm_channel_t(Channel)).Put(DutyCycle);
    END IF;
  END LOOP Mainloop;

  -- Deinitialize the SPI Agent Firmware transport library

  spi_agent.transport.close(error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_pwm;

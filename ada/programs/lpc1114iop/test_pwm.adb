-- Raspberry Pi LPC1114 I/O Processor Ada PWM test program

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

WITH PWM;
WITH LPC1114IOP.Pins;
WITH LPC1114IOP.PWM;
WITH LPC1114IOP.Transport;

PROCEDURE test_pwm IS

  servername : Unbounded_String;
  error      : Integer;
  Frequency  : LPC1114IOP.PWM.pwm_frequency_t;
  Outputs    : ARRAY (LPC1114IOP.Pins.PWM_PINS'Range) OF PWM.Output;
  Channel    : Natural;
  DutyCycle  : PWM.DutyCycle;

  PACKAGE Channel_IO   IS NEW Integer_IO(Natural);
  PACKAGE DutyCycle_IO IS NEW Float_IO(PWM.DutyCycle);
  PACKAGE Frequency_IO IS NEW Integer_IO(LPC1114IOP.PWM.pwm_frequency_t);

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor PWM Output Test");
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

  LPC1114IOP.Transport.open(To_String(servername) & ASCII.NUL, error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.SpiAgentError WITH
      "LPC1114IOP.Transport.open() failed, error:" & Integer'IMAGE(error);
  END IF;

  -- Get PWM frequency from user

  Put("Enter PWM frequency:              ");
  Frequency_IO.Get(Frequency, 0);

  -- Configure PWM outputs

  FOR i IN Outputs'Range LOOP
    Outputs(i) := LPC1114IOP.PWM.Create(LPC1114IOP.Pins.PWM_PINS(i), Frequency);
  END LOOP;

  -- Set duty cycles

  Mainloop : LOOP
    Put("Enter PWM channel number (1-4):   ");
    Channel_IO.Get(Channel, 0);

    IF Channel = 0 THEN
      EXIT Mainloop;
    ELSE
      Put("Enter PWM duty cycle % (0-100.0): ");
      DutyCycle_IO.Get(DutyCycle, 0);
      Outputs(Channel).Put(DutyCycle);
    END IF;
  END LOOP Mainloop;

  -- Deinitialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.close(error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.SpiAgentError WITH
      "LPC1114IOP.Transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_pwm;

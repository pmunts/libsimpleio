-- Raspberry Pi LPC1114 I/O Processor SONAR Test

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

-- LPC1114 GPIO0 -- Echo pulse input
-- LPC1114 GPIO1 -- Trigger pulse output

-- NOTE: This program is written for and tested with 4-pin ultrasonic
-- modules like the HC-SR04.  To use a 3-pin module like the Parallax
-- Ping, connect GPIO1 to GPIO0 through a Schottky signal diode like the
-- BAT43, anode to GPIO1 and cathode to GPIO0.

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;
WITH CRT;                   USE CRT;

WITH GPIO;
WITH LPC1114IOP.GPIO;
WITH LPC1114IOP.Pins;
WITH LPC1114IOP.Timer;       USE LPC1114IOP.Timer;
WITH LPC1114IOP.Transport;

PROCEDURE test_lpc1114iop_sonar IS

  servername : Unbounded_String;
  timer1     : Timer;
  trigger    : GPIO.Pin;
  count      : LPC1114IOP.Timer.timer_count_t;
  distance   : Integer;

  PACKAGE int_io IS NEW Integer_IO(Integer);
  USE int_io;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor SONAR Test");
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

  LPC1114IOP.Transport.Open(To_String(servername) & ASCII.NUL);

  -- Configure LPC1114 timer 1 to measure pulse width on CAP0 input

  timer1 := Create(LPC1114_CT32B1);

  timer1.ConfigurePrescaler(1);

  timer1.ConfigureCapture(LPC1114_TIMER_CAPTURE_EDGE_CAP0_BOTH,
    LPC1114_TIMER_CAPTURE_INTERRUPT_DISABLE);

  timer1.ConfigureMode(LPC1114_TIMER_MODE_PCLK);

  -- Configure the trigger pulse output

  trigger := LPC1114IOP.GPIO.Create(LPC1114IOP.Pins.LPC1114_GPIO1, GPIO.Output);

  -- Peform sonar ranging

  Put_Line("Press any key to exit program");
  New_Line;

  LOOP

    -- Pulse trigger output

    trigger.put(TRUE);
    trigger.put(FALSE);

    DELAY 0.1;

    -- Get echo pulse width result

    count := timer1.GetCaptureDelta;

    -- Calculate range

    distance := Integer(Float(count)/282.35);

    -- Display result

    IF distance < 2000 THEN
      Put("Detection! Range is ");
      Put(distance, 1);
      Put(" mm");
    ELSE
      Put("Probing...                 ");
    END IF;

    Put(ASCII.CR);

    EXIT WHEN KeyPressed;

    DELAY 0.9;
  END LOOP;

  -- Close the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_sonar;

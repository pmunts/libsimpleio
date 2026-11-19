-- Raspberry Pi LPC1114 I/O Processor
-- Ada frequency counter test program

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
WITH Ada.Float_Text_IO;     USE Ada.Float_Text_IO;
WITH CRT;                   USE CRT;

WITH LPC1114IOP.Timer;       USE LPC1114IOP.Timer;
WITH LPC1114IOP.Transport;

PROCEDURE test_frequency_counter IS

  servername : Unbounded_String;
  count      : LPC1114IOP.Timer.timer_count_t;
  freq       : Float;
  Timer0     : Timer;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Frequency Counter Test");
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

  -- Instantiate an LPC1114 timer object

  Timer0 := Create(LPC1114_CT32B0);

  -- Initialize the timer to count PCLK pulses between CAP0 input edges

  Timer0.ConfigurePrescaler(1);

  Timer0.ConfigureCapture(LPC1114_TIMER_CAPTURE_EDGE_CAP0_RISING,
    LPC1114_TIMER_CAPTURE_INTERRUPT_DISABLE);

  Timer0.ConfigureMode(LPC1114_TIMER_MODE_PCLK);

  -- Display the input frequency

  Put_Line("Press any key to exit program");
  New_Line;

  LOOP
    count := Timer0.GetCaptureDelta;

    IF count < 1920 THEN
      freq := 0.0;
    ELSE
      freq := Float(PCLK_FREQUENCY)/Float(count);
    END IF;

    Put(ASCII.CR);
    Put("Frequency: ");
    Put(freq, 5, 1, 0);
    Put(" Hz");

    EXIT WHEN KeyPressed;

    DELAY 1.0;
  END LOOP;

  -- Close the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_frequency_counter;

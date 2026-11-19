-- Raspberry Pi LPC1114 I/O Processor
-- square wave output test program

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

WITH LPC1114IOP.Timer;       USE LPC1114IOP.Timer;
WITH LPC1114IOP.Transport;

PROCEDURE test_square_wave IS

  servername : Unbounded_String;
  freq       : Integer;
  Timer1     : Timer;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Square Wave Output Test");
  New_Line;

  -- Analyze command line parameters

  IF Argument_Count = 0 THEN
    servername := To_Unbounded_String("localhost");
    freq := 1000;
  ELSIF Argument_Count = 1 THEN
    servername := To_Unbounded_String(Argument(1));
    freq := 1000;
  ELSIF Argument_Count = 2 THEN
    servername := To_Unbounded_String(Argument(1));
    freq := Integer'VALUE(Argument(2));
  ELSE
    Put_Line("Usage: " & Command_Name & " [hostname] [frequency]");
    RETURN;
  END IF;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Open(To_String(servername) & ASCII.NUL);

  -- Instantiate an LPC1114 timer object

  Timer1 := Create(LPC1114_CT32B1);

  -- Configure the timer to generate a square wave

  Timer1.ConfigurePrescaler(1);

  Timer1.ConfigureMatch(LPC1114_TIMER_MATCH0, timer_count_t(PCLK_FREQUENCY/freq/2),
    LPC1114_TIMER_MATCH_OUTPUT_TOGGLE, LPC1114_TIMER_MATCH_INTERRUPT_DISABLE,
    LPC1114_TIMER_MATCH_RESET_ENABLE, LPC1114_TIMER_MATCH_STOP_DISABLE);

  Timer1.ConfigureMode(LPC1114_TIMER_MODE_PCLK);

  -- Close the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_square_wave;

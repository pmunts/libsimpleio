-- Raspberry Pi LPC1114 I/O Processor ADC Input Test"

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

WITH CRT;
WITH LPC1114IOP.ADC;
WITH LPC1114IOP.Pins;
WITH LPC1114IOP.Transport;
WITH Voltage;

PROCEDURE test_lpc1114iop_adc IS

  servername : Unbounded_String;
  AIN1       : Voltage.Input;
  AIN2       : Voltage.Input;
  AIN3       : Voltage.Input;
  AIN4       : Voltage.Input;
  AIN5       : Voltage.Input;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor ADC Input Test");
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

  -- Configure I/O pins

  AIN1 := LPC1114IOP.ADC.Create(LPC1114IOP.Pins.LPC1114_ADC1);
  AIN2 := LPC1114IOP.ADC.Create(LPC1114IOP.Pins.LPC1114_ADC2);
  AIN3 := LPC1114IOP.ADC.Create(LPC1114IOP.Pins.LPC1114_ADC3);
  AIN4 := LPC1114IOP.ADC.Create(LPC1114IOP.Pins.LPC1114_ADC4);
  AIN5 := LPC1114IOP.ADC.Create(LPC1114IOP.Pins.LPC1114_ADC5);

  CRT.ClrScr;
  CRT.GotoXY(1, 1);
  Put("Raspberry Pi LPC1114 I/O Processor ADC Input Test");

  CRT.GotoXY(1, 9);
  Put("Press any key to exit program");

  LOOP
    CRT.GotoXY(1, 3); Put("ADC Input 1 is "); Voltage.Volts_IO.Put(AIN1.Get, 1, 2, 0); Put("V");
    CRT.GotoXY(1, 4); Put("ADC Input 2 is "); Voltage.Volts_IO.Put(AIN2.Get, 1, 2, 0); Put("V");
    CRT.GotoXY(1, 5); Put("ADC Input 3 is "); Voltage.Volts_IO.Put(AIN3.Get, 1, 2, 0); Put("V");
    CRT.GotoXY(1, 6); Put("ADC Input 4 is "); Voltage.Volts_IO.Put(AIN4.Get, 1, 2, 0); Put("V");
    CRT.GotoXY(1, 7); Put("ADC Input 5 is "); Voltage.Volts_IO.Put(AIN5.Get, 1, 2, 0); Put("V");
    CRT.GotoXY(1, 10);

    EXIT WHEN CRT.KeyPressed;

    DELAY 1.0;
  END LOOP;

  CRT.GotoXY(1, 9);
  CRT.ClrEol;

  -- Close the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_adc;

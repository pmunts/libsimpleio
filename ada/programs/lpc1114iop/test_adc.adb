-- Raspberry Pi LPC1114 I/O Processor Expansion Board Ada A/D test program

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
WITH CRT;                   USE CRT;

WITH spi_agent.analog;      USE spi_agent.analog;
WITH spi_agent.pins;        USE spi_agent.pins;
WITH spi_agent.transport;

PROCEDURE test_adc IS

  servername : Unbounded_String;
  error      : Integer;
  AD1        : ADC;
  AD2        : ADC;
  AD3        : ADC;
  AD4        : ADC;
  AD5        : ADC;

  PACKAGE AnalogIO is NEW Float_IO(analog_voltage_t);
  USE AnalogIO;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board Analog Input Test");
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

  -- Configure I/O pins

  AD1 := Create(LPC1114_AD1);
  AD2 := Create(2);
  AD3 := Create(LPC1114_AD3);
  AD4 := Create(4);
  AD5 := Create(LPC1114_AD5);

  ClrScr;
  GotoXY(1, 1);
  Put("Raspberry Pi LPC1114 I/O Processor Expansion Board Analog Input Test");

  GotoXY(1, 9);
  Put("Press any key to exit program");

  LOOP
    GotoXY(1, 3); Put("Analog Input 1 is "); Put(Get(AD1), 1, 2, 0); Put("V");
    GotoXY(1, 4); Put("Analog Input 2 is "); Put(AD2.Get, 1, 2, 0);  Put("V");
    GotoXY(1, 5); Put("Analog Input 3 is "); Put(Get(AD3), 1, 2, 0); Put("V");
    GotoXY(1, 6); Put("Analog Input 4 is "); Put(AD4.Get, 1, 2, 0);  Put("V");
    GotoXY(1, 7); Put("Analog Input 5 is "); Put(Get(AD5), 1, 2, 0); Put("V");
    GotoXY(1, 10);

    EXIT WHEN KeyPressed;

    DELAY 1.0;
  END LOOP;

  GotoXY(1, 9);
  ClrEol;

  -- Close the SPI Agent Firmware transport library

  spi_agent.transport.close(error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_adc;

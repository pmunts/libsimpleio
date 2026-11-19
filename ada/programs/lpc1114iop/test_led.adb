-- Raspberry Pi LPC1114 I/O Processor Expansion Board Ada LED test program

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
WITH GPIO;
WITH spi_agent.gpio;
WITH spi_agent.pins;
WITH spi_agent.transport;

PROCEDURE test_led IS

  servername : Unbounded_String;
  error      : Integer;
  LED        : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board LED Test");
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

  -- Configure the LED pin

  LED := spi_agent.gpio.Create(spi_agent.pins.LPC1114_LED, GPIO.OUTPUT, False);

  Put_Line("Press any key to exit program");
  New_Line;

  -- Flash the LED

  LOOP
    IF LED.Get THEN
      Put_Line("Turning LED OFF");
    ELSE
      Put_Line("Turning LED ON");
    END IF;

    LED.Put(NOT LED.Get);

    EXIT WHEN CRT.KeyPressed;

    DELAY 1.0;
  END LOOP;

  -- Close the SPI Agent Firmware transport library

  spi_agent.transport.close(error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_led;

-- Raspberry Pi LPC1114 I/O Processor button and LED test

-- Copyright (C)2017-2026, Philip Munts, President, Munts AM Corp.
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

-- NOTE: The button input has the internal pullup resistor enabled, so the
-- switch should be connected from GPIO0 to ground.

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;

WITH CRT;
WITH GPIO;
WITH LPC1114IOP.GPIO;        USE LPC1114IOP.GPIO;
WITH LPC1114IOP.Pins;        USE LPC1114IOP.Pins;
WITH LPC1114IOP.Transport;

PROCEDURE test_button_led IS

  servername : Unbounded_String;
  error      : Integer;
  Button     : GPIO.Pin;
  LED        : GPIO.Pin;
  newstate   : Boolean;
  oldstate   : Boolean;

BEGIN
  Put_Line("Raspberry Pi LPC1114 I/O Processor Button and LED Test");
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

  -- Configure the LED pin

  Button := Create(LPC1114_GPIO0, Standard.GPIO.Input);
  LED    := Create(LPC1114_LED, Standard.GPIO.Output);

  -- Force initial detection

  oldstate := Button.Get;

  LOOP
    newstate := NOT Button.Get;

    IF newstate /= oldstate THEN
      IF newstate THEN
        Put_Line("PRESSED");
        LED.Put(True);
      ELSE
        Put_Line("RELEASED");
        LED.Put(False);
      END IF;

      oldstate := newstate;
    END IF;

    EXIT WHEN CRT.KeyPressed;
  END LOOP;
END test_button_led;

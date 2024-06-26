-- Interrupt Button and LED Test using libsimpleio

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO.libsimpleio;

PROCEDURE test_interrupt_button_led IS

  Button   : GPIO.Pin;
  LED      : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("Interrupt Button and LED Test using libsimpleio");
  New_Line;

  -- Configure button and LED GPIO's

  Button := GPIO.libsimpleio.Create((0, 6), GPIO.Input,
    edge => GPIO.libsimpleio.Both);

  LED := GPIO.libsimpleio.Create((0, 26), GPIO.Output);

  LOOP
    IF Button.Get THEN
      Put_Line("PRESSED");
      LED.Put(True);
    ELSE
      Put_Line("RELEASED");
      LED.Put(False);
    END IF;
  END LOOP;
END test_interrupt_button_led;

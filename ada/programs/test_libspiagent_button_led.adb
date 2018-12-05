-- Raspberry Pi LPC1114 I/O Processor Expansion Board button and LED test

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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
WITH Interfaces;

WITH errno;
WITH GPIO;
WITH GPIO.libspiagent;
WITH libspiagent;

USE TYPE Interfaces.Integer_32;

PROCEDURE test_libspiagent_button_led IS

  error    : Interfaces.Integer_32;
  Button   : GPIO.Pin;
  LED      : GPIO.Pin;
  newstate : Boolean;
  oldstate : Boolean;

BEGIN
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board Button and LED Test");
  New_Line;

  -- Open libspiagent

  libspiagent.Open(libspiagent.Localhost, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "spiagent_open() failed, " &
      errno.strerror(Integer(error));
  END IF;

  -- Configure button and LED GPIO's

  Button := GPIO.libspiagent.Create(GPIO.libspiagent.GPIO0,
    GPIO.libspiagent.InputPullup);

  LED    := GPIO.libspiagent.Create(GPIO.libspiagent.LED, GPIO.Output, False);

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
  END LOOP;
END test_libspiagent_button_led;

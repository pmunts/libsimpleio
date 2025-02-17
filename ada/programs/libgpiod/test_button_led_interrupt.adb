-- Button and LED Test using libgpiod

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH GPIO.libgpiod;
WITH libLinux;

PROCEDURE test_button_led_interrupt IS

  Button   : GPIO.Pin;
  LED      : GPIO.Pin;
  fd       : Integer;
  error    : Integer;

BEGIN
  New_Line;
  Put_Line("Button and LED Test using libgpiod");
  New_Line;

  -- Configure button and LED GPIO's

  Button := GPIO.libgpiod.Create((0, 6), GPIO.Input,
    debounce => 0.05, edge => GPIO.libgpiod.Both);

  LED := GPIO.libgpiod.Create((0, 26), GPIO.Output);

  fd := GPIO.libgpiod.PinSubclass(Button.ALL).fd;

  LOOP
    libLinux.PollInput(fd, 1000, error);

    IF error = errno.EAGAIN THEN
      Put_Line("Tick...");
    ELSIF error /= 0 THEN
      Put_Line("ERROR: Poll() failed, " & errno.strerror(error));
    ELSIF Button.Get THEN
      Put_Line("PRESSED");
      LED.Put(True);
    ELSE
      Put_Line("RELEASED");
      LED.Put(False);
    END IF;
  END LOOP;
END test_button_led_interrupt;

-- Button and LED Test using libsimpleio

-- Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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
WITH GPIO.libsimpleio;
WITH libLinux;

PROCEDURE test_button_led_interrupt IS

  Button   : GPIO.Pin;
  LED      : GPIO.Pin;
  fd       : Integer;
  files    : libLinux.FilesType(0 .. 0);
  events   : libLinux.EventsType(0 .. 0);
  results  : libLinux.ResultsType(0 .. 0);
  error    : Integer;

BEGIN
  New_Line;
  Put_Line("Button and LED Test using libsimpleio");
  New_Line;

  -- Configure button and LED GPIO's

  Button := GPIO.libsimpleio.Create((0, 6), GPIO.Input,
    edge => GPIO.libsimpleio.Both);

  LED := GPIO.libsimpleio.Create((0, 26), GPIO.Output);

  LOOP
    files(0)   := GPIO.libsimpleio.PinSubclass(Button.ALL).fd;
    events(0)  := libLinux.POLLIN;
    results(0) := 0;

    libLinux.Poll(1, files, events, results, 1000, error);

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

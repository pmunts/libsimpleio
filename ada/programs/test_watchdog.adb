-- Linux Simple I/O watchdog timer test

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Watchdog;
WITH Watchdog.libsimpleio;

PROCEDURE test_watchdog IS

  wd : Watchdog.Timer;

BEGIN
  Put("Watchdog Timer Test");
  New_Line;
  New_Line;

  -- Create a watchdog timer device object

  wd := Watchdog.libsimpleio.Create;

  -- Display the default watchdog timeout period

  Put_Line("Default period:" & Duration'Image(wd.GetTimeout));

  -- Change the watchdog timeout period to 5 seconds

  wd.SetTimeout(5.0);

  -- Display the new watchdog timeout period

  Put_Line("New period:    " & Duration'Image(wd.GetTimeout));
  New_Line;

  -- Kick the watchdog timer for 5 seconds

  FOR i IN Integer RANGE 1 .. 5 LOOP
    Put_Line("Kick the dog...");
    wd.Kick;

    DELAY 1.0;
  END LOOP;

  New_Line;

  -- Now don't kick the watchdog timer

  FOR i IN Integer RANGE 1 .. 10 LOOP
    Put_Line("Don't kick the dog...");

    DELAY 1.0;
  END LOOP;
END test_watchdog;

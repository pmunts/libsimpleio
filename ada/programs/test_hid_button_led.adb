-- Linux Simple I/O Library HID button and LED test

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
WITH System;

WITH HID.libsimpleio;
WITH Message64;

PROCEDURE test_hid_button_led IS

  dev         : Message64.Messenger;
  ButtonState : Message64.Message;
  LEDCommand  : Message64.Message;

BEGIN
  New_Line;
  Put_Line("HID Button and LED Test using libsimpleio");
  New_Line;

  -- Open the raw HID device

  dev := HID.libsimpleio.Create(timeoutms => -1);

  -- Event loop

  LOOP
    ButtonState := (OTHERS => 0);
    LEDCommand  := (OTHERS => 0);

    dev.Receive(ButtonState);

    IF Integer(ButtonState(0)) /= 0 THEN
      Put_Line("PRESS");
      LEDCommand(0) := 1;
    ELSE
      Put_Line("RELEASE");
      LEDCommand(0) := 0;
    END IF;

    dev.Send(LEDCommand);
  END LOOP;
END test_hid_button_led;

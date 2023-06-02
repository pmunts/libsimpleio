-- Mikroelektronika Relay Click (MIKROE-1370) Toggle Test

-- Copyright (C)2022-2023, Philip Munts dba Munts Technologies.
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
-- POSSIBILITY OF SUCH DAMAGE.test_clickboard_relay

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.Relay.SimpleIO;
WITH GPIO;

PROCEDURE test_clickboard_relay IS

  Relay1 : CONSTANT GPIO.Pin := ClickBoard.Relay.SimpleIO.Create(1, 1);
  Relay2 : CONSTANT GPIO.Pin := ClickBoard.Relay.SimpleIO.Create(1, 2);

BEGIN
  New_Line;
  Put_Line("Mikroelektronika Relay Click (MIKROE-1370) Toggle Test");
  New_Line;

  LOOP
    Relay1.Put(True);
    Relay2.Put(False);
    DELAY 1.0;
    Relay1.Put(False);
    Relay2.Put(True);
    DELAY 1.0;
  END LOOP;
END test_clickboard_relay;

-- Mikroelektronika Expand2 Click GPIO Toggle Test

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH ClickBoard.Expand2.RemoteIO;
WITH GPIO;
WITH HID.hidapi;
WITH MCP23017.GPIO;
WITH RemoteIO.Client;

PROCEDURE test_clickboard_expand2 IS

  remdev : RemoteIO.Client.Device;
  dev    : MCP23017.Device;
  pins   : ARRAY (MCP23017.GPIO.PinNumber) OF GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika Expand2 Click GPIO Toggle Test");
  New_Line;

  -- Create MCP23017 device object

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);
  dev    := ClickBoard.Expand2.RemoteIO.Create(remdev, socknum => 1);

  -- Configure GPIO pins

  FOR n IN pins'Range LOOP
    pins(n) := MCP23017.GPIO.Create(dev, n, GPIO.Output);
  END LOOP;

  -- Toggle GPIO pins

  Put_Line("Toggling pins...");

  LOOP
    FOR p OF pins LOOP
      p.Put(NOT p.Get);
    END LOOP;
  END LOOP;
END test_clickboard_expand2;

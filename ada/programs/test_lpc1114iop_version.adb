-- Raspberry Pi LPC1114 I/O Processor Firmware Version Test

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
WITH Interfaces.C;

WITH Discrete_To_Unsigned;
WITH libspiagent;
WITH LPC1114IOP.Transport;  USE LPC1114IOP.Transport;

USE TYPE Interfaces.C.unsigned;

PROCEDURE test_lpc1114iop_version IS

  servername : Unbounded_String;
  cmd        : libspiagent.SPIAGENT_COMMAND_MSG_t;
  resp       : libspiagent.SPIAGENT_RESPONSE_MSG_t;

  PACKAGE int_io IS NEW Integer_IO(Integer); USE int_io;

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(SPIAGENT_COMMAND_t);

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Firmware Version Test");
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

  LPC1114IOP.Transport.Open(To_String(servername));

  -- Issue NOP command to the SPI Agent Firmware

  cmd.command := To_Unsigned(SPIAGENT_CMD_NOP);
  cmd.pin     := 0;
  cmd.data    := 0;

  LPC1114IOP.Transport.Execute(cmd, resp);

  IF resp.error /= 0 THEN
    RAISE LPC1114IOP.Error WITH "SPI Agent Firmware returned error:" & resp.error'Image;
  END IF;

  -- Display results

  Put_Line("The SPI Agent Firmware version number is" &
    Integer'IMAGE(Integer(resp.data)));

  -- Issue GET_SFR command to the SPI Agent Firmware

  cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_SFR);
  cmd.pin     := 16#400483F4#;
  cmd.data    := 0;

  LPC1114IOP.Transport.Execute(cmd, resp);

  IF resp.error /= 0 THEN
    RAISE LPC1114IOP.Error WITH "SPI Agent Firmware returned error:" & resp.error'Image;
  END IF;

  -- Display results

  Put("The LPC1114 device ID is ");
  Put(Integer(resp.data), Base => 16);
  New_Line(2);

  -- Deinitialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_version;

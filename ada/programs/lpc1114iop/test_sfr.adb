-- Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
-- SFR (Special Function Register) I/O test

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

WITH spi_agent.transport;
WITH spi_agent.sfr;         USE spi_agent.sfr;

PROCEDURE test_sfr IS

  servername : Unbounded_String;
  error      : Integer;
  deviceID   : SFR;
  U0SCR      : SFR;

  PACKAGE sfr_data_io IS NEW Modular_IO(sfr_data);
  USE sfr_data_io;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board SFR Test");
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

  spi_agent.transport.open(To_String(servername) & ASCII.NUL, error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.open() failed, error:" & Integer'IMAGE(error);
  END IF;

  -- Create SFR instances

  deviceID := Create(LPC1114_DEVICE_ID);
  U0SCR    := Create(LPC1114_U0SCR);

  -- Read the LPC1114 device id

  Put("The LPC1114 device ID is                 ");
  Put(deviceID.Get, Base => 16, Width => 0);
  New_Line;

  -- Write the LPC1114 UART scratch pad register

  U0SCR.Put(16#55#);

  Put("The LPC1114 UART scratch pad register is ");
  Put(U0SCR.Get, Base => 16, Width => 0);
  New_Line;

  -- Deinitialize the SPI Agent Firmware transport library

  spi_agent.transport.close(error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_sfr;

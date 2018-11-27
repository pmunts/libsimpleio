-- Mikroelecktronika ADC Click services

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

WITH ClickBoard.libsimpleio;
WITH MCP3204;
WITH SPI.libsimpleio;
WITH Voltage;

PACKAGE ClickBoard.ADC.libsimpleio IS

  -- Create an array of analog voltage inputs from Socket object

  FUNCTION Create
   (socket: ClickBoard.libsimpleio.Socket;
    reference : Voltage.Volts := 3.3) RETURN Inputs IS
   (Create(SPI.libsimpleio.Create(socket.SPI, MCP3204.SPI_Mode,
      MCP3204.SPI_WordSize, MCP3204.SPI_Frequency,
      socket.GPIO(ClickBoard.CS))));

  -- Create an array of analog voltage inputs from socket number

  FUNCTION Create
   (socknum   : Positive;
    reference : Voltage.Volts := 3.3) RETURN Inputs IS
   (Create(ClickBoard.libsimpleio.Create(socknum)));

END ClickBoard.ADC.libsimpleio;

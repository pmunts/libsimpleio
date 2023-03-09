-- Services for the Mikroelektronika Expand Click, using libsimpleio

-- Copyright (C)2023, Philip Munts, President.
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

WITH GPIO.libsimpleio;
WITH SPI.libsimpleio;

PACKAGE BODY ClickBoard.Expand.SimpleIO IS

  -- Create MCP23S17 I/O expander object from a static socket instance

  FUNCTION Create
   (socket  : ClickBoard.SimpleIO.SocketSubclass;
    addr    : MCP23x17.Address) RETURN MCP23x17.Device IS

    rstpin : GPIO.Pin;
    spidev : SPI.Device;

  BEGIN
    rstpin := GPIO.libsimpleio.Create(socket.GPIO(RST), GPIO.Output, True);

    spidev := SPI.libsimpleio.Create(socket.SPI, SPI_Mode, SPI_WordSize,
      SPI_Frequency);

    RETURN Create(rstpin, spidev, addr);
  END Create;

  -- Create MCP23S17 I/O expander object from a socket number

  FUNCTION Create
   (socknum : Positive;
    addr    : MCP23x17.Address := MCP23x17.DefaultAddress) RETURN MCP23x17.Device IS

    socket : ClickBoard.SimpleIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(socket, addr);
  END Create;

  -- Create MCP23S17 I/O expander object from a socket object

  FUNCTION Create
   (socket  : NOT NULL ClickBoard.SimpleIO.Socket;
    addr    : MCP23x17.Address := MCP23x17.DefaultAddress) RETURN MCP23x17.Device IS

  BEGIN
    RETURN Create(socket.ALL, addr);
  END Create;

END ClickBoard.Expand.SimpleIO;

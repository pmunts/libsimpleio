-- Services for the Mikroelektronika Expand Click, using RemoteIO

-- Copyright (C)2023, Philip Munts, President, Munts AM Corp.
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

WITH GPIO.RemoteIO;
WITH SPI.RemoteIO;

PACKAGE BODY ClickBoard.Expand.RemoteIO IS

  -- Create MCP23S17 I/O expander object from a static socket instance

  FUNCTION Create
   (remdev : Standard.RemoteIO.Client.Device;
    socket : ClickBoard.RemoteIO.SocketSubclass;
    addr   : MCP23x17.Address) RETURN MCP23x17.Device IS

    rst : GPIO.Pin;
    dev : SPI.Device;

  BEGIN
    rst := GPIO.remoteio.Create(remdev, socket.GPIO(ClickBoard.RST),
             GPIO.Output, True);

    dev := SPI.remoteio.Create(remdev, socket.SPI, MCP23x17.SPI_Mode,
             MCP23x17.SPI_WordSize, MCP23x17.SPI_Frequency);

    RETURN Create(rst, dev, addr);
  END Create;

  -- Create MCP23S17 I/O expander object from a socket number

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socknum : Positive;
    addr    : MCP23x17.Address := MCP23x17.DefaultAddress) RETURN MCP23x17.Device IS

    socket : ClickBoard.RemoteIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(remdev, socket, addr);
  END Create;

  -- Create MCP23S17 I/O expander object from a socket object

  FUNCTION Create
   (remdev : NOT NULL Standard.RemoteIO.Client.Device;
    socket : NOT NULL ClickBoard.RemoteIO.Socket;
    addr   : MCP23x17.Address := MCP23x17.DefaultAddress) RETURN MCP23x17.Device IS

  BEGIN
    RETURN Create(remdev, socket.ALL, addr);
  END Create;

END ClickBoard.Expand.RemoteIO;

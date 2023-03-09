-- Services for the Mikroelektronika Thermo Click, using libsimpleio

-- Copyright (C)2016-2023, Philip Munts.
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

WITH SPI.libsimpleio;

PACKAGE BODY ClickBoard.Thermo.SimpleIO IS

  -- Create MAX31855 sensor object from static socket instance

  FUNCTION Create(socket : ClickBoard.SimpleIO.SocketSubclass) RETURN MAX31855.Device IS

    spidev : SPI.Device;

  BEGIN
    spidev := SPI.libsimpleio.Create(socket.SPI, SPI_Mode, SPI_WordSize,
      SPI_Frequency);

    RETURN MAX31855.Create(spidev);
  END Create;

  -- Create MAX31855 sensor object from socket number

  FUNCTION Create(socknum : Positive) RETURN MAX31855.Device IS

    socket : ClickBoard.SimpleIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(socket);
  END Create;

  -- Create MAX31855 sensor object from socket object

  FUNCTION Create(socket : ClickBoard.SimpleIO.Socket) RETURN MAX31855.Device IS

  BEGIN
    RETURN Create(socket.ALL);
  END Create;

END ClickBoard.Thermo.SimpleIO;

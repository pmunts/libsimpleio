-- Services for the Mikroelektronika Thermo3 Click, using libsimpleio

-- Copyright (C)2016-2023, Philip Munts, President, Munts AM Corp.
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

WITH I2C.libsimpleio;

PACKAGE BODY ClickBoard.Thermo3.SimpleIO IS

  -- Create TMP102 sensor object from static socket instance

  FUNCTION Create
   (socket  : ClickBoard.SimpleIO.SocketSubclass;
    addr    : I2C.Address) RETURN TMP102.Device IS

    bus : I2C.Bus;

  BEGIN
    bus := I2C.libsimpleio.Create(socket.I2C);
    RETURN Create(bus, addr);
  END Create;

  -- Create TMP102 sensor object from socket number

  FUNCTION Create
   (socknum : Positive;
    addr    : I2C.Address := DefaultAddress) RETURN TMP102.Device IS

    socket : ClickBoard.SimpleIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(socket, addr);
  END Create;

  -- Create TMP102 sensor object from socket object

  FUNCTION Create
   (socket  : NOT NULL ClickBoard.SimpleIO.Socket;
    addr    : I2C.Address := DefaultAddress) RETURN TMP102.Device IS

  BEGIN
    RETURN Create(socket.ALL, addr);
  END Create;

END ClickBoard.Thermo3.SimpleIO;

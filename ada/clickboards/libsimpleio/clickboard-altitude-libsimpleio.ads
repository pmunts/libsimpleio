-- Services for the Mikroelektronika Altitude Click, using libsimpleio

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

WITH ClickBoard.libsimpleio;
WITH I2C.libsimpleio;
WITH MPL3115A2;

PACKAGE ClickBoard.Altitude.libsimpleio IS

  -- Create MPL3115A2 sensor object from a socket number

  FUNCTION Create
   (socknum : Positive;
    addr    : I2C.Address := DefaultAddress) RETURN MPL3115A2.Device IS
     (MPL3115A2.Create(I2C.libsimpleio.Create(ClickBoard.libsimpleio.Create(socknum).I2C), addr));

  -- Create MPL3115A2 sensor object from a socket object

  FUNCTION Create
   (socket : ClickBoard.libsimpleio.Socket;
    addr   : I2C.Address := DefaultAddress) RETURN MPL3115A2.Device IS
     (MPL3115A2.Create(I2C.libsimpleio.Create(socket.I2C), addr));

  -- Create MPL3115A2 sensor object from I2C bus controller (if the I2C bus
  -- is shared with another device)

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN MPL3115A2.Device IS
     (MPL3115A2.Create(bus, addr));

END ClickBoard.Altitude.libsimpleio;

-- Services for the Mikroelektronika Thermo3 Click, using remoteio

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

WITH ClickBoard.remoteio;
WITH I2C.remoteio;
WITH RemoteIO.Client;
WITH TMP102;

PACKAGE ClickBoard.Thermo3.remoteio IS

  -- Create TMP102 sensor object from socket

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socket  : ClickBoard.remoteio.Socket;
    addr    : I2C.Address := DefaultAddress;
    speed   : Positive := TMP102.MaxSpeed) RETURN TMP102.Device IS
    (Create(I2C.remoteio.Create(remdev, socket.I2C, speed), addr));

  -- Create TMP102 sensor object from socket number

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socknum : Positive;
    addr    : I2C.Address := DefaultAddress;
    speed   : Positive := TMP102.MaxSpeed) RETURN TMP102.Device IS
    (Create(remdev, ClickBoard.remoteio.Create(socknum), addr));

END ClickBoard.Thermo3.remoteio;

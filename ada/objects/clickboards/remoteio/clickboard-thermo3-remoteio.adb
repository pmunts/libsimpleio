-- Services for the Mikroelektronika Thermo3 Click, using RemoteIO

-- Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

WITH I2C.RemoteIO;

PACKAGE BODY ClickBoard.Thermo3.RemoteIO IS

  -- Create TMP102 sensor object from static socket instance

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socket  : ClickBoard.RemoteIO.SocketSubclass;
    addr    : I2C.Address;
    speed   : Positive) RETURN TMP102.Device IS

    bus : CONSTANT I2C.Bus := I2C.RemoteIO.Create(remdev, socket.I2C, speed);

  BEGIN
    RETURN Create(bus, addr);
  END Create;

  -- Create TMP102 sensor object from socket number

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socknum : Positive;
    addr    : I2C.Address := DefaultAddress;
    speed   : Positive := TMP102.MaxSpeed) RETURN TMP102.Device IS

    socket : ClickBoard.RemoteIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(remdev, socket, addr, speed);
  END Create;

  -- Create TMP102 sensor object from socket object

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socket  : NOT NULL ClickBoard.RemoteIO.Socket;
    addr    : I2C.Address := DefaultAddress;
    speed   : Positive := TMP102.MaxSpeed) RETURN TMP102.Device IS

  BEGIN
    RETURN Create(remdev, socket.ALL, addr, speed);
  END Create;

END ClickBoard.Thermo3.RemoteIO;

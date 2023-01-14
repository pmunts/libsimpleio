-- Services for the Mikroelektronika Relay Click (MIKROE-1370)

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

-- NOTES: RELAY1 is driven by PWM and RELAY2 is driven by CS.

WITH GPIO.RemoteIO;

PACKAGE BODY ClickBoard.Relay.RemoteIO IS

  -- Create relay object from static socket instance

  FUNCTION Create
   (remdev   : NOT NULL Standard.RemoteIO.Client.Device;
    socket   : ClickBoard.RemoteIO.SocketSubclass;
    relaynum : RelayNumber) RETURN GPIO.Pin IS

  BEGIN
    CASE relaynum IS
      WHEN 1 => RETURN GPIO.RemoteIO.Create(remdev, socket.GPIO(PWM), GPIO.Output, False);
      WHEN 2 => RETURN GPIO.RemoteIO.Create(remdev, socket.GPIO(CS), GPIO.Output, False);
    END CASE;
  END Create;

  -- Create relay object from socket number

  FUNCTION Create
   (remdev   : NOT NULL Standard.RemoteIO.Client.Device;
    socknum  : Positive;
    relaynum : RelayNumber) RETURN GPIO.Pin IS

    socket : ClickBoard.RemoteIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(remdev, socket, relaynum);
  END Create;

  -- Create relay object from socket instance

  FUNCTION Create
   (remdev   : NOT NULL Standard.RemoteIO.Client.Device;
    socket   : NOT NULL ClickBoard.RemoteIO.Socket;
    relaynum : RelayNumber) RETURN GPIO.Pin IS

  BEGIN
    RETURN Create(remdev, socket.ALL, relaynum);
  END Create;

END ClickBoard.Relay.RemoteIO;

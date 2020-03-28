-- Services for the Mikroelektronika 7seg Click

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.RemoteIO;
WITH GPIO.RemoteIO;
WITH PWM.RemoteIO;
WITH RemoteIO.Client;
WITH SPI.RemoteIO;

PACKAGE BODY ClickBoard.SevenSegment.RemoteIO IS

  -- Create display object from socket object

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socket  : ClickBoard.RemoteIO.Socket;
    pwmfreq : Natural := 100) RETURN Display IS

  BEGIN
    IF (pwmfreq > 0) THEN
      BEGIN
        -- Use PWM output for PWM pin

        RETURN Display'(SPI.RemoteIO.Create(remdev, socket.SPI, SPI_MODE,
          SPI_WordSize, SPI_Frequency),
          NULL,
          Standard.PWM.RemoteIO.Create(remdev, socket.PWM, pwmfreq,
          Standard.PWM.MaximumDutyCycle),
          GPIO.RemoteIO.Create(remdev, socket.GPIO(ClickBoard.RST), GPIO.Output,
          True));
      EXCEPTION
        WHEN ClickBoard.SocketError =>
          NULL;

        WHEN Others =>
          RAISE;
      END;
    END IF;

    -- Use GPIO pin for PWM pin

    RETURN Display'(SPI.RemoteIO.Create(remdev, socket.SPI, SPI_MODE,
      SPI_WordSize, SPI_Frequency),
      GPIO.RemoteIO.Create(remdev, socket.GPIO(ClickBoard.PWM), GPIO.Output,
      True),
      NULL,
      GPIO.RemoteIO.Create(remdev, socket.GPIO(ClickBoard.RST), GPIO.Output,
      True));
  END Create;

  -- Create display object from socket number

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socknum : Positive;
    pwmfreq : Natural := 100) RETURN Display IS

  BEGIN
    RETURN Create(remdev, ClickBoard.RemoteIO.Create(socknum), pwmfreq);
  END Create;

END ClickBoard.SevenSegment.RemoteIO;

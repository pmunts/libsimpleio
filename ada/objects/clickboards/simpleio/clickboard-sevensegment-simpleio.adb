-- Services for the Mikroelektronika 7seg Click

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

WITH GPIO.libsimpleio;
WITH PWM.libsimpleio;
WITH SPI.libsimpleio;

PACKAGE BODY ClickBoard.SevenSegment.SimpleIO IS

  -- Create display object from static socket instance

  FUNCTION Create
   (socket  : ClickBoard.SimpleIO.SocketSubclass;
    pwmfreq : Natural) RETURN Display IS

    spidev : SPI.Device;
    pwmpin : GPIO.Pin;
    pwmout : Standard.PWM.output;
    rstpin : GPIO.Pin;

  BEGIN
    spidev := SPI.libsimpleio.Create(socket.SPI, SPI_Mode, SPI_WordSize,
      SPI_Frequency);

    rstpin := GPIO.libsimpleio.Create(socket.GPIO(ClickBoard.RST),
      GPIO.Output, True);

    IF (pwmfreq > 0) THEN
      pwmout := Standard.PWM.libsimpleio.Create(socket.PWM, pwmfreq,
        Standard.PWM.MaximumDutyCycle);
      RETURN ClickBoard.SevenSegment.Create(spidev, pwmout, rstpin);
    ELSE
      pwmpin := GPIO.libsimpleio.Create(socket.GPIO(ClickBoard.PWM),
        GPIO.Output, True);
      RETURN ClickBoard.SevenSegment.Create(spidev, pwmpin, rstpin);
    END IF;
  END Create;

  -- Create display object from socket number

  FUNCTION Create
   (socknum : Positive;
    pwmfreq : Natural := 100) RETURN Display IS

    socket : ClickBoard.SimpleIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(socket, pwmfreq);
  END Create;

  -- Create display object from socket object

  FUNCTION Create
   (socket  : ClickBoard.SimpleIO.Socket;
    pwmfreq : Natural := 100) RETURN Display IS

  BEGIN
    RETURN Create(socket.ALL, pwmfreq);
  END Create;

END ClickBoard.SevenSegment.SimpleIO;

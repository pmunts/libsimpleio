-- Services for the Mikroelektronika 7seg Click

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
WITH GPIO.libsimpleio;
WITH SPI.libsimpleio;

PACKAGE ClickBoard.SevenSegment.libsimpleio IS

  -- Create display object from socket object

  FUNCTION Create(socket : ClickBoard.libsimpleio.Socket) RETURN Display IS
  (Create(SPI.libsimpleio.Create(socket.SPI, SPI_Mode, SPI_WordSize,
     SPI_Frequency, socket.GPIO(ClickBoard.CS)),
     GPIO.libsimpleio.Create(socket.GPIO(ClickBoard.PWM), GPIO.Output, True),
     GPIO.libsimpleio.Create(socket.GPIO(ClickBoard.RST), GPIO.Output, True)));

  -- Create display object from socket number

  FUNCTION Create(socknum : Positive) RETURN Display IS
   (Create(ClickBoard.libsimpleio.Create(socknum)));

END ClickBoard.SevenSegment.libsimpleio;

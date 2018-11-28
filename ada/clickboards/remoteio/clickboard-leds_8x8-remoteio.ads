-- Services for the Mikroelektronika 8x8 LED Click

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

-- 8 by 8 LED Display layout:

-- Top left LED     is row 0 column 0
-- Bottom right LED is row 7 column 7

WITH ClickBoard.RemoteIO;
WITH RemoteIO.Client;
WITH SPI.RemoteIO;

PACKAGE ClickBoard.LEDs_8x8.RemoteIO IS

  -- Create display object from socket object

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socket  : ClickBoard.RemoteIO.Socket) RETURN TrueColor.Display IS
   (Create(SPI.RemoteIO.Create(remdev, socket.SPI, SPI_Mode, SPI_WordSize,
      SPI_Frequency)));

  -- Create display object from socket number

  FUNCTION Create
   (remdev  : Standard.RemoteIO.Client.Device;
    socknum : Positive) RETURN TrueColor.Display IS
   (Create(remdev, ClickBoard.RemoteIO.Create(socknum)));
END ClickBoard.LEDs_8x8.RemoteIO;

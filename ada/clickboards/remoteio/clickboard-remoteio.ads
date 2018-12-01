-- Mikroelektronika Click Board socket services using Remote I/O

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

WITH ClickBoard.Interface_RemoteIO;
WITH ClickBoard.Servers;
WITH RemoteIO;

PACKAGE ClickBoard.RemoteIO IS

  -- Define an object class for Click Board shield sockets

  TYPE Socket IS NEW ClickBoard.Interface_RemoteIO.SocketInterface WITH PRIVATE;

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Servers.kind := ClickBoard.Servers.Detect)
   RETURN Socket;

  -- Retrieve the type of Remote I/O server

  FUNCTION Kind(self : socket) RETURN ClickBoard.Servers.Kind;

  -- Retrieve the socket number

  FUNCTION Number(self : socket) RETURN Positive;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(self : socket) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(self : socket; pin : ClickBoard.Pins)
    RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to I2C bus controller device name

  FUNCTION I2C(self : socket) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to PWM output device name

  FUNCTION PWM(self : socket) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to SPI device name

  FUNCTION SPI(self : socket) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to serial port device name

  FUNCTION UART(self : socket) RETURN Standard.RemoteIO.ChannelNumber;

PRIVATE

  TYPE Socket IS NEW ClickBoard.Interface_RemoteIO.SocketInterface WITH RECORD
    index : Natural;
  END RECORD;

END ClickBoard.RemoteIO;

-- Mikroelektronika Click Board socket services using Remote I/O

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

WITH ClickBoard.Servers;
WITH ClickBoard.Template;
WITH RemoteIO;

PACKAGE ClickBoard.RemoteIO IS

  PACKAGE SockIF IS NEW ClickBoard.Template
   (Kind_Designator   => ClickBoard.Servers.Kind,
    Analog_Designator => Standard.RemoteIO.ChannelNumber,
    GPIO_Designator   => Standard.RemoteIO.ChannelNumber,
    I2C_Designator    => Standard.RemoteIO.ChannelNumber,
    PWM_Designator    => Standard.RemoteIO.ChannelNumber,
    SPI_Designator    => Standard.RemoteIO.ChannelNumber,
    UART_Designator   => Standard.RemoteIO.ChannelNumber);

  -- Define an object class for Click Board shield sockets

  TYPE SocketSubclass IS NEW SockIF.SocketInterface WITH PRIVATE;

  TYPE Socket IS ACCESS SocketSubclass;

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Servers.Kind := ClickBoard.Servers.Detect)
   RETURN Socket;

  -- Socket object initializer

  PROCEDURE Initialize
   (Self    : IN OUT SocketSubclass;
    socknum : Positive;
    kind    : ClickBoard.Servers.Kind :=
      ClickBoard.Servers.Detect);

  -- Retrieve the type of shield on the remote I/O server

  FUNCTION Kind(Self : SocketSubclass) RETURN ClickBoard.Servers.Kind;

  -- Retrieve the socket number

  FUNCTION Number(Self : SocketSubclass) RETURN Positive;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(Self : SocketSubclass; pin : ClickBoard.Pins)
    RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to I2C bus controller device name

  FUNCTION I2C(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to PWM output device name

  FUNCTION PWM(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to SPI device name

  FUNCTION SPI(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber;

  -- Map Click Board socket to serial port device name

  FUNCTION UART(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber;

PRIVATE

  TYPE SocketSubclass IS NEW SockIF.SocketInterface WITH RECORD
    index : Natural;
  END RECORD;

END ClickBoard.RemoteIO;

-- Mikroelektronika Click Board socket services, using libsimpleio

-- Copyright (C)2016-2022, Philip Munts, President, Munts AM Corp.
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

WITH ClickBoard.Shields;
WITH ClickBoard.Template;
WITH Device;

PACKAGE ClickBoard.SimpleIO IS

  PACKAGE SockIF IS NEW ClickBoard.Template
   (Kind_Designator   => ClickBoard.Shields.Kind,
    Analog_Designator => Device.Designator,
    GPIO_Designator   => Device.Designator,
    I2C_Designator    => Device.Designator,
    PWM_Designator    => Device.Designator,
    SPI_Designator    => Device.Designator,
    UART_Designator   => String);

  -- Define an object class for Click Board shield sockets

  TYPE SocketSubclass IS NEW SockIF.SocketInterface WITH PRIVATE;

  TYPE Socket IS ACCESS SocketSubclass;

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Shields.Kind :=
      ClickBoard.Shields.Detect) RETURN Socket;

  -- Socket object initializer

  PROCEDURE Initialize
   (Self    : IN OUT SocketSubclass;
    socknum : Positive;
    kind    : ClickBoard.Shields.Kind :=
      ClickBoard.Shields.Detect);

  -- Retrieve the type of shield

  FUNCTION Kind(Self : SocketSubclass) RETURN ClickBoard.Shields.Kind;

  -- Retrieve the socket number

  FUNCTION Number(Self : SocketSubclass) RETURN Positive;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(Self : SocketSubclass) RETURN Device.Designator;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(Self : SocketSubclass; pin : ClickBoard.Pins) RETURN Device.Designator;

  -- Map Click Board socket to I2C bus controller device name

  FUNCTION I2C(Self : SocketSubclass) RETURN Device.Designator;

  -- Map Click Board socket to PWM output device name

  FUNCTION PWM(Self : SocketSubclass) RETURN Device.Designator;

  -- Map Click Board socket to SPI device name

  FUNCTION SPI(Self : SocketSubclass) RETURN Device.Designator;

  -- Map Click Board socket to serial port device name

  FUNCTION UART(Self : SocketSubclass) RETURN String;

  -- Does platform support I2C clock stretching?

  FUNCTION I2C_Clock_Stretch(Self : SocketSubclass) RETURN Boolean;

PRIVATE

  TYPE SocketSubclass IS NEW SockIF.SocketInterface WITH RECORD
    index : Positive;
  END RECORD;

END ClickBoard.SimpleIO;

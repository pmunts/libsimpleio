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

WITH ClickBoard.Servers;
WITH mikroBUS.RemoteIO;
WITH RemoteIO;

PACKAGE BODY ClickBoard.RemoteIO IS

  Unavailable : CONSTANT Integer := -1;

  TYPE PinArray IS ARRAY (mikroBUS.Pins) OF Integer;

  -- This record type contains all of the information about a single Mikrobus
  -- socket

  TYPE SocketRec IS RECORD
    Kind : ClickBoard.Servers.Kind;
    num  : Positive;
    GPIO : PinArray;
    AIN  : Integer;
    I2C  : Integer;
    PWM  : Integer;
    SPI  : Integer;
    UART : Integer;
  END RECORD;

  SocketTable : CONSTANT ARRAY (Natural RANGE <>) OF SocketRec :=
   (SocketRec'(ClickBoard.Servers.Arduino, 1,
     (mikroBUS.AN  => Unavailable,
      mikroBUS.RST => Unavailable,
      mikroBUS.INT => Unavailable,
      mikroBUS.PWM => Unavailable,
      OTHERS       => Unavailable),
      OTHERS       => Unavailable));

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Servers.kind := ClickBoard.Servers.Detect)
   RETURN Socket IS

  BEGIN
    RETURN Socket'(index => 1);
  END Create;

  -- Retrieve the type of Remote I/O server

  FUNCTION ServerKind(self : socket) RETURN ClickBoard.Servers.Kind IS

  BEGIN
    RETURN ClickBoard.Servers.Unknown;
  END ServerKind;

  -- Retrieve the socket number

  FUNCTION Number(self : socket) RETURN Positive IS

  BEGIN
    RETURN 1;
  END Number;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END AIN;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(self : socket; pin : mikroBUS.Pins)
    RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END GPIO;

  -- Map Click Board socket to I2C bus controller device

  FUNCTION I2C(self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END I2C;

  -- Map Click Board socket to PWM output device

  FUNCTION PWM(self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END PWM;

  -- Map Click Board socket to SPI device

  FUNCTION SPI(self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END SPI;

  -- Map Click Board socket to serial port device

  FUNCTION UART(self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    RETURN 0;
  END UART;

END ClickBoard.RemoteIO;

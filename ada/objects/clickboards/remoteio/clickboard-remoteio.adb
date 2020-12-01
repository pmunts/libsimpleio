-- Mikroelektronika Click Board socket services using Remote I/O

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

WITH ClickBoard.Servers;
WITH RemoteIO.Arduino;
WITH RemoteIO.Clicker;
WITH RemoteIO.PocketBeagle;
WITH RemoteIO.RaspberryPi;

USE TYPE ClickBoard.Servers.Kind;

PACKAGE BODY ClickBoard.RemoteIO IS

  Unavailable : CONSTANT Integer := -1;

  TYPE PinArray IS ARRAY (ClickBoard.Pins) OF Integer;

  -- This record type contains all of the information about a single Mikrobus
  -- socket

  TYPE SocketRec IS RECORD
    kind : ClickBoard.Servers.Kind;
    num  : Positive;
    GPIO : PinArray;
    AIN  : Integer;
    I2C  : Integer;
    PWM  : Integer;
    SPI  : Integer;
    UART : Integer;
  END RECORD;

  SocketTable : CONSTANT ARRAY (Natural RANGE <>) OF SocketRec :=
   (
    -- Any server with an Arduino Click Shield
    SocketRec'(ClickBoard.Servers.ArduinoClick, 1,
     (ClickBoard.AN   => Standard.RemoteIO.Arduino.A0,
      ClickBoard.RST  => Standard.RemoteIO.Arduino.A3,
      ClickBoard.CS   => Standard.RemoteIO.Arduino.D10,
      ClickBoard.SCK  => Standard.RemoteIO.Arduino.D13,
      ClickBoard.MISO => Standard.RemoteIO.Arduino.D12,
      ClickBoard.MOSI => Standard.RemoteIO.Arduino.D11,
      ClickBoard.PWM  => Standard.RemoteIO.Arduino.D6,
      ClickBoard.INT  => Standard.RemoteIO.Arduino.D2,
      ClickBoard.RX   => Standard.RemoteIO.Arduino.D0,
      ClickBoard.TX   => Standard.RemoteIO.Arduino.D1,
      ClickBoard.SCL  => Standard.RemoteIO.Arduino.A5,
      ClickBoard.SDA  => Standard.RemoteIO.Arduino.A4),
      AIN    => Standard.RemoteIO.Arduino.AIN0,
      I2C    => Standard.RemoteIO.Arduino.I2C0,
      SPI    => Standard.RemoteIO.Arduino.SPI0,
      OTHERS => Unavailable),

    -- Any server with an Arduino Click Shield
    SocketRec'(ClickBoard.Servers.ArduinoClick, 2,
     (ClickBoard.AN   => Standard.RemoteIO.Arduino.A1,
      ClickBoard.RST  => Standard.RemoteIO.Arduino.A2,
      ClickBoard.CS   => Standard.RemoteIO.Arduino.D9,
      ClickBoard.SCK  => Standard.RemoteIO.Arduino.D13,
      ClickBoard.MISO => Standard.RemoteIO.Arduino.D12,
      ClickBoard.MOSI => Standard.RemoteIO.Arduino.D11,
      ClickBoard.PWM  => Standard.RemoteIO.Arduino.D5,
      ClickBoard.INT  => Standard.RemoteIO.Arduino.D3,
      ClickBoard.RX   => Standard.RemoteIO.Arduino.D0,
      ClickBoard.TX   => Standard.RemoteIO.Arduino.D1,
      ClickBoard.SCL  => Standard.RemoteIO.Arduino.A5,
      ClickBoard.SDA  => Standard.RemoteIO.Arduino.A4),
      AIN    => Standard.RemoteIO.Arduino.AIN1,
      I2C    => Standard.RemoteIO.Arduino.I2C0,
      SPI    => Standard.RemoteIO.Arduino.SPI1,
      OTHERS => Unavailable),

    -- Mikroelektronika Clicker board with 1 socket

    SocketRec'(ClickBoard.Servers.Clicker, 1,
     (ClickBoard.AN   => Standard.RemoteIO.Clicker.AN,
      ClickBoard.RST  => Standard.RemoteIO.Clicker.RST,
      ClickBoard.CS   => Standard.RemoteIO.Clicker.CS,
      ClickBoard.SCK  => Standard.RemoteIO.Clicker.SCK,
      ClickBoard.MISO => Standard.RemoteIO.Clicker.MISO,
      ClickBoard.MOSI => Standard.RemoteIO.Clicker.MOSI,
      ClickBoard.PWM  => Standard.RemoteIO.Clicker.PWM,
      ClickBoard.INT  => Standard.RemoteIO.Clicker.INT,
      ClickBoard.RX   => Standard.RemoteIO.Clicker.RX,
      ClickBoard.TX   => Standard.RemoteIO.Clicker.TX,
      ClickBoard.SCL  => Standard.RemoteIO.Clicker.SCL,
      ClickBoard.SDA  => Standard.RemoteIO.Clicker.SDA),
      AIN    => Standard.RemoteIO.Clicker.AIN0,
      I2C    => Standard.RemoteIO.Clicker.I2C0,
      SPI    => Standard.RemoteIO.Clicker.SPI0,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick1, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO22,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO4,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18,
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO17,
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick2, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO4,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO5,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18,
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO6,
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick2, 2,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO13,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO19,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO17,
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO26,
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      SPI    => Standard.RemoteIO.RaspberryPi.SPI1, -- SPI0 SS1
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick3, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO4,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO5,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18,
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO6,
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.RaspberryPi.AIN0,
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick3, 2,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO13,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO12,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO17,
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO26,
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.RaspberryPi.AIN1,
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      SPI    => Standard.RemoteIO.RaspberryPi.SPI1, -- SPI0 SS1
      OTHERS => Unavailable),

    -- Socket 1 is over the micro USB connector (left)

    SocketRec'(ClickBoard.Servers.PocketBeagle, 1,
     (ClickBoard.AN   => Standard.RemoteIO.PocketBeagle.GPIO87,
      ClickBoard.RST  => Standard.RemoteIO.PocketBeagle.GPIO89,
      ClickBoard.PWM  => Standard.RemoteIO.PocketBeagle.GPIO50,
      ClickBoard.INT  => Standard.RemoteIO.PocketBeagle.GPIO23,
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.PocketBeagle.AIN6,
      I2C    => Standard.RemoteIO.PocketBeagle.I2C0, -- I2C1
      PWM    => Standard.RemoteIO.PocketBeagle.PWM1, -- PWM2 channel 0
      SPI    => Standard.RemoteIO.PocketBeagle.SPI0, -- SPI0 CS0
      OTHERS => Unavailable),

    -- Socket 2 is over the micro-SDHC card socket (right)

    SocketRec'(ClickBoard.Servers.PocketBeagle, 2,
     (ClickBoard.AN   => Standard.RemoteIO.PocketBeagle.GPIO86,
      ClickBoard.RST  => Standard.RemoteIO.PocketBeagle.GPIO45,
      ClickBoard.PWM  => Standard.RemoteIO.PocketBeagle.GPIO110,
      ClickBoard.INT  => Standard.RemoteIO.PocketBeagle.GPIO26,
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.PocketBeagle.AIN5,
      I2C    => Standard.RemoteIO.PocketBeagle.I2C1, -- I2C2
      PWM    => Standard.RemoteIO.PocketBeagle.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.PocketBeagle.SPI1, -- SPI2 CS1
      OTHERS => Unavailable));

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Servers.kind := ClickBoard.Servers.Detect)
   RETURN Socket IS

  BEGIN

    -- Search the socket table, looking for a matching shield
    -- and socket number

    FOR i IN SocketTable'Range LOOP
      IF (socknum = SocketTable(i).num) AND (kind = SocketTable(i).Kind) THEN
        RETURN Socket'(index => i);
      END IF;
    END LOOP;

    RAISE ClickBoard.SocketError WITH "Unable to find matching shield and socket";
  END Create;

  -- Retrieve the type of shield on the Remote I/O server

  FUNCTION Kind(Self : socket) RETURN ClickBoard.Servers.Kind IS

  BEGIN
    RETURN SocketTable(Self.index).kind;
  END Kind;

  -- Retrieve the socket number

  FUNCTION Number(Self : socket) RETURN Positive IS

  BEGIN
    RETURN SocketTable(Self.index).num;
  END Number;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(Self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).AIN = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "AIN is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).AIN;
  END AIN;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(Self : socket; pin : ClickBoard.Pins)
    RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).GPIO(pin) = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "GPIO pin " & ClickBoard.Pins'Image(pin) &
        " is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).GPIO(pin);
  END GPIO;

  -- Map Click Board socket to I2C bus controller device

  FUNCTION I2C(Self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).I2C = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "I2C is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).I2C;
  END I2C;

  -- Map Click Board socket to PWM output device

  FUNCTION PWM(Self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).PWM = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "PWM is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).PWM;
  END PWM;

  -- Map Click Board socket to SPI device

  FUNCTION SPI(Self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).SPI = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "SPI is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).SPI;
  END SPI;

  -- Map Click Board socket to serial port device

  FUNCTION UART(Self : socket) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).UART = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "UART is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).UART;
  END UART;

END ClickBoard.RemoteIO;

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
WITH RemoteIO.BeagleBone;
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

  PRAGMA Warnings(Off, "there are no others");

  SocketTable : CONSTANT ARRAY (Natural RANGE <>) OF SocketRec :=
   (SocketRec'(ClickBoard.Servers.BeagleBoneClick2, 1,
     (ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO45,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO44,
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO110, -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO111, -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO112, -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO15,  -- Conflicts with UART1
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO14,  -- Conflicts with UART1
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO27,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO50,  -- Conflicts with EHRPWM1A
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN0,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM1A,
      SPI    => Standard.RemoteIO.BeagleBone.SPI1_0,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.BeagleBoneClick2, 2,
     (ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO47,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO46,
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO110, -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO111, -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO112, -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO3,   -- Conflicts with UART2
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO2,   -- Conflicts with UART2
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO65,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO22,  -- Conflicts with EHRPWM2A
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN1,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM2A,
      SPI    => Standard.RemoteIO.BeagleBone.SPI1_1,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.BeagleBoneClick4, 1,
     (ClickBoard.AN   => Standard.RemoteIO.BeagleBone.GPIO61,  -- Conflicts with AIN3
      ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO60,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO113, -- Conflicts with SPI1
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO110, -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO111, -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO112, -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO3,   -- Conflicts with SPI1, UART2
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO2,   -- Conflicts with SPI1, UART2
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO48,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO50,  -- Conflicts with EHRPWM1A
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN3,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM1A,
      SPI    => Standard.RemoteIO.BeagleBone.SPI1_0,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.BeagleBoneClick4, 2,
     (ClickBoard.AN   => Standard.RemoteIO.BeagleBone.GPIO47,  -- Conflicts with AIN2
      ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO49,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO7,   -- Conflicts with SPI1
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO110, -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO111, -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO112, -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO15,  -- Conflicts with UART1
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO14,  -- Conflicts with UART1
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO20,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO51,  -- Conflicts with EHRPWM1B
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN2,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM1B,
      SPI    => Standard.RemoteIO.BeagleBone.SPI1_1,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.BeagleBoneClick4, 3,
     (ClickBoard.AN   => Standard.RemoteIO.BeagleBone.GPIO44,  -- Conflicts with AIN1
      ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO26,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO5,   -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO2,   -- Conflicts with SPI0, UART2
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO3,   -- Conflicts with SPI0, UART2
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO4,   -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO15,  -- Conflicts with UART1
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO14,  -- Conflicts with UART1
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO65,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO22,  -- Conflicts with EHRPWM2A
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN1,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM2A,
      SPI    => Standard.RemoteIO.BeagleBone.SPI0_0,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.BeagleBoneClick4, 4,
     (ClickBoard.AN   => Standard.RemoteIO.BeagleBone.GPIO45,  -- Conflicts with AIN0
      ClickBoard.RST  => Standard.RemoteIO.BeagleBone.GPIO46,
      ClickBoard.CS   => Standard.RemoteIO.BeagleBone.GPIO68,
      ClickBoard.SCK  => Standard.RemoteIO.BeagleBone.GPIO110, -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.BeagleBone.GPIO111, -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.BeagleBone.GPIO112, -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.BeagleBone.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.BeagleBone.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.BeagleBone.GPIO31,  -- Conflicts with UART4
      ClickBoard.RX   => Standard.RemoteIO.BeagleBone.GPIO30,  -- Conflicts with UART4
      ClickBoard.INT  => Standard.RemoteIO.BeagleBone.GPIO27,
      ClickBoard.PWM  => Standard.RemoteIO.BeagleBone.GPIO23,  -- Conflicts with EHRPWM2B
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.BeagleBone.AIN0,
      I2C    => Standard.RemoteIO.BeagleBone.I2C2,
      PWM    => Standard.RemoteIO.BeagleBone.EHRPWM2B,
      SPI    => Unavailable,
      OTHERS => Unavailable),

    -- Socket 1 is over the micro USB connector (left)

    SocketRec'(ClickBoard.Servers.PocketBeagle, 1,
     (ClickBoard.AN   => Standard.RemoteIO.PocketBeagle.GPIO87,  -- Conflicts with AIN6
      ClickBoard.RST  => Standard.RemoteIO.PocketBeagle.GPIO89,
      ClickBoard.CS   => Standard.RemoteIO.PocketBeagle.GPIO5,   -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.PocketBeagle.GPIO2,   -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.PocketBeagle.GPIO3,   -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.PocketBeagle.GPIO4,   -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.PocketBeagle.GPIO14,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.PocketBeagle.GPIO15,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.PocketBeagle.GPIO31,  -- Conflicts with UART4
      ClickBoard.RX   => Standard.RemoteIO.PocketBeagle.GPIO30,  -- Conflicts with UART4
      ClickBoard.INT  => Standard.RemoteIO.PocketBeagle.GPIO23,
      ClickBoard.PWM  => Standard.RemoteIO.PocketBeagle.GPIO50,  -- Conflicts with PWM2:0
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.PocketBeagle.AIN6,
      I2C    => Standard.RemoteIO.PocketBeagle.I2C1,
      PWM    => Standard.RemoteIO.PocketBeagle.PWM2_0,
      SPI    => Standard.RemoteIO.PocketBeagle.SPI0_0,
      OTHERS => Unavailable),

    -- Socket 2 is over the micro-SDHC card socket (right)

    SocketRec'(ClickBoard.Servers.PocketBeagle, 2,
     (ClickBoard.AN   => Standard.RemoteIO.PocketBeagle.GPIO86,  -- Conflicts with AIN5
      ClickBoard.RST  => Standard.RemoteIO.PocketBeagle.GPIO45,
      ClickBoard.CS   => Standard.RemoteIO.PocketBeagle.GPIO19,  -- Conflicts with SPI1
      ClickBoard.SCK  => Standard.RemoteIO.PocketBeagle.GPIO7,   -- Conflicts with SPI1
      ClickBoard.MISO => Standard.RemoteIO.PocketBeagle.GPIO40,  -- Conflicts with SPI1
      ClickBoard.MOSI => Standard.RemoteIO.PocketBeagle.GPIO41,  -- Conflicts with SPI1
      ClickBoard.SDA  => Standard.RemoteIO.PocketBeagle.GPIO12,  -- Conflicts with I2C2
      ClickBoard.SCL  => Standard.RemoteIO.PocketBeagle.GPIO13,  -- Conflicts with I2C2
      ClickBoard.TX   => Standard.RemoteIO.PocketBeagle.GPIO43,  -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.PocketBeagle.GPIO42,  -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.PocketBeagle.GPIO26,
      ClickBoard.PWM  => Standard.RemoteIO.PocketBeagle.GPIO110, -- Conflicts with PWM0:0
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.PocketBeagle.AIN5,
      I2C    => Standard.RemoteIO.PocketBeagle.I2C2,
      PWM    => Standard.RemoteIO.PocketBeagle.PWM0_0,
      SPI    => Standard.RemoteIO.PocketBeagle.SPI1_1,
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick1, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO22,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO4,
      ClickBoard.CS   => Standard.RemoteIO.RaspberryPi.GPIO8,  -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.RaspberryPi.GPIO11, -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.RaspberryPi.GPIO9,  -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.RaspberryPi.GPIO10, -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.RaspberryPi.GPIO2,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.RaspberryPi.GPIO3,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.RaspberryPi.GPIO14, -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.RaspberryPi.GPIO15, -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO17,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18, -- Conflicts with PWM0
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick2, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO4,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO5,
      ClickBoard.CS   => Standard.RemoteIO.RaspberryPi.GPIO8,  -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.RaspberryPi.GPIO11, -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.RaspberryPi.GPIO9,  -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.RaspberryPi.GPIO10, -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.RaspberryPi.GPIO2,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.RaspberryPi.GPIO3,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.RaspberryPi.GPIO14, -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.RaspberryPi.GPIO15, -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO6,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18, -- Conflicts with PWM0
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick2, 2,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO13,
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO19,
      ClickBoard.CS   => Standard.RemoteIO.RaspberryPi.GPIO7,  -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.RaspberryPi.GPIO11, -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.RaspberryPi.GPIO9,  -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.RaspberryPi.GPIO10, -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.RaspberryPi.GPIO2,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.RaspberryPi.GPIO3,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.RaspberryPi.GPIO14, -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.RaspberryPi.GPIO15, -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO26,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO17,
      OTHERS          => Unavailable),
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      SPI    => Standard.RemoteIO.RaspberryPi.SPI1, -- SPI0 SS1
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick3, 1,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO4,  -- Switch AN1 must be in the RIGHT position
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO5,
      ClickBoard.CS   => Standard.RemoteIO.RaspberryPi.GPIO8,  -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.RaspberryPi.GPIO11, -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.RaspberryPi.GPIO9,  -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.RaspberryPi.GPIO10, -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.RaspberryPi.GPIO2,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.RaspberryPi.GPIO3,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.RaspberryPi.GPIO14, -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.RaspberryPi.GPIO15, -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO6,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO18, -- Conflicts with PWM0
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.RaspberryPi.AIN0, -- Switch AN1 must be in the LEFT position
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      PWM    => Standard.RemoteIO.RaspberryPi.PWM0, -- PWM0 channel 0
      SPI    => Standard.RemoteIO.RaspberryPi.SPI0, -- SPI0 SS0
      OTHERS => Unavailable),

    SocketRec'(ClickBoard.Servers.PiClick3, 2,
     (ClickBoard.AN   => Standard.RemoteIO.RaspberryPi.GPIO13, -- Switch AN2 must be in the RIGHT position
      ClickBoard.RST  => Standard.RemoteIO.RaspberryPi.GPIO12,
      ClickBoard.CS   => Standard.RemoteIO.RaspberryPi.GPIO7,  -- Conflicts with SPI0
      ClickBoard.SCK  => Standard.RemoteIO.RaspberryPi.GPIO11, -- Conflicts with SPI0
      ClickBoard.MISO => Standard.RemoteIO.RaspberryPi.GPIO9,  -- Conflicts with SPI0
      ClickBoard.MOSI => Standard.RemoteIO.RaspberryPi.GPIO10, -- Conflicts with SPI0
      ClickBoard.SDA  => Standard.RemoteIO.RaspberryPi.GPIO2,  -- Conflicts with I2C1
      ClickBoard.SCL  => Standard.RemoteIO.RaspberryPi.GPIO3,  -- Conflicts with I2C1
      ClickBoard.TX   => Standard.RemoteIO.RaspberryPi.GPIO14, -- Conflicts with UART0
      ClickBoard.RX   => Standard.RemoteIO.RaspberryPi.GPIO15, -- Conflicts with UART0
      ClickBoard.INT  => Standard.RemoteIO.RaspberryPi.GPIO26,
      ClickBoard.PWM  => Standard.RemoteIO.RaspberryPi.GPIO17,
      OTHERS          => Unavailable),
      AIN    => Standard.RemoteIO.RaspberryPi.AIN1, -- Switch AN2 must be in the LEFT position
      I2C    => Standard.RemoteIO.RaspberryPi.I2C1, -- I2C1
      SPI    => Standard.RemoteIO.RaspberryPi.SPI1, -- SPI0 SS1
      OTHERS => Unavailable));

  PRAGMA Warnings(On, "there are no others");

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Servers.Kind := ClickBoard.Servers.Detect)
   RETURN Socket IS

  BEGIN
    -- Search the socket table, looking for a matching server kind and
    -- socket number

    FOR i IN SocketTable'Range LOOP
      IF (socknum = SocketTable(i).num) AND (kind = SocketTable(i).Kind) THEN
        RETURN NEW SocketSubclass'(index => i);
      END IF;
    END LOOP;

    RAISE ClickBoard.SocketError WITH "Unable to find matching server kind and socket number";
  END Create;

  -- Socket object initializer

  PROCEDURE Initialize
   (Self    : IN OUT SocketSubclass;
    socknum : Positive;
    kind    : ClickBoard.Servers.Kind :=
      ClickBoard.Servers.Detect) IS

  BEGIN
    -- Search the socket table, looking for a matching server kind and
    -- socket number

    FOR i IN SocketTable'Range LOOP
      IF (socknum = SocketTable(i).num) AND (kind = SocketTable(i).Kind) THEN
        Self.index := i;
        RETURN;
      END IF;
    END LOOP;

    RAISE ClickBoard.SocketError WITH "Unable to find matching server kind and socket number";
  END Initialize;

  -- Retrieve the type of shield on the Remote I/O server

  FUNCTION Kind(Self : SocketSubclass) RETURN ClickBoard.Servers.Kind IS

  BEGIN
    RETURN SocketTable(Self.index).Kind;
  END Kind;

  -- Retrieve the socket number

  FUNCTION Number(Self : SocketSubclass) RETURN Positive IS

  BEGIN
    RETURN SocketTable(Self.index).num;
  END Number;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).AIN = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "AIN is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).AIN;
  END AIN;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(Self : SocketSubclass; pin : ClickBoard.Pins)
    RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).GPIO(pin) = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "GPIO pin " & ClickBoard.Pins'Image(pin) &
        " is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).GPIO(pin);
  END GPIO;

  -- Map Click Board socket to I2C bus controller device

  FUNCTION I2C(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).I2C = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "I2C is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).I2C;
  END I2C;

  -- Map Click Board socket to PWM output device

  FUNCTION PWM(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).PWM = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "PWM is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).PWM;
  END PWM;

  -- Map Click Board socket to SPI device

  FUNCTION SPI(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).SPI = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "SPI is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).SPI;
  END SPI;

  -- Map Click Board socket to serial port device

  FUNCTION UART(Self : SocketSubclass) RETURN Standard.RemoteIO.ChannelNumber IS

  BEGIN
    IF SocketTable(Self.index).UART = Unavailable THEN
      RAISE ClickBoard.SocketError WITH "UART is not available for this socket";
    END IF;

    RETURN SocketTable(Self.index).UART;
  END UART;

END ClickBoard.RemoteIO;

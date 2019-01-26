-- Mikroelektronika Click Board socket services, using libsimpleio

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

WITH Ada.Strings.Fixed;

WITH ClickBoard.Shields;
WITH Device;

USE TYPE ClickBoard.Shields.Kind;
USE TYPE Device.Designator;

-- Platform packages

WITH BeagleBone;
WITH PocketBeagle;
WITH RaspberryPi;

PACKAGE BODY ClickBoard.SimpleIO IS

  SUBTYPE DeviceString IS String(1 .. 12);

  -- This constant indicates a particular device is NOT available from the
  -- specified MikroBus socket.

  DeviceUnavailable : CONSTANT DeviceString := "UNAVAILABLE!";

  -- Transform a String to DeviceString

  FUNCTION To_DeviceString(s : String) RETURN DeviceString IS

  BEGIN
    RETURN Ada.Strings.Fixed.Head(Ada.Strings.Fixed.Trim(s, Ada.Strings.Both),
      DeviceString'Length);
  END To_DeviceString;

  -- Transform DeviceString to a full Linux device name, C compatible string

  FUNCTION To_DeviceName(s : DeviceString) RETURN String IS

  BEGIN
    RETURN "/dev/" & Ada.Strings.Fixed.Trim(s, Ada.Strings.Right) & ASCII.NUL;
  END To_DeviceName;

  TYPE PinArray IS ARRAY (ClickBoard.Pins) OF Device.Designator;

  -- This record type contains all of the information about a single Mikrobus
  -- socket

  TYPE SocketRec IS RECORD
    Kind  : ClickBoard.Shields.Kind;
    SockNum : Positive;
    PinList : PinArray;
    AIN     : Device.Designator;
    I2C     : Device.Designator;
    PWM     : Device.Designator;
    SPI     : Device.Designator;
    UART    : DeviceString;
    Stretch : Boolean;
  END RECORD;

  SocketTable : CONSTANT ARRAY (Positive RANGE <>) OF SocketRec :=
   (SocketRec'(ClickBoard.Shields.ArduinoClick, 1,
     (ClickBoard.AN  => RaspberryPi.GPIO4,
      ClickBoard.RST => RaspberryPi.GPIO12,
      ClickBoard.INT => RaspberryPi.GPIO17,
      ClickBoard.PWM => RaspberryPi.GPIO22,
      OTHERS         => Device.Unavailable),
      AIN     => Device.Unavailable,
      I2C     => RaspberryPi.I2C1,
      PWM     => Device.Unavailable,
      SPI     => RaspberryPi.SPI0_0,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.ArduinoClick, 2,
     (ClickBoard.AN  => RaspberryPi.GPIO5,
      ClickBoard.RST => RaspberryPi.GPIO6,
      ClickBoard.CS  => RaspberryPi.GPIO25,
      ClickBoard.INT => RaspberryPi.GPIO18,
      ClickBoard.PWM => RaspberryPi.GPIO27,
      OTHERS         => Device.Unavailable),
      AIN     => Device.Unavailable,
      I2C     => RaspberryPi.I2C1,
      PWM     => Device.Unavailable,
      SPI     => RaspberryPi.SPI0_1,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick1, 1,
     (ClickBoard.AN  => RaspberryPi.GPIO22,
      ClickBoard.RST => RaspberryPi.GPIO4,
      ClickBoard.INT => RaspberryPi.GPIO17,
      ClickBoard.PWM => RaspberryPi.GPIO18,
      OTHERS         => Device.Unavailable),
      AIN     => Device.Unavailable,
      I2C     => RaspberryPi.I2C1,
      PWM     => RaspberryPi.PWM0, -- Requires device tree overlay
      SPI     => RaspberryPi.SPI0_0,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick2, 1,
     (ClickBoard.AN  => RaspberryPi.GPIO4,
      ClickBoard.RST => RaspberryPi.GPIO5,
      ClickBoard.INT => RaspberryPi.GPIO6,
      ClickBoard.PWM => RaspberryPi.GPIO18,
      OTHERS         => Device.Unavailable),
      AIN     => Device.Unavailable,
      I2C     => RaspberryPi.I2C1,
      PWM     => RaspberryPi.PWM0, -- Requires device tree overlay
      SPI     => RaspberryPi.SPI0_0,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick2, 2,
     (ClickBoard.AN  => RaspberryPi.GPIO13,
      ClickBoard.RST => RaspberryPi.GPIO19,
      ClickBoard.INT => RaspberryPi.GPIO26,
      ClickBoard.PWM => RaspberryPi.GPIO17,
      OTHERS         => Device.Unavailable),
      AIN     => Device.Unavailable,
      I2C     => RaspberryPi.I2C1,
      PWM     => Device.Unavailable,
      SPI     => RaspberryPi.SPI0_1,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick3, 1,
     (ClickBoard.AN  => RaspberryPi.GPIO4,  -- Switch AN1 must be in RIGHT position
      ClickBoard.RST => RaspberryPi.GPIO5,
      ClickBoard.INT => RaspberryPi.GPIO6,
      ClickBoard.PWM => RaspberryPi.GPIO18,
      OTHERS         => Device.Unavailable),
      AIN     => RaspberryPi.AIN0,          -- Switch AN1 must be in LEFT position
      I2C     => RaspberryPi.I2C1,
      PWM     => RaspberryPi.PWM0, -- Requires device tree overlay
      SPI     => RaspberryPi.SPI0_0,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick3, 2,
     (ClickBoard.AN  => RaspberryPi.GPIO13, -- Switch AN2 must be in RIGHT position
      ClickBoard.RST => RaspberryPi.GPIO12,
      ClickBoard.INT => RaspberryPi.GPIO26,
      ClickBoard.PWM => RaspberryPi.GPIO17,
      OTHERS         => Device.Unavailable),
      AIN     => RaspberryPi.AIN1,          -- Switch AN2 must  be in LEFT position
      I2C     => RaspberryPi.I2C1,
      PWM     => Device.Unavailable,
      SPI     => RaspberryPi.SPI0_1,
      UART    => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick2, 1,
     (ClickBoard.RST => BeagleBone.GPIO45,
      ClickBoard.CS  => BeagleBone.GPIO44,
      ClickBoard.INT => BeagleBone.GPIO27,
      ClickBoard.PWM => BeagleBone.GPIO50,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN0,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => BeagleBone.SPI2_0,
      UART    => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick2, 2,
     (ClickBoard.RST => BeagleBone.GPIO47,
      ClickBoard.CS  => BeagleBone.GPIO46,
      ClickBoard.INT => BeagleBone.GPIO65,
      ClickBoard.PWM => BeagleBone.GPIO22,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN1,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => BeagleBone.SPI2_1,
      UART    => To_DeviceString("ttyS2"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 1,
     (ClickBoard.RST => BeagleBone.GPIO60,
      ClickBoard.INT => BeagleBone.GPIO48,
      ClickBoard.PWM => BeagleBone.GPIO50,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN3,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => BeagleBone.SPI2_0,
      UART    => To_DeviceString("ttyS2"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 2,
     (ClickBoard.RST => BeagleBone.GPIO49,
      ClickBoard.INT => BeagleBone.GPIO20,
      ClickBoard.PWM => BeagleBone.GPIO51,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN2,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => BeagleBOne.SPI2_1,
      UART    => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 3,
     (ClickBoard.RST => BeagleBone.GPIO26,
      ClickBoard.CS  => BeagleBone.GPIO5,
      ClickBoard.INT => BeagleBone.GPIO65,
      ClickBoard.PWM => BeagleBone.GPIO22,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN1,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => Device.Unavailable,
      UART    => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 4,
     (ClickBoard.RST => BeagleBone.GPIO46,
      ClickBoard.CS  => BeagleBone.GPIO68,
      ClickBoard.INT => BeagleBone.GPIO27,
      ClickBoard.PWM => BeagleBone.GPIO23,
      OTHERS         => Device.Unavailable),
      AIN     => BeagleBone.AIN0,
      I2C     => BeagleBone.I2C2,
      PWM     => Device.Unavailable,
      SPI     => Device.Unavailable,
      UART    => To_DeviceString("ttyS4"),
      Stretch => True),

    -- Socket 1 is over the micro USB connector (up or left)

    SocketRec'(ClickBoard.Shields.PocketBeagle, 1,
     (ClickBoard.AN  => PocketBeagle.GPIO87,
      ClickBoard.RST => PocketBeagle.GPIO89,
      ClickBoard.INT => PocketBeagle.GPIO23,
      ClickBoard.PWM => PocketBeagle.GPIO50,
      OTHERS         => Device.Unavailable),
      AIN     => PocketBeagle.AIN6,
      I2C     => PocketBeagle.I2C1,
      PWM     => PocketBeagle.PWM2_0,
      SPI     => PocketBeagle.SPI1_0,
      UART    => To_DeviceString("ttyS4"),
      Stretch => True),

    -- Socket 2 is over the micro-SDHC card socket (down or right)

    SocketRec'(ClickBoard.Shields.PocketBeagle, 2,
     (ClickBoard.AN  => PocketBeagle.GPIO86,
      ClickBoard.RST => PocketBeagle.GPIO45,
      ClickBoard.INT => PocketBeagle.GPIO26,
      ClickBoard.PWM => PocketBeagle.GPIO110,
      OTHERS         => Device.Unavailable),
      AIN     => PocketBeagle.AIN5,
      I2C     => PocketBeagle.I2C2,
      PWM     => PocketBeagle.PWM0_0,
      SPI     => PocketBeagle.SPI2_1,
      UART    => To_DeviceString("ttyS0"),
      Stretch => True));

  -- Socket object constructor

  FUNCTION Create
   (socknum : Positive;
    kind    : ClickBoard.Shields.Kind :=
      ClickBoard.Shields.Detect) RETURN Socket IS

  BEGIN

    -- Search the socket table, looking for a matching shield
    -- and socket number

    FOR i IN SocketTable'Range LOOP
      IF kind = SocketTable(i).kind AND socknum = SocketTable(i).socknum THEN
        RETURN Socket'(index => i);
      END IF;
    END LOOP;

    RAISE ClickBoard.SocketError WITH "Unable to find matching shield and socket";
  END Create;

  -- Retrieve the type of shield

  FUNCTION Kind(self : socket) RETURN ClickBoard.Shields.Kind IS

  BEGIN
    RETURN SocketTable(self.index).Kind;
  END Kind;

  -- Retrieve the socket number

  FUNCTION Number(self : socket) RETURN Positive IS

  BEGIN
    RETURN SocketTable(self.index).SockNum;
  END Number;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).AIN = Device.Unavailable THEN
      RAISE ClickBoard.SocketError WITH "AIN is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).AIN;
  END AIN;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(self : socket; pin : ClickBoard.Pins) RETURN Device.Designator IS

  BEGIN
    RETURN SocketTable(self.index).PinList(pin);
  END GPIO;

  -- Map Click Board socket to I2C bus controller device name

  FUNCTION I2C(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).I2C = Device.Unavailable THEN
      RAISE ClickBoard.SocketError WITH "I2C is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).I2C;
  END I2C;

  -- Map Click Board socket to PWM output device name

  FUNCTION PWM(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).PWM = Device.Unavailable THEN
      RAISE ClickBoard.SocketError WITH "PWM is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).PWM;
  END PWM;

  -- Map Click Board socket to SPI device name

  FUNCTION SPI(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).SPI = Device.Unavailable THEN
      RAISE ClickBoard.SocketError WITH "SPI is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).SPI;
  END SPI;

  -- Map Click Board socket to serial port device name

  FUNCTION UART(self : socket) RETURN String IS

  BEGIN
    IF SocketTable(self.index).UART = DeviceUnavailable THEN
      RAISE ClickBoard.SocketError WITH "UART is unavailable for this socket";
    END IF;

    RETURN To_DeviceName(SocketTable(self.index).UART);
  END UART;

  -- Does platform support I2C clock stretching?

  FUNCTION I2C_Clock_Stretch(self : socket) RETURN Boolean IS

  BEGIN
    RETURN False;
  END I2C_Clock_Stretch;

END ClickBoard.SimpleIO;

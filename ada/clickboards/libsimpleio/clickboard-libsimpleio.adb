-- Mikroelektronika Click Board socket services

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

PACKAGE BODY ClickBoard.libsimpleio IS

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

  TYPE PinArray IS ARRAY (mikroBUS.Pins) OF Device.Designator;

  -- This record type contains all of the information about a single Mikrobus
  -- socket

  TYPE SocketRec IS RECORD
    Shield  : ClickBoard.Shields.Kind;
    SockNum : Positive;
    PinList : PinArray;
    AINdev  : Device.Designator;
    I2Cdev  : DeviceString;
    PWMdev  : Device.Designator;
    SPIdev  : DeviceString;
    UARTdev : DeviceString;
    Stretch : Boolean;
  END RECORD;

  SocketTable : CONSTANT ARRAY (Positive RANGE <>) OF SocketRec :=
   (SocketRec'(ClickBoard.Shields.PiClick1, 1,
     (mikroBUS.AN  => RaspberryPi.GPIO22,
      mikroBUS.RST => RaspberryPi.GPIO4,
      mikroBUS.INT => RaspberryPi.GPIO17,
      mikroBUS.PWM => RaspberryPi.GPIO18,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.0"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick2, 1,
     (mikroBUS.AN  => RaspberryPi.GPIO4,
      mikroBUS.RST => RaspberryPi.GPIO5,
      mikroBUS.INT => RaspberryPi.GPIO6,
      mikroBUS.PWM => RaspberryPi.GPIO18,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.0"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick2, 2,
     (mikroBUS.AN  => RaspberryPi.GPIO13,
      mikroBUS.RST => RaspberryPi.GPIO19,
      mikroBUS.INT => RaspberryPi.GPIO26,
      mikroBUS.PWM => RaspberryPi.GPIO17,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.1"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick3, 1,
     (mikroBUS.AN  => RaspberryPi.GPIO4,  -- Switch AN1 must be in RIGHT position
      mikroBUS.RST => RaspberryPi.GPIO5,
      mikroBUS.INT => RaspberryPi.GPIO6,
      mikroBUS.PWM => RaspberryPi.GPIO18,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.0"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiClick3, 2,
     (mikroBUS.AN  => RaspberryPi.GPIO13, -- Switch AN2 must be in RIGHT position
      mikroBUS.RST => RaspberryPi.GPIO12,
      mikroBUS.INT => RaspberryPi.GPIO26,
      mikroBUS.PWM => RaspberryPi.GPIO17,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.1"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiArduinoClick, 1,
     (mikroBUS.AN  => RaspberryPi.GPIO4,
      mikroBUS.RST => RaspberryPi.GPIO12,
      mikroBUS.INT => RaspberryPi.GPIO17,
      mikroBUS.PWM => RaspberryPi.GPIO22,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.0"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.PiArduinoClick, 2,
     (mikroBUS.AN  => RaspberryPi.GPIO5,
      mikroBUS.RST => RaspberryPi.GPIO6,
      mikroBUS.CS  => RaspberryPi.GPIO25,
      mikroBUS.INT => RaspberryPi.GPIO18,
      mikroBUS.PWM => RaspberryPi.GPIO27,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev0.1"),
      UARTdev => To_DeviceString("ttyAMA0"),
      Stretch => False),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick2, 1,
     (mikroBUS.RST => BeagleBone.GPIO45,
      mikroBUS.CS  => BeagleBone.GPIO44,
      mikroBUS.INT => BeagleBone.GPIO27,
      mikroBUS.PWM => BeagleBone.GPIO50,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev2.0"),
      UARTdev => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick2, 2,
     (mikroBUS.RST => BeagleBone.GPIO47,
      mikroBUS.CS  => BeagleBone.GPIO46,
      mikroBUS.INT => BeagleBone.GPIO65,
      mikroBUS.PWM => BeagleBone.GPIO22,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev2.1"),
      UARTdev => To_DeviceString("ttyS2"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 1,
     (mikroBUS.RST => BeagleBone.GPIO60,
      mikroBUS.INT => BeagleBone.GPIO48,
      mikroBUS.PWM => BeagleBone.GPIO50,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev2.0"),
      UARTdev => To_DeviceString("ttyS2"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 2,
     (mikroBUS.RST => BeagleBone.GPIO49,
      mikroBUS.INT => BeagleBone.GPIO20,
      mikroBUS.PWM => BeagleBone.GPIO51,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev2.1"),
      UARTdev => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 3,
     (mikroBUS.RST => BeagleBone.GPIO26,
      mikroBUS.CS  => BeagleBone.GPIO5,
      mikroBUS.INT => BeagleBone.GPIO65,
      mikroBUS.PWM => BeagleBone.GPIO22,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => DeviceUnavailable,
      UARTdev => To_DeviceString("ttyS1"),
      Stretch => True),

    SocketRec'(ClickBoard.Shields.BeagleBoneClick4, 4,
     (mikroBUS.RST => BeagleBone.GPIO46,
      mikroBUS.CS  => BeagleBone.GPIO68,
      mikroBUS.INT => BeagleBone.GPIO27,
      mikroBUS.PWM => BeagleBone.GPIO23,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => DeviceUnavailable,
      UARTdev => To_DeviceString("ttyS4"),
      Stretch => True),

    -- Socket 1 is over the micro USB connector (left)

    SocketRec'(ClickBoard.Shields.PocketBeagle, 1,
     (mikroBUS.AN  => PocketBeagle.GPIO87,
      mikroBUS.RST => PocketBeagle.GPIO89,
      mikroBUS.INT => PocketBeagle.GPIO23,
      mikroBUS.PWM => PocketBeagle.GPIO50,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-1"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev1.0"),
      UARTdev => To_DeviceString("ttyS4"),
      Stretch => True),

    -- Socket 2 is over the micro-SDHC card socket (right)

    SocketRec'(ClickBoard.Shields.PocketBeagle, 2,
     (mikroBUS.AN  => PocketBeagle.GPIO86,
      mikroBUS.RST => PocketBeagle.GPIO45,
      mikroBUS.INT => PocketBeagle.GPIO26,
      mikroBUS.PWM => PocketBeagle.GPIO110,
      OTHERS       => Device.Unavailable),
      AINdev  => Device.Unavailable,
      I2Cdev  => To_DeviceString("i2c-2"),
      PWMdev  => Device.Unavailable,
      SPIdev  => To_DeviceString("spidev2.1"),
      UARTdev => To_DeviceString("ttyS0"),
      Stretch => True));

  -- Socket object constructor with implicit (detected) shield selection

  FUNCTION Create(socknum : Positive) RETURN Socket IS

  BEGIN
    RETURN Create(ClickBoard.Shields.Detect, socknum);
  END Create;

  -- Socket object constructor with explicit shield selection

  FUNCTION Create(shield : ClickBoard.Shields.Kind;
    socknum : Positive) RETURN Socket IS

  BEGIN

    -- Search the socket table, looking for a matching shield
    -- and socket number

    FOR i IN SocketTable'Range LOOP
      IF shield = SocketTable(i).shield AND
        socknum = SocketTable(i).socknum THEN
        RETURN Socket'(index => i);
      END IF;
    END LOOP;

    RAISE mikroBUS.SocketError WITH "Unable to find matching shield and socket";
  END Create;

  -- Retrieve the type of shield

  FUNCTION Shield(self : socket) RETURN ClickBoard.Shields.Kind IS

  BEGIN
    RETURN SocketTable(self.index).Shield;
  END Shield;

  -- Retrieve the socket number

  FUNCTION Number(self : socket) RETURN Positive IS

  BEGIN
    RETURN SocketTable(self.index).SockNum;
  END Number;

  -- Map Click Board socket to A/D input designator

  FUNCTION AIN(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).AINDev = Device.Unavailable THEN
      RAISE mikroBUS.SocketError WITH "AIN is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).AINDev;
  END AIN;

  -- Map Click Board socket GPIO pin to Linux GPIO pin designator

  FUNCTION GPIO(self : socket; pin : mikroBUS.Pins) RETURN Device.Designator IS

  BEGIN
    RETURN SocketTable(self.index).PinList(pin);
  END GPIO;

  -- Map Click Board socket to I2C bus controller device name

  FUNCTION I2C(self : socket) RETURN String IS

  BEGIN
    IF SocketTable(self.index).I2CDev = DeviceUnavailable THEN
      RAISE mikroBUS.SocketError WITH "I2C is unavailable for this socket";
    END IF;

    RETURN To_DeviceName(SocketTable(self.index).I2CDev);
  END I2C;

  -- Map Click Board socket to PWM output device name

  FUNCTION PWM(self : socket) RETURN Device.Designator IS

  BEGIN
    IF SocketTable(self.index).PWMDev = Device.Unavailable THEN
      RAISE mikroBUS.SocketError WITH "PWM is unavailable for this socket";
    END IF;

    RETURN SocketTable(self.index).PWMDev;
  END PWM;

  -- Map Click Board socket to SPI device name

  FUNCTION SPI(self : socket) RETURN String IS

  BEGIN
    IF SocketTable(self.index).SPIDev = DeviceUnavailable THEN
      RAISE mikroBUS.SocketError WITH "SPI is unavailable for this socket";
    END IF;

    RETURN To_DeviceName(SocketTable(self.index).SPIDev);
  END SPI;

  -- Map Click Board socket to serial port device name

  FUNCTION UART(self : socket) RETURN String IS

  BEGIN
    IF SocketTable(self.index).UARTDev = DeviceUnavailable THEN
      RAISE mikroBUS.SocketError WITH "UART is unavailable for this socket";
    END IF;

    RETURN To_DeviceName(SocketTable(self.index).UARTDev);
  END UART;

  -- Does platform support I2C clock stretching?

  FUNCTION I2C_Clock_Stretch(self : socket) RETURN Boolean IS

  BEGIN
    RETURN False;
  END I2C_Clock_Stretch;

END ClickBoard.libsimpleio;

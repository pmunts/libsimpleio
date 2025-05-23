-- BeaglePlay I/O resource definitions

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Environment_Variables;

WITH Device;

PACKAGE BeaglePlay IS

  ModelName : CONSTANT String := "BeagleBoard.org BeaglePlay"; -- From /proc/device-tree/model

  MuntsOS : CONSTANT Boolean :=
    Ada.Environment_Variables.Value("OSNAME", "undefined") = "MuntsOS";

  -- User LEDs

  LED_USR0      : CONSTANT String := "/dev/userled0";
  LED_USR1      : CONSTANT String := "/dev/userled1";
  LED_USR2      : CONSTANT String := "/dev/userled2";
  LED_USR3      : CONSTANT String := "/dev/userled3";
  LED_USR4      : CONSTANT String := "/dev/userled4";

  USER_LED      : CONSTANT String := LED_USR0;

  -- User button

  USER_BUTTON   : CONSTANT Device.Designator := (2, 18); -- Active low

  -- mikroBUS GPIO pins

  AN            : CONSTANT Device.Designator := (3, 10);
  RST           : CONSTANT Device.Designator := (3, 12);
  CS            : CONSTANT Device.Designator := (3, 13); -- Conflicts with SPI_MIKROBUS
  SCK           : CONSTANT Device.Designator := (3, 14); -- Conflicts with SPI_MIKROBUS
  MISO          : CONSTANT Device.Designator := (3,  7); -- Conflicts with SPI_MIKROBUS
  MOSI          : CONSTANT Device.Designator := (3,  8); -- Conflicts with SPI_MIKROBUS

  PWM	        : CONSTANT Device.Designator := (3, 11); -- Conflicts with PWM_MIKROBUS
  INT           : CONSTANT Device.Designator := (3,  9);
  RX            : CONSTANT Device.Designator := (3, 24); -- Conflicts with UART_MIKROBUS
  TX	        : CONSTANT Device.Designator := (3, 25); -- Conflicts with UART_MIKROBUS
  SCL           : CONSTANT Device.Designator := (3, 22); -- Conflicts with I2C_MIKROBUS
  SDA	        : CONSTANT Device.Designator := (3, 23); -- Conflicts with I2C_MIKROBUS

  -- Grove GPIO pins

  D0            : CONSTANT Device.Designator := (3, 28); -- Conflicts with I2C1 or UART1
  D1            : CONSTANT Device.Designator := (3, 29); -- Conflicts with I2C1 or UART1

  -- I2C buses

  I2C_GROVE     : CONSTANT Device.Designator := (0, 1);
  I2C_MIKROBUS  : CONSTANT Device.Designator := (0, 3);
  I2C_QWIIC     : CONSTANT Device.Designator := (0, 5);

  -- PWM outputs

  PWM_GROVE_D0  : CONSTANT Device.Designator := (1, 0);
  PWM_GROVE_D1  : CONSTANT Device.Designator := (1, 1);
  PWM_MIKROBUS  : CONSTANT Device.Designator := (0, 0);

  -- Serial ports

  -- For some reason, the Debian kernel renumbers the serial ports and marks
  -- UART1 as reserved.  MuntsOS restores the natural order of the serial ports
  -- such that ttyS0 => UART0 etc.

  UART_CONSOLE  : CONSTANT String := (IF MuntsOS THEN "/dev/ttyS0" ELSE "/dev/ttyS2"); -- Header J6
  UART_GROVE    : CONSTANT String := (IF MuntsOS THEN "/dev/ttyS1" ELSE "/dev/nonexistent");
  UART_MIKROBUS : CONSTANT String := (IF MuntsOS THEN "/dev/ttyS5" ELSE "/dev/ttyS0");
  UART_CC1352   : CONSTANT String := (IF MuntsOS THEN "/dev/ttyS6" ELSE "/dev/ttyS1");

  -- SPI devices

  SPI_MIKROBUS  : CONSTANT Device.Designator := (0, 0);

END BeaglePlay;

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

WITH Device;

PACKAGE BeaglePlay IS

  -- User LEDs

  LED_USR0      : CONSTANT String := "/dev/userled0";
  LED_USR1      : CONSTANT String := "/dev/userled1";
  LED_USR2      : CONSTANT String := "/dev/userled2";
  LED_USR3      : CONSTANT String := "/dev/userled3";
  LED_USR4      : CONSTANT String := "/dev/userled4";  -- aka /dev/userled

  -- User button

  GPIO_BUTTON   : CONSTANT Device.Designator := (2, 18); -- Active low

  -- mikroBUS GPIO pins

  GPIO_AN       : CONSTANT Device.Designator := (3, 10);
  GPIO_RST      : CONSTANT Device.Designator := (3, 12);
  GPIO_INT      : CONSTANT Device.Designator := (3,  9);

  -- I2C buses

  I2C_GROVE     : CONSTANT Device.Designator := (0, 1);
  I2C_MIKROBUS  : CONSTANT Device.Designator := (0, 3);
  I2C_QWIIC     : CONSTANT Device.Designator := (0, 5);

  -- PWM outputs

  PWM_MIKROBUS  : CONSTANT Device.Designator := (0, 0);

  -- Serial ports

  UART_CONSOLE  : CONSTANT String := "/dev/ttyS2"; -- Header J6
  UART_MIKROBUS : CONSTANT String := "/dev/ttyS0";

  -- SPI devices

  SPI_MIKROBUS  : CONSTANT Device.Designator := (0, 0);

END BeaglePlay;

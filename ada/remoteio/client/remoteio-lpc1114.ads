-- Remote I/O Resources available from a Raspberry Pi LPC1114 I/O Processor
-- Expansion Board (MUNTS-0004) or a LPC1114 I/O Processor Grove Module
-- (MUNTS-0007)

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces;

WITH Message64;
WITH RemoteIO.Abstract_Device;
WITH RemoteIO.Client;

PACKAGE RemoteIO.LPC1114 IS

  -- Analog inputs

  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka LPC1114 P1.0
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;  -- aka LPC1114 P1.1
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka LPC1114 P1.2
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka LPC1114 P1.3
  AIN5  : CONSTANT RemoteIO.ChannelNumber := 5;  -- aka LPC1114 P1.4

  -- GPIO pins

  LED   : CONSTANT RemoteIO.ChannelNumber := 0;  -- aka LPC1114 P0.7
  GPIO0 : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka LPC1114 P1.0
  GPIO1 : CONSTANT RemoteIO.ChannelNumber := 2;  -- aka LPC1114 P1.1
  GPIO2 : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka LPC1114 P1.2
  GPIO3 : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka LPC1114 P1.3
  GPIO4 : CONSTANT RemoteIO.ChannelNumber := 5;  -- aka LPC1114 P1.4
  GPIO5 : CONSTANT RemoteIO.ChannelNumber := 6;  -- aka LPC1114 P1.5
  GPIO6 : CONSTANT RemoteIO.ChannelNumber := 7;  -- aka LPC1114 P1.8
  GPIO7 : CONSTANT RemoteIO.ChannelNumber := 8;  -- aka LPC1114 P1.9

  -- PWM outputs

  PWM1  : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka LPC1114 P1.1
  PWM2  : CONSTANT RemoteIO.ChannelNumber := 2;  -- aka LPC1114 P1.2
  PWM3  : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka LPC1114 P1.3
  PWM4  : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka LPC1114 P1.9

  -----------------------------------------------------------------------------
  --
  -- LPC1114 I/O Processor Expansion Board Abstract Device services follow
  --
  -- See: http://git.munts.com/rpi-mcu/expansion/LPC1114/doc/UserGuide.pdf
  --
  -- Naming of identifiers below matches UserGuide.pdf.
  --
  -----------------------------------------------------------------------------

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware command structure

  TYPE SPIAGENT_COMMAND_MSG_t IS RECORD
    command : Interfaces.Unsigned_32;
    pin     : Interfaces.Unsigned_32;
    data    : Interfaces.Unsigned_32;
  END record;

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware response structure

  TYPE SPIAGENT_RESPONSE_MSG_t IS RECORD
    command : Interfaces.Unsigned_32;
    pin     : Interfaces.Unsigned_32;
    data    : Interfaces.Unsigned_32;
    error   : Interfaces.Unsigned_32;
  END record;

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware commands

  SPIAGENT_CMD_NOP                          : CONSTANT Interfaces.Unsigned_32 := 0;
  SPIAGENT_CMD_LOOPBACK                     : CONSTANT Interfaces.Unsigned_32 := 1;
  SPIAGENT_CMD_CONFIGURE_ANALOG_INPUT       : CONSTANT Interfaces.Unsigned_32 := 2;
  SPIAGENT_CMD_CONFIGURE_GPIO_INPUT         : CONSTANT Interfaces.Unsigned_32 := 3;
  SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT        : CONSTANT Interfaces.Unsigned_32 := 4;
  SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT         : CONSTANT Interfaces.Unsigned_32 := 5;
  SPIAGENT_CMD_GET_ANALOG                   : CONSTANT Interfaces.Unsigned_32 := 6;
  SPIAGENT_CMD_GET_GPIO                     : CONSTANT Interfaces.Unsigned_32 := 7;
  SPIAGENT_CMD_PUT_GPIO                     : CONSTANT Interfaces.Unsigned_32 := 8;
  SPIAGENT_CMD_PUT_PWM                      : CONSTANT Interfaces.Unsigned_32 := 9;
  SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT     : CONSTANT Interfaces.Unsigned_32 := 10;
  SPIAGENT_CMD_CONFIGURE_GPIO               : CONSTANT Interfaces.Unsigned_32 := 11;
  SPIAGENT_CMD_PUT_LEGORC                   : CONSTANT Interfaces.Unsigned_32 := 12;
  SPIAGENT_CMD_GET_SFR                      : CONSTANT Interfaces.Unsigned_32 := 13;
  SPIAGENT_CMD_PUT_SFR                      : CONSTANT Interfaces.Unsigned_32 := 14;
  SPIAGENT_CMD_CONFIGURE_TIMER_MODE         : CONSTANT Interfaces.Unsigned_32 := 15;
  SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER    : CONSTANT Interfaces.Unsigned_32 := 16;
  SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE      : CONSTANT Interfaces.Unsigned_32 := 17;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0       : CONSTANT Interfaces.Unsigned_32 := 18;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1       : CONSTANT Interfaces.Unsigned_32 := 19;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2       : CONSTANT Interfaces.Unsigned_32 := 20;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3       : CONSTANT Interfaces.Unsigned_32 := 21;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE : CONSTANT Interfaces.Unsigned_32 := 22;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1_VALUE : CONSTANT Interfaces.Unsigned_32 := 23;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2_VALUE : CONSTANT Interfaces.Unsigned_32 := 24;
  SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3_VALUE : CONSTANT Interfaces.Unsigned_32 := 25;
  SPIAGENT_CMD_GET_TIMER_VALUE              : CONSTANT Interfaces.Unsigned_32 := 26;
  SPIAGENT_CMD_GET_TIMER_CAPTURE            : CONSTANT Interfaces.Unsigned_32 := 27;
  SPIAGENT_CMD_GET_TIMER_CAPTURE_DELTA      : CONSTANT Interfaces.Unsigned_32 := 28;
  SPIAGENT_CMD_INIT_TIMER                   : CONSTANT Interfaces.Unsigned_32 := 29;

  -- Raspberry Pi LPC1114 I/O Processor General Purpose Input/Output pins

  LPC1114_GPIO0       : CONSTANT Interfaces.Unsigned_32 := 12; -- aka P1.0
  LPC1114_GPIO1       : CONSTANT Interfaces.Unsigned_32 := 13; -- aka P1.1
  LPC1114_GPIO2       : CONSTANT Interfaces.Unsigned_32 := 14; -- aka P1.2
  LPC1114_GPIO3       : CONSTANT Interfaces.Unsigned_32 := 15; -- aka P1.3
  LPC1114_GPIO4       : CONSTANT Interfaces.Unsigned_32 := 16; -- aka P1.4
  LPC1114_GPIO5       : CONSTANT Interfaces.Unsigned_32 := 17; -- aka P1.5
  LPC1114_GPIO6       : CONSTANT Interfaces.Unsigned_32 := 20; -- aka P1.8
  LPC1114_GPIO7       : CONSTANT Interfaces.Unsigned_32 := 21; -- aka P1.9
  LPC1114_LED         : CONSTANT Interfaces.Unsigned_32 := 7;  -- aka P0.7

   -- Raspberry Pi LPC1114 I/O Processor Analog input pins

  LPC1114_AD1         : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO0;
  LPC1114_AD2         : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO1;
  LPC1114_AD3         : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO2;
  LPC1114_AD4         : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO3;
  LPC1114_AD5         : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO4;

   -- Raspberry Pi LPC1114 I/O Processor PWM output pins

  LPC1114_PWM1        : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO1;
  LPC1114_PWM2        : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO2;
  LPC1114_PWM3        : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO3;
  LPC1114_PWM4        : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO7;

  -- Raspberry Pi LPC1114 I/O Processor Timer pins

  LPC1114_CT32B1_CAP0 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO0;
  LPC1114_CT32B1_MAT0 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO1;
  LPC1114_CT32B1_MAT1 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO2;
  LPC1114_CT32B1_MAT2 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO3;
  LPC1114_CT32B1_MAT3 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO4;
  LPC1114_CT32B0_CAP0 : CONSTANT Interfaces.Unsigned_32 := LPC1114_GPIO5;

   -- LPC1114 special function registers

  LPC1114_DEVICEID    : CONSTANT Interfaces.Unsigned_32 := 16#400483F4#;
  LPC1114_GPIO1DATA   : CONSTANT Interfaces.Unsigned_32 := 16#50010CFC#;
  LPC1114_U0SCR       : CONSTANT Interfaces.Unsigned_32 := 16#4000801C#;

  -- Instantiate RemoteIO.Abstract_Device

  FUNCTION FromCommand(cmd : SPIAGENT_COMMAND_MSG_t) RETURN Message64.Message;

  FUNCTION ToResponse(msg : Message64.Message) RETURN SPIAGENT_RESPONSE_MSG_t;

  PACKAGE Abstract_Device IS NEW RemoteIO.Abstract_Device
   (SPIAGENT_COMMAND_MSG_t, SPIAGENT_RESPONSE_MSG_t);

  PROCEDURE CheckError(resp : SPIAGENT_RESPONSE_MSG_t);

END RemoteIO.LPC1114;

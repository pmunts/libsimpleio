-- PCA9685 PWM controller device services

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

WITH I2C;

PACKAGE PCA9685 IS

  PCA9685_Error : EXCEPTION;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS DeviceClass;

  TYPE ClockFrequency IS NEW Natural RANGE 0 .. 50_000_000;

  TYPE RegisterData IS MOD 256;

  TYPE ChannelData IS ARRAY (0 .. 3) OF RegisterData;

  TYPE ChannelNumber IS NEW Natural RANGE 0 .. 15;

  MaxSpeed : CONSTANT := I2C.SpeedFastPlus;

  -- PCA9685 device object constructor

  FUNCTION Create
   (bus   : NOT NULL I2C.Bus;
    addr  : I2C.Address;
    freq  : Positive := 50;
    clock : ClockFrequency := 0) RETURN Device;

PRIVATE

  TYPE RegisterName IS
   (MODE1, MODE2, SUBADR1, SUBADR2, SUBADR3, ALLCALLADR,
    LED0_ON_L,  LED0_ON_H,  LED0_OFF_L,  LED0_OFF_H,
    LED1_ON_L,  LED1_ON_H,  LED1_OFF_L,  LED1_OFF_H,
    LED2_ON_L,  LED2_ON_H,  LED2_OFF_L,  LED2_OFF_H,
    LED3_ON_L,  LED3_ON_H,  LED3_OFF_L,  LED3_OFF_H,
    LED4_ON_L,  LED4_ON_H,  LED4_OFF_L,  LED4_OFF_H,
    LED5_ON_L,  LED5_ON_H,  LED5_OFF_L,  LED5_OFF_H,
    LED6_ON_L,  LED6_ON_H,  LED6_OFF_L,  LED6_OFF_H,
    LED7_ON_L,  LED7_ON_H,  LED7_OFF_L,  LED7_OFF_H,
    LED8_ON_L,  LED8_ON_H,  LED8_OFF_L,  LED8_OFF_H,
    LED9_ON_L,  LED9_ON_H,  LED9_OFF_L,  LED9_OFF_H,
    LED10_ON_L, LED10_ON_H, LED10_OFF_L, LED10_OFF_H,
    LED11_ON_L, LED11_ON_H, LED11_OFF_L, LED11_OFF_H,
    LED12_ON_L, LED12_ON_H, LED12_OFF_L, LED12_OFF_H,
    LED13_ON_L, LED13_ON_H, LED13_OFF_L, LED13_OFF_H,
    LED14_ON_L, LED14_ON_H, LED14_OFF_L, LED14_OFF_H,
    LED15_ON_L, LED15_ON_H, LED15_OFF_L, LED15_OFF_H,
    ALL_LED_ON_L, ALL_LED_ON_H, ALL_LED_OFF_L, ALL_LED_OFF_H,
    PRE_SCALE, TESTMODE);

  FOR RegisterName USE
   (MODE1         => 0,   MODE2         => 1,   SUBADR1       => 2,
    SUBADR2       => 3,   SUBADR3       => 4,   ALLCALLADR    => 5,
    LED0_ON_L     => 6,   LED0_ON_H     => 7,   LED0_OFF_L    => 8,
    LED0_OFF_H    => 9,   LED1_ON_L     => 10,  LED1_ON_H     => 11,
    LED1_OFF_L    => 12,  LED1_OFF_H    => 13,  LED2_ON_L     => 14,
    LED2_ON_H     => 15,  LED2_OFF_L    => 16,  LED2_OFF_H    => 17,
    LED3_ON_L     => 18,  LED3_ON_H     => 19,  LED3_OFF_L    => 20,
    LED3_OFF_H    => 21,  LED4_ON_L     => 22,  LED4_ON_H     => 23,
    LED4_OFF_L    => 24,  LED4_OFF_H    => 25,  LED5_ON_L     => 26,
    LED5_ON_H     => 27,  LED5_OFF_L    => 28,  LED5_OFF_H    => 29,
    LED6_ON_L     => 30,  LED6_ON_H     => 31,  LED6_OFF_L    => 32,
    LED6_OFF_H    => 33,  LED7_ON_L     => 34,  LED7_ON_H     => 35,
    LED7_OFF_L    => 36,  LED7_OFF_H    => 37,  LED8_ON_L     => 38,
    LED8_ON_H     => 39,  LED8_OFF_L    => 40,  LED8_OFF_H    => 41,
    LED9_ON_L     => 42,  LED9_ON_H     => 43,  LED9_OFF_L    => 44,
    LED9_OFF_H    => 45,  LED10_ON_L    => 46,  LED10_ON_H    => 47,
    LED10_OFF_L   => 48,  LED10_OFF_H   => 49,  LED11_ON_L    => 50,
    LED11_ON_H    => 51,  LED11_OFF_L   => 52,  LED11_OFF_H   => 53,
    LED12_ON_L    => 54,  LED12_ON_H    => 55,  LED12_OFF_L   => 56,
    LED12_OFF_H   => 57,  LED13_ON_L    => 58,  LED13_ON_H    => 59,
    LED13_OFF_L   => 60,  LED13_OFF_H   => 61,  LED14_ON_L    => 62,
    LED14_ON_H    => 63,  LED14_OFF_L   => 64,  LED14_OFF_H   => 65,
    LED15_ON_L    => 66,  LED15_ON_H    => 67,  LED15_OFF_L   => 68,
    LED15_OFF_H   => 69,  ALL_LED_ON_L  => 250, ALL_LED_ON_H  => 251,
    ALL_LED_OFF_L => 252, ALL_LED_OFF_H => 253, PRE_SCALE     => 254,
    TESTMODE      => 255);

  -- Write PCA9685 register

  PROCEDURE WriteRegister
   (Self  : DeviceClass;
    reg   : RegisterName;
    data  : RegisterData);

  -- Write PCA9685 channel data

  PROCEDURE WriteChannel
   (Self    : DeviceClass;
    channel : ChannelNumber;
    data    : ChannelData);

  -- Read PCA9685 channel data

  PROCEDURE ReadChannel
   (Self    : DeviceClass;
    channel : ChannelNumber;
    data    : OUT ChannelData);

  -- Complete the definition for PCA9685.DeviceClass

  TYPE DeviceClass IS TAGGED RECORD
    bus       : I2C.Bus;
    address   : I2C.Address;
    frequency : Positive;
  END RECORD;

END PCA9685;

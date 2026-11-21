-- Raspberry Pi LPC1114 I/O Processor Expansion Board
-- LEGO® Power Functions Remote Control services

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

WITH lpc11xx;
WITH Motor;

PACKAGE LPC1114IOP.LEGORC IS

  TYPE legorc_motor_t IS
   (ALLSTOP,
    MOTORA,
    MOTORB,
    COMBODIRECT,
    COMBOPWM);

  TYPE legorc_direction_t IS
   (DIRECTION_REVERSE,
    DIRECTION_FORWARD);

  TYPE legorc_speed_t IS NEW Natural RANGE 0 .. 255;

  TYPE legorc_channel_t IS NEW Natural RANGE 1 .. 4;

  -- Initialize an IRED output driver

  PROCEDURE Initialize(pin : lpc11xx.pin_id_t);

  -- Transmit a LEGO® Power Functions Remote Control command

  PROCEDURE Transmit
   (pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    direction : legorc_direction_t;
    speed     : legorc_speed_t);

  -- Motor driver output type

  TYPE MotorOutputClass IS NEW Motor.OutputInterface WITH PRIVATE;

  -- Motor driver output object constructor

  FUNCTION Create
   (pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    velocity  : Standard.Motor.Velocity  := 0.0) RETURN Standard.Motor.Output;

  -- Motor driver output object initializer

  PROCEDURE Initialize
   (self      : OUT MotorOutputClass;
    pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    velocity  : Standard.Motor.Velocity  := 0.0);

  -- Motor driver output object put method

  PROCEDURE Put
   (self      : IN OUT MotorOutputClass;
    velocity  : Standard.Motor.Velocity);

PRIVATE
  TYPE MotorOutputClass IS NEW Motor.OutputInterface WITH RECORD
    pin     : lpc11xx.pin_id_t;
    channel : legorc_channel_t;
    motorID : legorc_motor_t;
  END RECORD;
END LPC1114IOP.LEGORC;

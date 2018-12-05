-- LEGO Power Functions RC motor control services using the
-- Raspberry Pi LPC1114 I/O Processor Expansion Board MUNTS-0004
-- (http://git.munts.com/rpi-mcu/expansion/LPC1114)

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

-- NOTE: This implementation uses "Single output mode" to control the motors
-- independently.  Up to 8 motors (using 4 receivers, one on each of four
-- channels) can be controlled from a single LPC1114 GPIO pin driving an IRED.

WITH Motor;
WITH LPC11xx;

PACKAGE Motor.LEGORC.libspiagent IS

  -- Type definitions

  TYPE OutputSubclass IS NEW Motor.Interfaces.OutputInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (pin   : LPC11xx.pin_id_t;
    chan  : Channel;
    mot   : MotorID;
    velo  : Velocity := 0.0;
    defer : Boolean := False) RETURN Motor.Interfaces.Output;

  -- Methods

  PROCEDURE Put
   (self : IN OUT OutputSubclass;
    velo : Velocity);

PRIVATE

  TYPE OutputSubclass IS NEW Motor.Interfaces.OutputInterface WITH RECORD
    pin        : LPC11xx.pin_id_t;
    chan       : Channel;
    motor      : MotorID;
    configured : Boolean;
  END RECORD;

END Motor.LEGORC.libspiagent;

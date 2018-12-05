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

WITH Interfaces;

WITH errno;
WITH GPIO;
WITH libspiagent;

USE TYPE Interfaces.Integer_32;
USE TYPE Interfaces.Unsigned_32;

PACKAGE BODY Motor.LEGORC.libspiagent IS

  PROCEDURE ConfigurePin
   (pin : LPC11xx.pin_id_t) IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    Standard.libspiagent.GPIO_Configure(LPC11xx.pin_id_t'Pos(pin),
      Standard.libspiagent.GPIO_DIR_OUTPUT, Boolean'Pos(False), error);

    IF error /= 0 THEN
      RAISE GPIO.GPIO_Error WITH "spiagent_gpio_configure() failed, " &
        errno.strerror(Integer(error));
    END IF;
  END ConfigurePin;

  PROCEDURE SendCommand
   (pin: LPC11xx.pin_id_t;
    chan : Channel;
    mot  : MotorID;
    velo : Velocity) IS

    direction : Standard.Interfaces.Unsigned_32;
    speed     : Standard.Interfaces.Unsigned_32;
    error     : Standard.Interfaces.Integer_32;

  BEGIN

    -- Convert velocity to direction and speed

    IF velo < 0.0 THEN
      direction := Standard.libspiagent.LEGO_RC_REVERSE;
    ELSE
      direction := Standard.libspiagent.LEGO_RC_FORWARD;
    END IF;

    speed := Standard.Interfaces.Unsigned_32(Abs(velo)*7.0);

    -- Send command to LEGO RC receiver

    Standard.libspiagent.LEGO_RC_Put(LPC11xx.pin_id_t'Pos(pin),
      Standard.Interfaces.Unsigned_32(chan), MotorID'Pos(mot) + 1, direction,
      speed, error);

    IF error /= 0 THEN
      RAISE LEGORC_Error WITH "spiagent_legorc_put() failed, " &
        errno.strerror(Integer(error));
    END IF;
  END SendCommand;

  -- Constructors

  FUNCTION Create
   (pin   : LPC11xx.pin_id_t;
    chan  : Channel;
    mot   : MotorID;
    velo  : Velocity := 0.0;
    defer : Boolean := False) RETURN Motor.Interfaces.Output IS

  BEGIN
    IF defer THEN
      -- Defer GPIO output configuration

      RETURN NEW OutputSubclass'(pin, chan, mot, False);
    ELSE
      -- Configure GPIO output now

      ConfigurePin(pin);

      -- Set the initial motor speed

      SendCommand(pin, chan, mot, velo);

      RETURN NEW OutputSubclass'(pin, chan, mot, True);
    END IF;
  END Create;

  -- Methods

  PROCEDURE Put
   (self : IN OUT OutputSubclass;
    velo : Velocity) IS

  BEGIN
    IF NOT self.configured THEN
      -- Configure GPIO output now

      ConfigurePin(self.pin);
      self.configured := True;
    END IF;

    -- Set the motor speed

    SendCommand(self.pin, self.chan, self.motor, velo);
  END Put;

END Motor.LEGORC.libspiagent;

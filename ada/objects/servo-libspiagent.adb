-- Servo output services using the Raspberry Pi LPC1114 I/O Processor Expansion
-- Board MUNTS-0004 (http://git.munts.com/rpi-mcu/expansion/LPC1114)
-- SPI Agent Firmware library libspiagent.so

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
WITH libspiagent;

USE TYPE Interfaces.Integer_32;

PACKAGE BODY Servo.libspiagent IS

  -- Constructors

  FUNCTION Create
   (id        : LPC11xx.pin_id_t;
    position  : Standard.Servo.Position := NeutralPosition;
    defer     : Boolean := False) RETURN Standard.Servo.Interfaces.Output IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    IF defer THEN
      -- Defer servo output configuration

      RETURN NEW OutputSubclass'(id, False);
    ELSE
      -- Configure servo output now

      Standard.libspiagent.Servo_Configure(LPC11xx.pin_id_t'Pos(id), error);

      IF error /= 0 THEN
        RAISE Servo_Error WITH "spiagent_servo_configure() failed, " &
          errno.strerror(Integer(error));
      END IF;

      -- Set the initial servo position

      Standard.libspiagent.Servo_Put(LPC11xx.pin_id_t'Pos(id),
        Float(position), error);

      IF error /= 0 THEN
        RAISE Servo_Error WITH "spiagent_servo_put() failed, " &
          errno.strerror(Integer(error));
      END IF;

      RETURN NEW OutputSubclass'(id, True);
    END IF;
  END Create;

  -- Methods

  PROCEDURE Put
   (self     : IN OUT OutputSubclass;
    position : Standard.Servo.Position) IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    IF NOT self.configured THEN
      -- Configure the servo output now

      Standard.libspiagent.Servo_Configure(LPC11xx.pin_id_t'Pos(self.id), error);

      IF error /= 0 THEN
        RAISE Servo_Error WITH "spiagent_servo_configure() failed, " &
          errno.strerror(Integer(error));
      END IF;

      self.configured := True;
    END IF;

    -- Set the servo position

    Standard.libspiagent.Servo_Put(LPC11xx.pin_id_t'Pos(self.id),
      Float(position), error);

    IF error /= 0 THEN
      RAISE Servo_Error WITH "spiagent_servo_put() failed, " &
        errno.strerror(Integer(error));
    END IF;
  END Put;

END Servo.libspiagent;

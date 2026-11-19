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

WITH Interfaces.C;

WITH libspiagent;     USE libspiagent;
WITH LPC1114IOP.GPIO; USE LPC1114IOP.GPIO;

USE TYPE Interfaces.C.int;
USE TYPE Interfaces.C.unsigned;

PACKAGE BODY LPC1114IOP.LEGORC IS

  -- Initialize a LEGO® RC output pin

  FUNCTION Create(pin : lpc11xx.pin_id_t) RETURN LEGORC IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT IsGPIO(pin) THEN
      RAISE LPC1114IOP.Error WITH "Invalid pin for LEGO RC output";
    END IF;

    spiagent_gpio_configure(To_Unsigned(pin),
      To_Unsigned(GPIO_DIRECTION_OUTPUT), To_Unsigned(False), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_configure_mode() failed, error" &
        error'Image;
    END IF;

    RETURN LEGORC'(pin => pin);
  END Create;

  -- Write LEGO® RC pin

  PROCEDURE Put
   (self      : LEGORC;
    channel   : legorc_channel_t;
    motor     : legorc_motor_t;
    direction : legorc_direction_t;
    speed     : legorc_speed_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_legorc_put(To_Unsigned(self.pin), To_Unsigned(channel),
      To_Unsigned(motor), To_Unsigned(direction), To_Unsigned(speed), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_legorc_put() failed, error" &
        error'Image;
    END IF;
  END Put;

END LPC1114IOP.LEGORC;

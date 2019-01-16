-- ADC pin services using the Raspberry Pi LPC1114 I/O Processor Expansion
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

PACKAGE BODY ADC.libspiagent IS

  FUNCTION Create
   (id    : LPC11xx.pin_id_t;
    defer : Boolean := False) RETURN Voltage.Interfaces.Input IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    IF defer THEN
      RETURN NEW InputSubclass'(id, False);
    ELSE
      Standard.libspiagent.Analog_Configure(LPC11xx.pin_id_t'Pos(id), error);

      IF error /= 0 THEN
        RAISE ADC_Error WITH "spiagent_analog_configure() failed, " &
          errno.strerror(Integer(error));
      END IF;

      RETURN NEW InputSubclass'(id, True);
    END IF;
  END Create;

-------------------------------------------------------------------------------

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Voltage.Volts IS

    error : Standard.Interfaces.Integer_32;
    V     : Float;

  BEGIN
    IF NOT self.configured THEN
      Standard.libspiagent.Analog_Configure(LPC11xx.pin_id_t'Pos(self.ID),
        error);

      IF error /= 0 THEN
        RAISE ADC_Error WITH "spiagent_analog_configure() failed, " &
          errno.strerror(Integer(error));
      END IF;

      self.configured := True;
    END IF;

    Standard.libspiagent.Analog_Get(LPC11xx.pin_id_t'Pos(self.ID), V, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "spiagent_analog_get() failed, " &
        errno.strerror(Integer(error));
    END IF;

    RETURN Voltage.Volts(V);
  END Get;

END ADC.libspiagent;

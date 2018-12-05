-- GPIO pin services using the Raspberry Pi LPC1114 I/O Processor Expansion
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
WITH GPIO;
WITH LPC11xx;
WITH libspiagent;

USE TYPE Interfaces.Integer_32;

PACKAGE BODY GPIO.libspiagent IS

-------------------------------------------------------------------------------

  -- Helper procedure to configure a GPIO pin mode and initial output state

  PROCEDURE ConfigurePin
   (id    : LPC11xx.pin_id_t;
    mode  : PinModes;
    state : Boolean) IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    Standard.libspiagent.GPIO_Configure_Mode(LPC11xx.pin_id_t'Pos(id),
      PinModes'Pos(mode), error);

    IF (error /= 0) THEN
      RAISE GPIO_Error WITH "spiagent_gpio_configure_mode() failed, " &
        errno.strerror(Integer(error));
    END IF;

    IF mode >= OutputPushPull THEN
      Standard.libspiagent.GPIO_Put(LPC11xx.pin_id_t'Pos(id),
        Boolean'Pos(state), error);

      IF error /= 0 THEN
        RAISE GPIO_Error WITH "spiagent_gpio_put() failed, " &
          errno.strerror(Integer(error));
      END IF;
    END IF;
  END ConfigurePin;

-------------------------------------------------------------------------------

  -- Helper function to read from a GPIO pin

  FUNCTION ReadPin(id : LPC11xx.pin_id_t) RETURN Boolean IS

    state : Standard.Interfaces.Unsigned_32;
    error : Standard.Interfaces.Integer_32;

  BEGIN
    Standard.libspiagent.GPIO_Get(LPC11xx.pin_id_t'Pos(id), state, error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "spiagent_gpio_get() failed, " &
        errno.strerror(Integer(error));
    END IF;

    RETURN Boolean'Val(state);
  END ReadPin;

-------------------------------------------------------------------------------

  -- Helper procedure to write to a GPIO pin

  PROCEDURE WritePin(id : LPC11xx.pin_id_t; state : Boolean) IS

    error : Standard.Interfaces.Integer_32;

  BEGIN
    Standard.libspiagent.GPIO_Put(LPC11xx.pin_id_t'Pos(id), Boolean'Pos(state),
      error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "spiagent_gpio_put() failed, " &
        errno.strerror(Integer(error));
    END IF;
  END WritePin;

-------------------------------------------------------------------------------

  -- GPIO pin object constructor returning GPIO.Pin

  FUNCTION Create
   (ID    : LPC11xx.pin_id_t;
    mode  : PinModes;
    state : Boolean := False;
    defer : Boolean := False) RETURN Standard.GPIO.Pin IS

  BEGIN
    IF mode <= InputPullup THEN
      -- Input pin
      IF defer THEN
        RETURN NEW PinSubclass'(ID, mode, False, False);
      ELSE
        ConfigurePin(ID, mode, False);
        RETURN NEW PinSubclass'(ID, mode, False, True);
      END IF;
    ELSE
      -- Output pin
      IF defer THEN
        RETURN NEW PinSubclass'(ID, mode, state, False);
      ELSE
        ConfigurePin(ID, mode, state);
        RETURN NEW PinSubclass'(ID, mode, state, True);
      END IF;
    END IF;
  END Create;

-------------------------------------------------------------------------------

  -- GPIO pin object constructor returning GPIO.Pin

  FUNCTION Create
   (id    : LPC11xx.pin_id_t;
    dir   : Standard.GPIO.Direction;
    state : Boolean := False;
    defer : Boolean := False) RETURN Standard.GPIO.Pin IS

  BEGIN
    IF dir = Standard.GPIO.Input THEN
      RETURN Create(id, InputHighImpedance, state, defer);
    ELSE
      RETURN Create(id, OutputPushPull, state, defer);
    END IF;
  END Create;

-------------------------------------------------------------------------------

  -- Read GPIO pin state

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

  BEGIN
    IF NOT self.configured THEN
      -- Configure the pin according to how it was created
      ConfigurePin(self.ID, self.mode, self.state);
      self.configured := True;
    END IF;

    RETURN ReadPin(self.ID);
  END Get;

-------------------------------------------------------------------------------

  -- Write GPIO pin state

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

  BEGIN
    IF self.configured AND (self.mode >= OutputPushPull) THEN
      -- Write to the configured output pin
      WritePin(self.ID, state);
      self.state := state;
    ELSIF self.configured AND (self.mode < OutputPushPull) THEN
      -- Reconfigure the configured input pin as a push-pull output
      ConfigurePin(self.ID, OutputPushPull, state);
      self.mode := OutputPushPull;
      self.state := state;
    ELSIF self.mode < OutputPushPull THEN
      -- Reconfigure the deferred input pin as a push pull output
      ConfigurePin(self.ID, OutputPushPull, state);
      self.mode := OutputPushPull;
      self.state := state;
      self.configured := True;
    ELSE
      -- Configure the deferred output pin
      ConfigurePin(self.ID, self.mode, state);
      self.state := state;
      self.configured := True;
    END IF;
  END Put;

END GPIO.libspiagent;

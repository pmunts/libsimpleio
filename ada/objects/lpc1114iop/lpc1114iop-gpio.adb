-- Raspberry Pi LPC1114 I/O Processor Expansion Board GPIO services

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

WITH GPIO;
WITH lpc11xx;         USE lpc11xx;
WITH libspiagent;     USE libspiagent;
WITH LPC1114IOP.Pins; USE LPC1114IOP.Pins;

USE TYPE Interfaces.C.int;
USE TYPE GPIO.Direction;

PACKAGE BODY LPC1114IOP.GPIO IS

  -- Validate a GPIO pin

  FUNCTION IsGPIO(pin : pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN ((pin >= LPC1114_GPIO0) AND (pin <= LPC1114_GPIO5)) OR
           ((pin >= LPC1114_GPIO6) AND (pin <= LPC1114_GPIO7));
  END IsGPIO;

  -- Create a GPIO pin object instance, given direction and initial state

  FUNCTION Create
   (pin    : pin_id_t;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    self : GPIOPinClass;

  BEGIN
    self.Initialize(pin, dir, state);
    RETURN NEW GPIOPinClass'(self);
  END Create;

  -- Create a GPIO pin object instance, given configuration and initial state

  FUNCTION Create
   (pin    : pin_id_t;
    iocfg  : gpio_mode_t;
    intcfg : gpio_interrupt_config_t := GPIO_INTERRUPT_DISABLED;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    self : GPIOPinClass;

  BEGIN
    self.Initialize(pin, iocfg, intcfg, state);
    RETURN NEW GPIOPinClass'(self);
  END Create;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (self   : OUT GPIOPinClass;
    pin    : pin_id_t;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) IS

  BEGIN
    self.pin := pin;

    IF dir = Standard.GPIO.Input THEN
      self.ConfigureMode(GPIO_MODE_INPUT);
      self.ConfigureInterrupt(GPIO_INTERRUPT_DISABLED);
    ELSE
      self.ConfigureMode(GPIO_MODE_OUTPUT);
      self.Put(state);
    END IF;
  END Initialize;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (self   : OUT GPIOPinClass;
    pin    : pin_id_t;
    iocfg  : gpio_mode_t;
    intcfg : gpio_interrupt_config_t := GPIO_INTERRUPT_DISABLED;
    state  : Boolean := False) IS

  BEGIN
    self.pin := pin;

    self.ConfigureMode(iocfg);

    IF iocfg < GPIO_MODE_OUTPUT THEN
      self.ConfigureInterrupt(intcfg);
    ELSE
      self.Put(state);
    END IF;
  END Initialize;

  PROCEDURE ConfigureMode
   (self  : GPIOPinClass;
    iocfg : gpio_mode_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_gpio_configure_mode(libspiagent.To_Unsigned(self.pin), libspiagent.To_Unsigned(iocfg), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_configure_mode() failed, error" & error'Image;
    END IF;
  END ConfigureMode;

  -- Configure GPIO pin interrupt

  PROCEDURE ConfigureInterrupt
   (self   : GPIOPinClass;
    intcfg : gpio_interrupt_config_t) IS

    error  : Interfaces.C.int;

  BEGIN
    spiagent_gpio_configure_interrupt(To_Unsigned(self.pin), To_Unsigned(intcfg), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_configure_interrupt() failed, error" & error'Image;
    END IF;
  END ConfigureInterrupt;

  -- Read from LPC1114 GPIO pin

  FUNCTION Get(self : IN OUT GPIOPinClass) RETURN Boolean IS

    state : Interfaces.C.unsigned;
    error : Interfaces.C.int;

  BEGIN
    spiagent_gpio_get(To_Unsigned(self.pin), state, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_get() failed, error" & error'Image;
    END IF;

    RETURN Boolean'VAL(state);
  END Get;

  -- Write to LPC1114 GPIO pin

  PROCEDURE Put(self : IN OUT GPIOPinClass; state : Boolean) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_gpio_put(To_Unsigned(self.pin), To_Unsigned(state), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_put() failed, error" & error'Image;
    END IF;
  END Put;

END LPC1114IOP.GPIO;

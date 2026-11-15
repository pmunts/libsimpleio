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

WITH spi_agent.pins;
USE spi_agent.pins;

PACKAGE spi_agent.gpio IS

  -- General Purpose Input/Output types

  TYPE gpio_direction_t IS
   (GPIO_INPUT,
    GPIO_OUTPUT);

  TYPE gpio_mode_t IS
   (GPIO_MODE_INPUT,			-- Normal high impedance input
    GPIO_MODE_INPUT_PULLDOWN,
    GPIO_MODE_INPUT_PULLUP,
    GPIO_MODE_OUTPUT,			-- Normal push-pull output
    GPIO_MODE_OUTPUT_OPENDRAIN);

  TYPE gpio_interrupt_config_t IS
   (GPIO_INTERRUPT_DISABLED,
    GPIO_INTERRUPT_FALLING,
    GPIO_INTERRUPT_RISING,
    GPIO_INTERRUPT_BOTH);

  TYPE GPIO IS TAGGED PRIVATE;

  -- Validate a GPIO pin

  FUNCTION IsGPIO(pin : pin_id_t) RETURN Boolean;

  -- Initialize a GPIO pin, given direction and initial state

  FUNCTION Create
   (pin    : pin_id_t;
    dir    : gpio_direction_t;
    state  : Boolean) RETURN GPIO;

  -- Initialize a GPIO pin, given configuration mode

  FUNCTION Create
   (pin    : pin_id_t;
    iocfg  : gpio_mode_t) RETURN GPIO;

  -- Configure GPIO pin mode

  PROCEDURE ConfigureMode
   (self   : GPIO;
    iocfg  : gpio_mode_t);

  -- Configure GPIO pin interrupt

  PROCEDURE ConfigureInterrupt
   (self   : GPIO;
    intcfg : gpio_interrupt_config_t);

  -- Read GPIO pin

  FUNCTION Get(self : GPIO) RETURN Boolean;

  -- Write GPIO pin

  PROCEDURE Put(self : GPIO; state : Boolean);

PRIVATE
  TYPE GPIO IS TAGGED RECORD
    pin : pin_id_t;
  END RECORD;
END spi_agent.gpio;

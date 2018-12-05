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

WITH GPIO;
WITH LPC11xx;

PACKAGE GPIO.libspiagent IS

  -- LPC1114 I/O Processor Expansion Board Input/Output pins

  INT   : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO0_3;
  READY : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO0_11;
  LED   : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO0_7;
  GPIO0 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_0;
  GPIO1 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_1;
  GPIO2 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_2;
  GPIO3 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_3;
  GPIO4 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_4;
  GPIO5 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_5;
  GPIO6 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_8;
  GPIO7 : CONSTANT LPC11xx.pin_id_t := LPC11xx.PIO1_9;

  -- Type definitions

  TYPE PinModes IS
   (InputHighImpedance,
    InputPulldown,
    InputPullup,
    OutputPushPull,
    OutputOpenDrain);

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH PRIVATE;

  -- GPIO pin object constructor returning Standard.GPIO.Pin

  FUNCTION Create
   (ID    : LPC11xx.pin_id_t;
    mode  : PinModes;
    state : Boolean := False;
    defer : Boolean := False) RETURN Standard.GPIO.Pin;

  -- GPIO pin object constructor returning Standard.GPIO.Pin

  FUNCTION Create
   (ID    : LPC11xx.pin_id_t;
    dir   : Standard.GPIO.Direction;
    state : Boolean := False;
    defer : Boolean := False) RETURN Standard.GPIO.Pin;

  -- Read GPIO pin state

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH RECORD
    ID         : LPC11xx.pin_id_t;
    mode       : PinModes;
    state      : Boolean;
    configured : Boolean;
  END RECORD;

END GPIO.libspiagent;

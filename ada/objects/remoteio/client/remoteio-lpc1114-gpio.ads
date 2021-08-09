-- LPC1114 I/O Processor GPIO pin services

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE RemoteIO.LPC1114.GPIO IS

  -- GPIO pin modes

  TYPE PinMode IS
   (Input_HighImpedance,
    Input_PullDown,
    Input_PullUp,
    Output_PushPull,
    Output_OpenDrain);

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH PRIVATE;

  -- Configure GPIO pin with SPIAGENT_CMD_CONFIGURE_GPIO_INPUT or
  -- SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT

  FUNCTION Create
   (absdev : NOT NULL RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) RETURN Standard.GPIO.Pin;

  -- Configure GPIO pin with SPIAGENT_CMD_CONFIGURE_GPIO

  FUNCTION Create
   (absdev : RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    mode   : PinMode;
    state  : Boolean := False) RETURN Standard.GPIO.Pin;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH RECORD
    dev : RemoteIO.LPC1114.Abstract_Device.Device;
    pin : Interfaces.Unsigned_32;
  END RECORD;

END RemoteIO.LPC1114.GPIO;

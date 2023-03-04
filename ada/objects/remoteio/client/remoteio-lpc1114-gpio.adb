-- LPC1114 I/O Processor GPIO pin services

-- Copyright (C)2019-2023, Philip Munts.
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

WITH GPIO;

USE TYPE GPIO.Direction;
USE TYPE Interfaces.Unsigned_32;

PACKAGE BODY RemoteIO.LPC1114.GPIO IS

  -- Configure GPIO pin with SPIAGENT_CMD_CONFIGURE_GPIO_INPUT or
  -- SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT

  FUNCTION Create
   (absdev : NOT NULL RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    IF dir = Standard.GPIO.Input THEN
      cmd.Command := SPIAGENT_CMD_CONFIGURE_GPIO_INPUT;
    ELSE
      cmd.Command := SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT;
    END IF;

    cmd.Pin  := desg;
    cmd.Data := Boolean'Pos(state);

    absdev.Operation(cmd, resp);

    RETURN NEW PinSubclass'(absdev, desg);
  END Create;

  -- Configure GPIO pin with SPIAGENT_CMD_CONFIGURE_GPIO

  FUNCTION Create
   (absdev : RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    mode   : PinMode;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Configure GPIO pin

    cmd.Command := SPIAGENT_CMD_CONFIGURE_GPIO;
    cmd.Pin     := desg;
    cmd.Data    := PinMode'Pos(mode);

    absdev.Operation(cmd, resp);

    -- Write output pin initial state

    IF mode >= Output_PushPull THEN
      cmd.Command := SPIAGENT_CMD_PUT_GPIO;
      cmd.Pin     := desg;
      cmd.Data    := Boolean'Pos(state);

      absdev.Operation(cmd, resp);
    END IF;

    RETURN NEW PinSubclass'(absdev, desg);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := SPIAGENT_CMD_GET_GPIO;
    cmd.Pin     := Self.pin;
    cmd.Data    := 0;

    Self.dev.Operation(cmd, resp);

    RETURN Boolean'Val(resp.data);
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := SPIAGENT_CMD_PUT_GPIO;
    cmd.Pin     := Self.pin;
    cmd.Data    := Boolean'Pos(state);

    Self.dev.Operation(cmd, resp);
  END Put;

END RemoteIO.LPC1114.GPIO;

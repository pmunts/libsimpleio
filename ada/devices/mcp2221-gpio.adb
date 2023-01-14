-- MCP2221 GPIO Pin Services

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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
WITH Messaging;
WITH Message64;

USE TYPE GPIO.Direction;
USE TYPE Messaging.Byte;

PACKAGE BODY MCP2221.GPIO IS
  PRAGMA Warnings(Off, """resp"" modified by call, but value *");

  -- GPIO pin constructor

  FUNCTION Create
   (dev       : NOT NULL Device;
    num       : PinNumber;
    direction : Standard.GPIO.Direction;
    state     : Boolean := False) RETURN Standard.GPIO.Pin IS

    cmd    : Message64.Message := (0 => CMD_SET_GPIO, OTHERS => 0);
    resp   : Message64.Message;
    offset : CONSTANT Natural := 2 + 4*Natural(num);

  BEGIN
    IF direction = Standard.GPIO.Input THEN

      -- Issue SET GPIO command

      cmd(offset + 2) := 1;
      cmd(offset + 3) := 1;

      dev.Command(cmd, resp);

      -- Verify command succeeded

      FOR i IN 0 .. 3 LOOP
        IF resp(offset + i) /= cmd(offset + i) THEN
          RAISE Standard.GPIO.GPIO_Error WITH "Pin mode is not GPIO";
        END IF;
      END LOOP;

      RETURN NEW PinSubclass'(dev.ALL, num, Standard.GPIO.Input, False);
    ELSE

      -- Issue SET GPIO command

      cmd(offset + 0) := 1;
      cmd(offset + 1) := Boolean'Pos(state);
      cmd(offset + 2) := 1;
      cmd(offset + 3) := 0;

      dev.Command(cmd, resp);

      -- Verify command succeeded

      FOR i IN 0 .. 3 LOOP
        IF resp(offset + i) /= cmd(offset + i) THEN
          RAISE Standard.GPIO.GPIO_Error WITH "Pin mode is not GPIO";
        END IF;
      END LOOP;

      RETURN NEW PinSubclass'(dev.ALL, num, Standard.GPIO.Output, state);
    END IF;
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    offset : CONSTANT Natural := 2 + 2*Natural(Self.num);
    cmd    : CONSTANT Message64.Message := (0 => CMD_GET_GPIO, OTHERS => 0);
    resp   : Message64.Message;

  BEGIN
    IF Self.dir = Standard.GPIO.Output THEN
      RETURN Self.latch;
    END IF;

    -- Issue GET GPIO command

    Self.dev.Command(cmd, resp);

    IF resp(offset) = 0 THEN
      RETURN False;
    ELSIF resp(offset) = 1 THEN
      RETURN True;
    ELSE
      RAISE Standard.GPIO.GPIO_Error WITH "GPIO pin is unavailable";
    END IF;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    offset : CONSTANT Natural := 2 + 4*Natural(Self.num);
    cmd    : Message64.Message := (0 => CMD_SET_GPIO, OTHERS => 0);
    resp   : Message64.Message;

  BEGIN
    IF Self.dir = Standard.GPIO.Input THEN
      RAISE Standard.GPIO.GPIO_Error WITH "Cannot write to input pin";
    END IF;

    -- Issue SET GPIO command

    cmd(offset + 0) := 1;
    cmd(offset + 1) := Boolean'Pos(state);

    Self.dev.Command(cmd, resp);

    -- Save state for read back

    Self.latch := state;
  END Put;

END MCP2221.GPIO;

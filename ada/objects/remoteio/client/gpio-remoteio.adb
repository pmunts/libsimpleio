-- GPIO pin services using the Remote I/O Protocol

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

WITH Messaging;
WITH Message64;

USE TYPE Messaging.Byte;

PACKAGE BODY GPIO.RemoteIO IS

  -- GPIO pin object constructor

  FUNCTION Create
   (dev      : NOT NULL Standard.RemoteIO.Client.Device;
    num      : Standard.RemoteIO.ChannelNumber;
    dir      : Direction;
    state    : Boolean := False;
    readback : Boolean := True) RETURN Pin IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    IF dir = GPIO.Input AND NOT readback THEN
      RAISE GPIO_Error WITH "Cannot disable readback for an input pin";
    END IF;

    -- Configure the GPIO pin as input or output

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_CONFIGURE_REQUEST));
    cmd(2 + num / 8) := 2**(7 - num MOD 8);

    IF dir = Output THEN
      cmd(18 + num / 8) := 2**(7 - num MOD 8);
    END IF;

    dev.Transaction(cmd, resp);

    -- Write initial state for output pin

    IF dir = Output THEN
      cmd := (OTHERS => 0);
      cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
        Standard.RemoteIO.GPIO_WRITE_REQUEST));
      cmd(2 + num / 8) := 2**(7 - num MOD 8);

      IF state THEN
        cmd(18 + num / 8) := 2**(7 - num MOD 8);
      END IF;

      dev.Transaction(cmd, resp);
    END IF;

    RETURN NEW PinSubclass'(dev, num, readback, state);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    IF NOT Self.readback THEN
      RETURN Self.latch;
    END IF;

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_READ_REQUEST));
    cmd(2 + Self.num / 8) := 2**(7 - Self.num MOD 8);

    Self.dev.Transaction(cmd, resp);

    IF (resp(3 + Self.num / 8) AND 2**(7 - Self.num MOD 8)) = 0 THEN
      RETURN False;
    ELSE
      RETURN True;
    END IF;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_WRITE_REQUEST));
    cmd(2 + Self.num / 8) := 2**(7 - Self.num MOD 8);

    IF state THEN
      cmd(18 + Self.num / 8) := 2**(7 - Self.num MOD 8);
    END IF;

    Self.dev.Transaction(cmd, resp);
    Self.latch := state;
  END Put;

END GPIO.RemoteIO;

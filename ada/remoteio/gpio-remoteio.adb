-- GPIO pin services using the Remote I/O Protocol

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

WITH errno;
WITH Messaging;
WITH Message64;
WITH RemoteIO;

USE TYPE Message64.Byte;

PACKAGE BODY GPIO.RemoteIO IS

  -- GPIO pin object constructor

  FUNCTION Create
   (dev   : Standard.RemoteIO.Device;
    num   : Standard.RemoteIO.ChannelNumber;
    dir   : Direction;
    state : Boolean := False) RETURN Pin IS

    cmd   : Message64.Message;
    resp  : Message64.Message;

  BEGIN

    -- Configure the GPIO pin as input or output

    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_CONFIGURE_REQUEST));
    cmd(2 + num / 8) := 2**(7 - num MOD 8);

    IF dir = Output THEN
      cmd(18 + num / 8) := 2**(7 - num MOD 8);
    END IF;

    dev.Transaction(cmd, resp);

    -- Write initial state for output pin

    IF dir = Output THEN
      cmd := (OTHERS => 0);
      cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
        Standard.RemoteIO.GPIO_WRITE_REQUEST));
      cmd(2 + num / 8) := 2**(7 - num MOD 8);

      IF state THEN
        cmd(18 + num / 8) := 2**(7 - num MOD 8);
      END IF;

      dev.Transaction(cmd, resp);
    END IF;

    RETURN NEW PinSubclass'(dev, num);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_READ_REQUEST));
    cmd(2 + self.num / 8) := 2**(7 - self.num MOD 8);

    self.dev.Transaction(cmd, resp);

    IF (resp(3 + self.num / 8) AND 2**(7 - self.num MOD 8)) = 0 THEN
      RETURN False;
    ELSE
      RETURN True;
    END IF;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.GPIO_WRITE_REQUEST));
    cmd(2 + self.num / 8) := 2**(7 - self.num MOD 8);

    IF state THEN
      cmd(18 + self.num / 8) := 2**(7 - self.num MOD 8);
    END IF;

    self.dev.Transaction(cmd, resp);
  END Put;

END GPIO.RemoteIO;

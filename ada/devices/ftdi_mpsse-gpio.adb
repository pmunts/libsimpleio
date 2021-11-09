-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;

USE TYPE GPIO.Direction;

PACKAGE BODY FTDI_MPSSE.GPIO IS

  -- MPSSE op codes for GPIO operations

  SET_BITS_LOW   : CONSTANT Byte := 16#80#;
  SET_BITS_HIGH  : CONSTANT Byte := 16#82#;
  READ_BITS_LOW  : CONSTANT Byte := 16#81#;
  READ_BITS_HIGH : CONSTANT Byte := 16#83#;
 
  -- GPIO pin object constructor

  FUNCTION Create
   (dev   : NOT NULL Device;
    name  : PinName;
    dir   : Standard.GPIO.Direction;
    state : Boolean := False) RETURN Standard.GPIO.Pin IS

    bitmask : Byte;
    Self    : Standard.GPIO.Pin;

  BEGIN
    -- Save the GPIO pin direction to dev.gpiodirslo or dev.gpiodirshi

    IF name <= D7 THEN
      bitmask := 2**(PinName'Pos(name));

      IF dir = Standard.GPIO.Output THEN
        dev.gpiodirslo := dev.gpiodirslo OR bitmask;
      ELSE
        dev.gpiodirslo := dev.gpiodirslo AND (NOT bitmask);
      END IF;
    ELSE
      bitmask := 2**(PinName'Pos(name) - 8);

      IF dir = Standard.GPIO.Output THEN
        dev.gpiodirshi := dev.gpiodirshi OR bitmask;
      ELSE
        dev.gpiodirshi := dev.gpiodirshi AND NOT bitmask;
      END IF;
    END IF;

    Self := NEW PinSubclass'(dev, name, bitmask, dir);

    IF dir = Standard.GPIO.Output THEN
      Self.Put(state);
    END IF;

    RETURN Self;
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    cmd     : Data(0 .. 0);
    resp    : Data(0 .. 0);

  BEGIN
    IF Self.dev = NULL THEN
      RAISE Error WITH "The FTDI device object is NULL";
    END IF;

    IF Self.name <= D7 THEN
      IF Self.dir = Standard.GPIO.Output THEN
        RETURN (Self.dev.gpiobitslo AND Self.bitmask) /= 0;
      ELSE
        cmd(0)  := READ_BITS_LOW;
      END IF;
    ELSE
      IF Self.dir = Standard.GPIO.Output THEN
        RETURN (Self.dev.gpiobitshi AND Self.bitmask) /= 0;
      ELSE
        cmd(0)  := READ_BITS_HIGH;
      END IF;
    END IF;

    Self.dev.Write(cmd, cmd'Length);
    Self.dev.Read(resp, resp'Length);
    RETURN (resp(0) AND Self.bitmask) /= 16#00#;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    cmd     : Data(0 .. 2);

  BEGIN
    IF Self.dev = NULL THEN
      RAISE Error WITH "The FTDI device object is NULL";
    END IF;

    IF Self.dir = Standard.GPIO.Input THEN
      RAISE Error WITH "Cannot write to an input pin";
    END IF;

    IF Self.name <= D7 THEN
      IF state THEN
        Self.dev.gpiobitslo := Self.dev.gpiobitslo OR Self.bitmask;
      ELSE
        Self.dev.gpiobitslo := Self.dev.gpiobitslo AND NOT Self.bitmask;
      END IF;

      cmd(0) := SET_BITS_LOW;
      cmd(1) := Self.dev.gpiobitslo;
      cmd(2) := Self.dev.gpiodirslo;
    ELSE
      IF state THEN
        Self.dev.gpiobitshi := Self.dev.gpiobitshi OR Self.bitmask;
      ELSE
        Self.dev.gpiobitshi := Self.dev.gpiobitshi AND NOT Self.bitmask;
      END IF;

      cmd(0) := SET_BITS_HIGH;
      cmd(1) := Self.dev.gpiobitshi;
      cmd(2) := Self.dev.gpiodirshi;
    END IF;

    Self.dev.Write(cmd, cmd'Length);
  END Put;

END FTDI_MPSSE.GPIO;

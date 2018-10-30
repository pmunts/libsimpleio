-- GPIO pin services using libsimpleio

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Directories;
WITH Ada.Strings.Fixed;

WITH errno;
WITH libGPIO;

PACKAGE BODY GPIO.libsimpleio IS

  -- Constructors returning GPIO.Pin

  FUNCTION Create
   (chip     : Natural;
    line     : Natural;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    RETURN GPIO.Pin(Pin'(Create(chip, line, dir, state, driver, edge, polarity)));
  END Create;

  FUNCTION Create
   (desg     : Designator;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    RETURN Create(desg.chip, desg.line, dir, state, driver, edge, polarity);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    state : Integer;
    error : Integer;

  BEGIN
    CASE Self.kind IS
      WHEN input|output =>
        libGPIO.LineRead(Self.fd, state, error);

        IF error /= 0 THEN
          RAISE GPIO_Error WITH "libGPIO.LineRead() failed, " &
            errno.strerror(error);
        END IF;

      WHEN interrupt =>
        libGPIO.LineEvent(Self.fd, state, error);

        IF error /= 0 THEN
          RAISE GPIO_Error WITH "libGPIO.LineEvent() failed, " &
            errno.strerror(error);
        END IF;
    END CASE;

    RETURN Boolean'Val(state);
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    error : Integer;

  BEGIN
    CASE Self.kind IS
      WHEN output =>
        libGPIO.LineWrite(Self.fd, Boolean'Pos(state), error);

        IF error /= 0 THEN
          RAISE GPIO_Error WITH "libGPIO.LineWrite() failed, " & errno.strerror(error);
        END IF;

      WHEN input|interrupt =>
        RAISE GPIO_Error WITH "Cannot write to a GPIO input";
    END CASE;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer IS

  BEGIN
    RETURN Self.fd;
  END fd;

END GPIO.libsimpleio;

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

  -- Constructor returning GPIO.libsimpleio.Pin

  FUNCTION Create
   (number   : Positive;
    dir      : Direction;
    state    : Boolean := False;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.libsimpleio.Pin IS

    fd       : Integer;
    error    : Integer;

  BEGIN
    libGPIO.Configure(number, Direction'Pos(dir), Boolean'Pos(state),
      GPIO.libsimpleio.Edge'Pos(edge), GPIO.libsimpleio.Polarity'Pos(polarity), error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libGPIO.Configure() failed, " & errno.strerror(error);
    END IF;

    libGPIO.Open(number, fd, error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libGPIO.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN NEW PinSubclass'(number, fd);
  END Create;

  -- Constructor returning GPIO.pin

  FUNCTION Create
   (number   : Positive;
    dir      : Direction;
    state    : Boolean := False;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    RETURN GPIO.Pin(Pin'(Create(number, dir, state, edge, polarity)));
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

    state : Integer;
    error : Integer;

  BEGIN
    libGPIO.Read(self.fd, state, error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libGPIO.Read() failed, " & errno.strerror(error);
    END IF;

    RETURN Boolean'Val(state);
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

    error : Integer;

  BEGIN
    libGPIO.Write(self.fd, Boolean'Pos(state), error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libGPIO.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(self : PinSubclass) RETURN Integer IS

  BEGIN
    RETURN self.fd;
  END fd;

END GPIO.libsimpleio;

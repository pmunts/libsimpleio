-- GPIO pin services using libsimpleio

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

WITH Device;

PACKAGE GPIO.libsimpleio IS

  -- Type definitions

  TYPE Driver IS (PushPull, OpenDrain, OpenSource);

  TYPE Edge IS (None, Rising, Falling, Both);

  TYPE Polarity IS (ActiveLow, ActiveHigh);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH PRIVATE;

  Destroyed : CONSTANT PinSubclass;

  -- GPIO pin object constructors

  FUNCTION Create
   (desg     : Device.Designator;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin;

  -- GPIO pin object initializers

  PROCEDURE Initialize
   (Self     : IN OUT PinSubclass;
    desg     : Device.Designator;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh);

  -- GPIO pin object destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass);

  -- Read GPIO pin state

  -- Notes for interrupt inputs (i.e. edge /= None):
  --
  -- Get() will block the calling task indefinitely until a matching input
  -- edge detection event occurs.  If blocking is unacceptable, you can wait
  -- using libEvent.Wait() or libLinux.Poll() with an appropriate timeout
  -- before calling Get().
  --
  -- Get() returns the state of the input pin *after* the latest edge
  -- detection event (i.e. False after a falling edge and True after a rising
  -- edge).
  --
  -- If both rising and falling edge detection are enabled (i.e. edge = Both),
  -- there is no guarantee that every edge will be detected (e.g. a single
  -- very narrow pulse rising and falling) and the value returned by Get() may
  -- in fact be stale by the time it is delivered.

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer;

PRIVATE

  -- Check whether GPIO pin object has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass);

  TYPE Kinds IS (input, output, interrupt);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH RECORD
    kind : Kinds   := input;
    fd   : Integer := -1;
  END RECORD;

  Destroyed : CONSTANT PinSubclass := PinSubclass'(input, -1);

END GPIO.libsimpleio;

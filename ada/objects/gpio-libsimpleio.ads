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

WITH Device;

PACKAGE GPIO.libsimpleio IS

  -- Type definitions

  TYPE Driver IS (PushPull, OpenDrain, OpenSource);

  TYPE Edge IS (None, Rising, Falling, Both);

  TYPE Polarity IS (ActiveLow, ActiveHigh);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH PRIVATE;

  TYPE Pin IS ACCESS PinSubclass;

  Destroyed : CONSTANT PinSubclass;

  -- Constructors returning GPIO.Pin

  FUNCTION Create
   (chip     : Natural;
    line     : Natural;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin;

  FUNCTION Create
   (desg     : Device.Designator;
    dir      : GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver := PushPull;
    edge     : GPIO.libsimpleio.Edge := None;
    polarity : GPIO.libsimpleio.Polarity := ActiveHigh) RETURN GPIO.Pin;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer;

PRIVATE

  TYPE Kinds IS (input, output, interrupt);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH RECORD
    kind : Kinds;
    fd   : Integer;
  END RECORD;

  Destroyed : CONSTANT PinSubclass := PinSubclass'(input, -1);

END GPIO.libsimpleio;

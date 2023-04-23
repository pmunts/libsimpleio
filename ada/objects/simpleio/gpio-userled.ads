-- GPIO pin services using a user LED at /dev/userled

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE GPIO.UserLED IS

  -- Determine whether the user LED is available

  FUNCTION Available RETURN Boolean;

  -- Class definitions

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH PRIVATE;

  Destroyed : CONSTANT PinSubclass;

  -- Constructor

  FUNCTION Create(state : Boolean := False) RETURN GPIO.Pin;

  -- Initializer

  PROCEDURE Initialize(Self : IN OUT PinSubclass; state : Boolean := False);

  -- Destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass);

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer;

PRIVATE

  -- Check whether GPIO pin has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH RECORD
    myfd : Integer := -1;
  END RECORD;

  Destroyed : CONSTANT PinSubclass := PinSubclass'(myfd => -1);

END GPIO.UserLED;

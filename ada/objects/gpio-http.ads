-- GPIO pin services using the GPIO extension HTTP server on TCP port 8083

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

PRIVATE WITH Ada.Strings.Unbounded;

PACKAGE GPIO.HTTP IS

  TYPE PinSubclass IS NEW PinInterface WITH PRIVATE;

  Destroyed : CONSTANT PinSubclass;

  -- GPIO pin object constructor

  FUNCTION Create
   (hostname : String;
    num      : Natural;
    dir      : Direction;
    state    : Boolean := False) RETURN Pin;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (Self     : IN OUT PinSubclass;
    hostname : String;
    num      : Natural;
    dir      : Direction;
    state    : Boolean := False);

  -- GPIO pin object destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass);

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  -- Check whether GPIO pin has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass);

  NullString : CONSTANT Ada.Strings.UnBounded.Unbounded_String :=
    Ada.Strings.Unbounded.Null_Unbounded_String;

  TYPE PinSubclass IS NEW PinInterface WITH RECORD
    GetCmd : Ada.Strings.Unbounded.Unbounded_String := NullString;
    ClrCmd : Ada.Strings.Unbounded.Unbounded_String := NullString;
    SetCmd : Ada.Strings.Unbounded.Unbounded_String := NullString;
    ClrRsp : Ada.Strings.Unbounded.Unbounded_String := NullString;
    SetRsp : Ada.Strings.Unbounded.Unbounded_String := NullString;
  END RECORD;

  Destroyed : CONSTANT PinSubclass := PinSubclass'(NullString, NullString,
    NullString, NullString, NullString);

END GPIO.HTTP;

-- Device driver for the Grove 12 Button Capacitive Touch Keypad

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

-- See also:
--
-- https://wiki.seeedstudio.com/Grove-12-Channel-Capacitive-Touch-Keypad-ATtiny1616-/

WITH Keyboard;

PACKAGE Grove_Keypad IS

  TYPE InputSubclass IS NEW Keyboard.InputInterface WITH PRIVATE;

  -- Keypad input object constructor

  FUNCTION Create(portname : String) RETURN Keyboard.Input;

  -- Keypad input object instance initializer

  PROCEDURE Initialize(Self : OUT InputSubclass; portname : String);

  -- Method to fetch the next character from the input buffer.
  -- If the timeout expires, return ASCII.NUL.

  FUNCTION Get
   (Self    : InputSubclass;
    timeout : Duration := Keyboard.DefaultTimeout) RETURN Character;

  -- Method to clear the input buffer.

  PROCEDURE Clear(Self : InputSubclass);

PRIVATE

  -- Define background receiver task type

  TASK TYPE ReceiverTask IS
    ENTRY Initialize(fd : Integer);
    ENTRY Get(c : OUT Character; timeout : Duration);
    ENTRY Clear;
  END ReceiverTask;

  TYPE ReceiverAccess IS ACCESS ReceiverTask;

  TYPE InputSubclass IS NEW Keyboard.InputInterface WITH RECORD
    receiver : ReceiverAccess := NULL;
  END RECORD;

END Grove_Keypad;

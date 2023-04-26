-- GPIB (aka HPIB aka IEEE-488) bus controller services using the Prologix
-- GPIB-USB adapter.

-- Copyright (C)2023, Philip Munts.
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

WITH GPIB;

PRIVATE WITH Ada.Streams.Stream_IO;

PACKAGE Prologix_GPIB_USB_GNAT IS

  TYPE ControllerSubclass IS NEW GPIB.ControllerInterface WITH PRIVATE;

  -- IEEE-488 bus controller object initializer

  PROCEDURE Initialize(Self : OUT ControllerSubclass; name : String);

  -- IEEE-488 bus controller object constructor

  FUNCTION Create(name : String) RETURN GPIB.Controller;

 -- Select a particular slave device for the next operation(s)

  PROCEDURE SelectSlave(Self : IN OUT ControllerSubclass; slave : GPIB.Address);

  -- Issue a text command to the most recently selected IEEE-488 slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; cmd : String);

  -- Fetch a text response from the most recently selected IEEE-488 slave device

  FUNCTION Get(Self : IN OUT ControllerSubclass) RETURN String;

  -- Issue Device Clear (DCL) command to the most recently selected IEEE-488 slave device

  PROCEDURE Clear(Self : IN OUT ControllerSubclass);

PRIVATE

  TYPE ControllerSubclass IS NEW GPIB.ControllerInterface WITH RECORD
    stream    : Ada.Streams.Stream_IO.Stream_Access;
    lastslave : Natural := 31;
  END RECORD;

END Prologix_GPIB_USB_GNAT;

-- GPIB (aka HPIB aka IEEE-488) slave device services

-- Copyright (C)2023, Philip Munts dba Munts Technologies.
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

PACKAGE GPIB.Slave IS

  TYPE DeviceClass IS TAGGED PRIVATE;
  TYPE Device      IS ACCESS ALL DeviceClass'Class;

  -- IEEE-488 slave device object initializer

  PROCEDURE Initialize
   (Self   : OUT DeviceClass;
    master : Controller;
    slave  : Address);

  -- IEEE-488 slave device object constructor

  FUNCTION Create
   (master : Controller;
    slave  : Address) RETURN Device;

  -- Issue a text command to this slave device

  PROCEDURE Put(Self : DeviceClass; cmd : String);

  -- Get a text response from this slave device

  FUNCTION Get(Self : DeviceClass) RETURN String;

  -- Issue Device Clear (DCL) command to this slave device

  PROCEDURE Clear(Self : DeviceClass);

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    master : Controller;
    slave  : Address;
  END RECORD;

END GPIB.Slave;

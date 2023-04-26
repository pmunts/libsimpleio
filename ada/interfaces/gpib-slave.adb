-- GPIB (aka HPIB aka IEEE-488) slave device services

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

PACKAGE BODY GPIB.Slave IS

  -- IEEE-488 slave device object initializer

  PROCEDURE Initialize
   (Self   : OUT DeviceClass;
    master : GPIB.Controller;
    slave  : GPIB.Address) IS

  BEGIN
    Self.master := master;
    Self.slave  := slave;
  END Initialize;

  -- IEEE-488 slave device object constructor

  FUNCTION Create
   (master : GPIB.Controller;
    slave  : Address) RETURN Device IS

    Self : DeviceClass;

  BEGIN
    Self.Initialize(master, slave);
    RETURN NEW DeviceClass'(Self);
  END Create;

  -- Issue a text command to this slave device

  PROCEDURE Put(Self : DeviceClass; cmd : String) IS

  BEGIN
    Self.master.SelectSlave(Self.slave);
    Self.master.Put(cmd);
  END Put;

  -- Get a text response from this slave device

  FUNCTION Get(Self : DeviceClass) RETURN String IS

  BEGIN
    Self.master.SelectSlave(Self.slave);
    RETURN Self.master.Get;
  END Get;

  -- Issue Device Clear (DCL) command to this slave device

  PROCEDURE Clear(Self : DeviceClass) IS

  BEGIN
    Self.master.SelectSlave(Self.slave);
    Self.master.Clear;
  END Clear;

END GPIB.Slave;

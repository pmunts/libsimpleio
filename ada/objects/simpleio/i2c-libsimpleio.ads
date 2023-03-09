-- I2C bus controller services using libsimpleio

-- Copyright (C)2016-2023, Philip Munts.
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

PACKAGE I2C.libsimpleio IS

  -- Type definitions

  TYPE BusSubclass IS NEW I2C.BusInterface WITH PRIVATE;

  Destroyed : CONSTANT BusSubclass;

  -- I2C bus controller object constructor

  FUNCTION Create(desg : Device.Designator) RETURN I2C.Bus;

  -- I2C bus controller object initializer

  PROCEDURE Initialize(Self : IN OUT BusSubclass; desg : Device.Designator);

  -- I2C bus controller object destroyer

  PROCEDURE Destroy(Self : IN OUT BusSubclass);

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusSubclass;
    addr    : I2C.Address;
    resp    : OUT I2C.Response;
    resplen : Natural);

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self   : BusSubclass;
    addr   : I2C.Address;
    cmd    : I2C.Command;
    cmdlen : Natural);

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusSubclass;
    addr    : I2C.Address;
    cmd     : I2C.Command;
    cmdlen  : Natural;
    resp    : OUT I2C.Response;
    resplen : Natural;
    delayus : MicroSeconds := 0);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : BusSubclass) RETURN Integer;

PRIVATE

  -- Check whether I2C bus has been destroyed

  PROCEDURE CheckDestroyed(Self : BusSubclass);

  TYPE BusSubclass IS NEW I2C.BusInterface WITH RECORD
    desg : Device.Designator := Device.Unavailable;
    fd   : Integer           := -1;
  END RECORD;

  Destroyed : CONSTANT BusSubclass := BusSubclass'(Device.Unavailable, -1);

END I2C.libsimpleio;

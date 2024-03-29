-- MCP2221 I2C Bus Controller Services

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

WITH I2C;

PACKAGE MCP2221.I2C IS

  -- Type definitions

  TYPE BusSubclass IS NEW Standard.I2C.BusInterface WITH PRIVATE;

  -- Constructor

  FUNCTION Create(dev : NOT NULL Device) RETURN Standard.I2C.Bus;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusSubclass;
    addr    : Standard.I2C.Address;
    resp    : OUT Standard.I2C.Response;
    resplen : Natural);

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self   : BusSubclass;
    addr   : Standard.I2C.Address;
    cmd    : Standard.I2C.Command;
    cmdlen : Natural);

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusSubclass;
    addr    : Standard.I2C.Address;
    cmd     : Standard.I2C.Command;
    cmdlen  : Natural;
    resp    : OUT Standard.I2C.Response;
    resplen : Natural;
    delayus : Standard.I2C.MicroSeconds := 0);

PRIVATE

  TYPE BusSubclass IS NEW Standard.I2C.BusInterface WITH RECORD
    dev : Device;
  END RECORD;

END MCP2221.I2C;

-- I2C bus controller services using the Remote I/O Protocol

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

WITH RemoteIO.Client;

PACKAGE I2C.RemoteIO IS

  TYPE BusSubclass IS NEW I2C.BusInterface WITH PRIVATE;

  -- I2C bus object constructor

  FUNCTION Create
   (dev   : NOT NULL Standard.RemoteIO.Client.Device;
    num   : Standard.RemoteIO.ChannelNumber;
    speed : Positive := I2C.SpeedStandard) RETURN I2C.Bus;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusSubclass;
    addr    : Address;
    resp    : OUT Response;
    resplen : Natural);

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self   : BusSubclass;
    addr   : Address;
    cmd    : Command;
    cmdlen : Natural);

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusSubclass;
    addr    : Address;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0);

PRIVATE

  TYPE BusSubclass IS NEW I2C.BusInterface WITH RECORD
    dev : Standard.RemoteIO.Client.Device;
    num : Standard.RemoteIO.ChannelNumber;
  END RECORD;

END I2C.RemoteIO;

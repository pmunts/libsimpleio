-- SPI device services using the Remote I/O Protocol

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

PACKAGE SPI.RemoteIO IS

  TYPE DeviceSubclass IS NEW SPI.DeviceInterface WITH PRIVATE;

  -- SPI device object constructor

  FUNCTION Create
   (dev      : NOT NULL Standard.RemoteIO.Client.Device;
    num      : Standard.RemoteIO.ChannelNumber;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural) RETURN SPI.Device;

  -- Read only SPI device transaction method

  PROCEDURE Read
   (Self    : DeviceSubclass;
    resp    : OUT Response;
    resplen : Natural);

  -- Write only SPI device transaction method

  PROCEDURE Write
   (Self   : DeviceSubclass;
    cmd    : Command;
    cmdlen : Natural);

  -- Combined Write/Read SPI device transaction method

  PROCEDURE Transaction
   (Self    : DeviceSubclass;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0);

PRIVATE

  TYPE DeviceSubclass IS NEW SPI.DeviceInterface WITH RECORD
    dev : Standard.RemoteIO.Client.Device;
    num : Standard.RemoteIO.ChannelNumber;
  END RECORD;

END SPI.RemoteIO;

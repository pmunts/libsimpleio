-- Abstract device services using the Remote I/O Protocol

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

WITH Message64;
WITH RemoteIO.Client;

GENERIC

  TYPE Command  IS PRIVATE;
  TYPE Response IS PRIVATE;

  WITH FUNCTION FromCommand(cmd : Command) RETURN Message64.Message IS <>;
  WITH FUNCTION ToResponse(msg : Message64.Message) RETURN Response IS <>;

PACKAGE RemoteIO.Abstract_Device IS

  -- Abstract device exception definitions

  Device_Error : EXCEPTION;

  -- Abstract device type definitions

  TYPE DeviceClass IS TAGGED PRIVATE;
  TYPE Device      IS ACCESS ALL DeviceClass'Class;

  -- Abstract device object constructor

  FUNCTION Create
   (remdev  : NOT NULL RemoteIO.Client.Device;
    channel : RemoteIO.ChannelNumber) RETURN Device;

  -- Get abstract device information string

  FUNCTION GetInfo
   (Self    : IN OUT DeviceClass) RETURN String;

  -- Perform abstract device operation

  PROCEDURE Operation
   (Self    : DeviceClass;
    cmd     : Command;
    resp    : OUT Response);

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    remdev  : RemoteIO.Client.Device;
    channel : RemoteIO.ChannelNumber;
  END RECORD;

END RemoteIO.Abstract_Device;

-- Remote I/O Client Services using Message64 transport (e.g. raw HID)

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

WITH Messaging;
WITH Message64;

PACKAGE RemoteIO.Client IS

  -- Define a tagged type for remote I/O server devices

  TYPE DeviceClass IS TAGGED PRIVATE;

  -- Define an access type compatible with any subclass implementing
  -- DeviceClass

  TYPE Device IS ACCESS ALL DeviceClass'Class;

  -- Constructors

  FUNCTION Create(msg : NOT NULL Message64.Messenger) RETURN Device;

  -- Perform a Remote I/O operation

  PROCEDURE Transaction
   (Self : IN OUT DeviceClass;
    cmd  : IN OUT Message64.Message;
    resp : OUT Message64.Message);

  -- Get the remote device version string

  FUNCTION GetVersion(Self : IN OUT DeviceClass) RETURN String;

  -- Get the remote device capability string

  FUNCTION GetCapability(Self : IN OUT DeviceClass) RETURN String;

  -- Get the available channels for a given service type

  FUNCTION GetAvailableChannels
   (Self    : IN OUT DeviceClass;
    service : ChannelTypes) RETURN ChannelSets.Set;

  -- Return the underlying Message64.Messenger object

  FUNCTION GetMessenger(Self : IN OUT DeviceClass) RETURN Message64.Messenger;

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    msg : Message64.Messenger;
    num : Messaging.Byte;
  END RECORD;

END RemoteIO.Client;

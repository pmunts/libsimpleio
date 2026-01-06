-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

WITH Interfaces.C.Strings;
WITH Paho_MQTT_sync; USE Paho_MQTT_sync;
WITH System;

PACKAGE MQTT.Paho IS

  TYPE Server_Class IS TAGGED PRIVATE;
  TYPE Server       IS ACCESS ALL Server_Class'Class;

  -- Third level message received callback

  TYPE SubCallback3 IS ACCESS PROCEDURE
   (topic   : String;
    message : String);

  -- Initialize an MQTT server object instance

  PROCEDURE Initialize
   (Self      : IN OUT Server_Class;
    URI       : String       := Default_URI;
    ID        : String       := Default_ID;
    callback3 : SubCallback3 := Null);

  -- Destroy an MQTT server object instance

  PROCEDURE Destroy(Self : IN OUT Server_Class);

  -- Connect to the server

  PROCEDURE Connect
   (Self      : Server_Class;
    username  : String := Default_User;
    password  : String := Default_Pass);

  -- Disconnect from the server

  PROCEDURE Disconnect
   (Self      : Server_Class;
    timeoutms : Natural := Default_Timeout);

  -- Publish a string message to the server

  PROCEDURE Publish
   (Self      : Server_Class;
    topic     : String;
    message   : String;
    QOS       : Integer := Default_QOS);

  -- Subscribe to messages from the server

  PROCEDURE Subscribe
   (Self      : Server_Class;
    topic     : String;
    QOS       : Integer := Default_QOS);

PRIVATE

  -- Check whether an MQTT server object instance has been destroyed

  PROCEDURE CheckDestroyed(Self : Server_Class);

  TYPE Server_Class IS TAGGED RECORD
    handle    : Server_Handle := Null_Handle;
    callback3 : SubCallback3  := Null;
    connected : Boolean       := false;
  END RECORD;

  Destroyed : CONSTANT Server_Class := Server_Class'(Null_Handle, Null, false);

  -- Second level message received callback

  PROCEDURE subcallback2
   (context   : System.Address;
    topic     : Interfaces.C.Strings.chars_ptr;
    payload   : Interfaces.C.Strings.chars_ptr);

  PRAGMA Export(C, subcallback2);

END MQTT.Paho;

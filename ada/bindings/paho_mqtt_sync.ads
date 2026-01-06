-- Ada thin binding for the Paho MQTT C Client Library
-- wrapper functions in paho_mqtt_sync_wrappers.c
--
-- See https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html
-- for more information.

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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
WITH System;

PACKAGE Paho_MQTT_sync IS

  -- Define a type for server handles

  TYPE Server_Handle IS NEW System.Address;

  Null_Handle  : CONSTANT Server_Handle := Server_Handle(System.Null_Address);

  Default_URI     : CONSTANT String  := "tcp://localhost:1883";
  Default_ID      : CONSTANT String  := "MQTT client";
  Default_User    : CONSTANT String  := "guest";
  Default_Pass    : CONSTANT String  := "guest";
  Default_QOS     : CONSTANT Integer := 0;
  Default_Timeout : CONSTANT Integer := 1000; -- milliseconds

  -- Create a server handle

  PROCEDURE Create
   (handle  : OUT Server_Handle;
    URI     : String;
    ID      : String;
    context : System.Address;
    error   : OUT Integer);

  -- Destroy a server handle

  PROCEDURE Destroy
   (handle  : OUT Server_Handle;
    error   : OUT Integer);

  -- Open a connection to the MQTT server

  PROCEDURE Connect
   (handle  : Server_Handle;
    user    : String;
    pass    : String;
    error   : OUT Integer);

  -- Disconnect from the MQTT server

  PROCEDURE Disconnect
   (handle  : Server_Handle;
    timeout : Integer;
    error   : OUT Integer);

  -- Publish a message to the MQTT server

  PROCEDURE Publish
   (handle  : Server_Handle;
    topic   : String;
    message : String;
    QOS     : Integer;
    error   : OUT Integer);

  -- Subscribe to messages from the MQTT server

  PROCEDURE Subscribe
   (handle  : Server_Handle;
    topic   : String;
    QOS     : Integer;
    error   : OUT Integer);

  -- Fetch an error message as a C string

  FUNCTION strerrorC(error : Integer) RETURN Interfaces.C.Strings.chars_ptr;

  -- Fetch an error message as an Ada string

  FUNCTION strerror(error : Integer) RETURN String IS
   (Interfaces.C.Strings.Value(strerrorC(error)));

  PRAGMA Import(C, strerrorC,  "MQTTClient_strerror");

  -- The following wrapper functions are defined in paho_mqtt_sync_wrappers.c

  PRAGMA Import(C, Create,     "Paho_MQTT_sync_create");
  PRAGMA Import(C, Destroy,    "Paho_MQTT_sync_destroy");
  PRAGMA Import(C, Connect,    "Paho_MQTT_sync_connect");
  PRAGMA Import(C, Disconnect, "Paho_MQTT_sync_disconnect");
  PRAGMA Import(C, Publish,    "Paho_MQTT_sync_publish_string");
  PRAGMA Import(C, Subscribe,  "Paho_MQTT_sync_subscribe_string");

  PRAGMA Link_With("-lpaho-mqtt3c -lsimpleio");
END Paho_MQTT_sync;

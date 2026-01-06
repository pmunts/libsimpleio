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

WITH Ada.Environment_Variables;

PACKAGE BODY MQTT.Paho IS

  -- Get a configuration value, from a parameter or from an environment variable

  FUNCTION GetEnv(parm : String; var : String; default : String) RETURN String IS

  BEGIN
    RETURN (IF parm /= default THEN parm ELSE Ada.Environment_Variables.Value(var, default));
  END GetEnv;

  -- Create an MQTT server object instance

  FUNCTION Create
   (URI       : String := Default_URI;
    ID        : String := Default_ID) RETURN Server IS

    Self : Server_Class;

  BEGIN
    Self.Initialize(URI, ID);
    RETURN NEW Server_Class'(Self);
  END Create;

  -- Initialize an MQTT server object instance

  PROCEDURE Initialize
   (Self      : IN OUT Server_Class;
    URI       : String := Default_URI;
    ID        : String := Default_ID) IS

    error : Integer;

  BEGIN
    Self.Destroy;

    Create(Self.handle, GetEnv(URI, "MQTT_URI", Default_URI) & ASCII.Nul,
      GetEnv(ID, "MQTT_ID", Default_ID) & ASCII.Nul, error);

    IF error /= 0 THEN
      RAISE MQTT.Error WITH "Paho_MQTT_sync.Create() failed, " & strerror(error);
    END IF;
  END Initialize;

  -- Destroy an MQTT server object instance

  PROCEDURE Destroy(Self : IN OUT Server_Class) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    IF Self.connected THEN
      Self.Disconnect(Default_Timeout);
      Self.connected := false;
    END IF;

    Destroy(Self.handle, error);

    IF error /= 0 THEN
      RAISE MQTT.Error WITH "Paho_MQTT_sync.Destroy() failed, " & strerror(error);
    END IF;

    Self := Destroyed;
  END Destroy;

  -- Connect to the server

  PROCEDURE Connect
   (Self      : Server_Class;
    username  : String := Default_User;
    password  : String := Default_Pass) IS

    error : integer;

  BEGIN
    Self.CheckDestroyed;

    Connect(Self.handle, GetEnv(username, "MQTT_USER", Default_User) & ASCII.Nul,
      GetEnv(password, "MQTT_PASS", Default_Pass) & ASCII.Nul, error);

    IF error /= 0 THEN
      RAISE MQTT.Error WITH "Paho_MQTT_sync.Connect() failed, " & strerror(error);
    END IF;
  END Connect;

  -- Disconnect from the server

  PROCEDURE Disconnect
   (Self      : Server_Class;
    timeoutms : Natural := Default_Timeout) IS

    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    Disconnect(Self.handle, timeoutms, error);

    IF error /= 0 THEN
      RAISE MQTT.Error WITH "Paho_MQTT_sync.Disconnect() failed, " & strerror(error);
    END IF;
  END Disconnect;

  -- Publish a string message to the server

  PROCEDURE Publish
   (Self      : Server_Class;
    topic     : String;
    message   : String;
    QOS       : Integer := Default_QOS) IS

    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    Publish(Self.handle, topic, message, QOS, error);

    IF error /= 0 THEN
      RAISE MQTT.Error WITH "Paho_MQTT_sync.Publish() failed, " & strerror(error);
    END IF;
  END Publish;

  -- Check whether an MQTT server object instance has been destroyed

  PROCEDURE CheckDestroyed(Self : Server_Class) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "This instance has been destroyed.";
    END IF;
  END CheckDestroyed;

END MQTT.Paho;

-- Paho MQTT Message Subscribe Test

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH MQTT.Paho;

PROCEDURE test_mqtt_subscribe IS

  PROCEDURE Callback(topic : String; msg : String) IS

  BEGIN
    Put_Line("Topic:   " & topic);
    Put_Line("Message: " & msg);
  END Callback;

  server : MQTT.Paho.Server_Class;
  
BEGIN
  New_Line;
  Put_Line("Paho MQTT Message Subscribe Test");
  New_Line;

  server.Initialize(callback3 => CallBack'Unrestricted_Access);
  server.Connect;
  server.Subscribe("test");

  Put_Line("Press ENTER to exit.");

  DECLARE
    s : String := Get_Line;
  BEGIN
    NULL;
  END;

  server.Disconnect;
  server.Destroy;
END test_mqtt_subscribe;

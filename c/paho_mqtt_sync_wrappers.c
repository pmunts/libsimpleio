// Ada and Pascal friendly wrapper functions for the Paho MQTT C Client Library
//
// See https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html
// for more information.

// Copyright (C)2025, Philip Munts dba Munts Technologies.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#include <MQTTClient.h>

#pragma weak MQTTClient_create
#pragma weak MQTTClient_destroy
#pragma weak MQTTClient_connect
#pragma weak MQTTClient_disconnect
#pragma weak MQTTClient_publishMessage

void Paho_MQTT_sync_create(MQTTClient *handle, char *URI, char *ID, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if ((handle == NULL) || (URI == NULL) || (ID == NULL))
  {
    *error = MQTTCLIENT_NULL_PARAMETER;
    return;
  }

  *error = MQTTClient_create(handle, URI, ID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
}

void Paho_MQTT_sync_destroy(MQTTClient *handle, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (handle == NULL)
  {
    *error = MQTTCLIENT_NULL_PARAMETER;
    return;
  }

  MQTTClient_destroy(handle);
  *error = MQTTCLIENT_SUCCESS;
}

void Paho_MQTT_sync_connect(MQTTClient handle, char *user, char *pass, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (handle == NULL)
  {
    *error = MQTTCLIENT_NULL_PARAMETER;
    return;
  }

  MQTTClient_connectOptions options = MQTTClient_connectOptions_initializer;
  options.cleansession = true;
  options.keepAliveInterval = 20;
  options.username = user;
  options.password = pass;

  *error = MQTTClient_connect(handle, &options);
}

void Paho_MQTT_sync_disconnect(MQTTClient handle, int32_t timeout, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (handle == NULL)
  {
    *error = MQTTCLIENT_NULL_PARAMETER;
    return;
  }

  *error = MQTTClient_disconnect(handle, timeout);
}

void Paho_MQTT_sync_publish_string(MQTTClient handle, char *topic, char *s, int32_t qos, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if ((handle == NULL) || (topic == NULL) || (s == NULL))
  {
    *error = MQTTCLIENT_NULL_PARAMETER;
    return;
  }

  if ((qos < 0) || (qos > 2))
  {
    *error = MQTTCLIENT_BAD_QOS;
    return;
  }

  MQTTClient_message msg = MQTTClient_message_initializer;
  msg.payload = s;
  msg.payloadlen = strlen(s);
  msg.qos = qos;
  msg.retained = false;

  *error = MQTTClient_publishMessage(handle, topic, &msg, NULL);
}

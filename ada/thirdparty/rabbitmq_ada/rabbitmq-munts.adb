-- Munts Technologies extensions to RabbitMQ Ada (https://github.com/geewiz/rabbitmq_ada)

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

-- This package expects the following environment variables:
--
-- RABBITMQ_SCHEME   (default "amqp")
-- RABBITMQ_USER     (default "guest")
-- RABBITMQ_PASS     (default "guest")
-- RABBITMQ_SERVER   (default "localhost")
-- RABBITMQ_PORT     (default "5672")
-- RABBITMQ_VHOST    (default "/")
-- RABBITMQ_EXCHANGE (default "amq.topic")
-- RABBITMQ_QUEUE    (no default)
-- RABBITMQ_ROUTING  (default "")

WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;
WITH RabbitMQ.Client.URLs;

PACKAGE BODY RabbitMQ.Munts IS

  PACKAGE env RENAMES Ada.Environment_Variables;

  -- Trim leading and trailing whitespace from an Ada string

  FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  -- Assemble Rabbit MQ broker URL from environment variables

  FUNCTION URL RETURN String IS

    Scheme   : CONSTANT String := env.Value("RABBITMQ_SCHEME", "amqp");
    UserName : CONSTANT String := env.Value("RABBITMQ_USER",   RabbitMQ.Client.URLs.Default_User);
    Password : CONSTANT String := env.Value("RABBITMQ_PASS",   RabbitMQ.Client.URLs.Default_Password);
    Server   : CONSTANT String := env.Value("RABBITMQ_SERVER", "localhost");
    Port     : CONSTANT String := env.Value("RABBITMQ_PORT",   Trim(RabbitMQ.Client.URLs.Default_Port'Image));
    VHost    : CONSTANT String := env.Value("RABBITMQ_VHOST",  RabbitMQ.Client.URLs.Default_Vhost);

  BEGIN
    IF VHost = RabbitMQ.Client.URLs.Default_Vhost THEN
      RETURN Scheme & "://" & UserName & ":" & Password & "@" & Server & ":" & Port;
    ELSE
      RETURN Scheme & "://" & UserName & ":" & Password & "@" & Server & ":" & Port & "/" & VHost;
    END IF;
  END URL;

  -- Get exchange name from environment variable

  FUNCTION Exchange RETURN String IS

  BEGIN
    RETURN env.Value("RABBITMQ_EXCHANGE", "amq.topic");
  END Exchange;

  -- Get queue name from environment variable

  FUNCTION Queue RETURN String IS

  BEGIN
    RETURN env.Value("RABBITMQ_QUEUE");
  END Queue;

  -- Get routing key from environment variable

  FUNCTION Routing RETURN String IS

  BEGIN
    RETURN env.Value("RABBITMQ_ROUTING", "");
  END Routing;

END RabbitMQ.Munts;

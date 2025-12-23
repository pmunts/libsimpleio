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
-- RABBITMQ_SCHEME (default "amqp")
-- RABBITMQ_USER   (default "guest")
-- RABBITMQ_PASS   (default "guest")
-- RABBITMQ_SERVER (default "localhost")
-- RABBITMQ_PORT   (default "5672")
-- RABBITMQ_VHOST  (default "/")
-- RABBITMQ_QUEUE  (no default)

PACKAGE RabbitMQ.Munts IS

  -- Assemble Rabbit MQ broker URL from environment variables

  FUNCTION URL RETURN String;

  -- Get queue name from environment variable

  FUNCTION Queue RETURN String;

END RabbitMQ.Munts;

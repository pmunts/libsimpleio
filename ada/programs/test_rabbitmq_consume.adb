-- RabbitMQ Consumer Test

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
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH RabbitMQ.Client;
WITH RabbitMQ.Messages;
WITH RabbitMQ.Munts;

PROCEDURE test_rabbitmq_consume IS

  PROCEDURE Callback(msg : RabbitMQ.Messages.Message) IS

  BEGIN
    Put_Line(RabbitMQ.Messages.Get_Content(msg));
  END Callback;

  broker : RabbitMQ.Client.Connection;

BEGIN
  New_Line;
  Put_Line("RabbitMQ Consumer Test");
  New_Line;

  broker.Connect(RabbitMQ.Munts.URL);
  broker.Subscribe(RabbitMQ.Munts.Queue, Callback'Unrestricted_Access);
END test_rabbitmq_consume;

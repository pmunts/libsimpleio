// RabbitMQ Message Consumer Test

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

using RabbitMQ.Client;
using RabbitMQ.Client.Events;

using static System.Console;
using static System.Environment;
using static System.Text.Encoding;
using static System.Threading.Tasks.Task;
using static System.Threading.Thread;

string GetEnv(string name, string default_value)
{
    var v = GetEnvironmentVariable(name);
    return v is null ? default_value : v;
}

WriteLine("\nRabbitMQ Consumer Test\n");

// Configure RabbitMQ.Client from environment variables

var factory         = new RabbitMQ.Client.ConnectionFactory();
factory.UserName    = GetEnv("RABBITMQ_USER",     "guest");
factory.Password    = GetEnv("RABBITMQ_PASS",     "guest");
factory.HostName    = GetEnv("RABBITMQ_SERVER",   "localhost");
factory.Port        = int.Parse(GetEnv("RABBITMQ_PORT", "5672"));
factory.VirtualHost = GetEnv("RABBITMQ_VHOST",    "/");
var exchange        = GetEnv("RABBITMQ_EXCHANGE", "amq.topic");
var routing         = GetEnv("RABBITMQ_ROUTING",  "");

// Connect to the RabbitMQ server.

var connection = await factory.CreateConnectionAsync();
var channel    = await connection.CreateChannelAsync();

// Create a message consumer

var consumer = new AsyncEventingBasicConsumer(channel);

// Register a received message event handler

consumer.ReceivedAsync += (model, ea) =>
{
    WriteLine(UTF8.GetString(ea.Body.ToArray()));
    return CompletedTask;
};

// Create an ephemeral queue and bind it to the exchange

QueueDeclareOk queue = await channel.QueueDeclareAsync();
await channel.QueueBindAsync(queue.QueueName, exchange, routing);

// Receive messages

await channel.BasicConsumeAsync(queue.QueueName, false, consumer);
CurrentThread.Join();

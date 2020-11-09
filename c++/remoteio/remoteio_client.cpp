// Remote I/O Protocol Client Services

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

// The Remote I/O Protocol specification is available online at:
//
// http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf

#include <cstring>

#include <exception-libsimpleio.h>
#include <remoteio_client.h>

// Constructor
RemoteIO::Client::Device_Class::Device_Class(Interfaces::Message64::Messenger transport)
{
  // Validate parameters

  if (transport == nullptr)
    THROW_MSG("The transport parameter is NULL");

  this->msg = transport;
  this->num = 0;
}

// Execute a Remote I/O operation
void RemoteIO::Client::Device_Class::Transaction(Interfaces::Message64::Message cmd,
  Interfaces::Message64::Message resp)
{
  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("The command parameter is NULL");

  if (resp == nullptr)
    THROW_MSG("The response parameter is NULL");

  // Dispatch transaction

  this->num += 37;

  cmd->payload[1] = this->num;

  this->msg->Transaction(cmd, resp);

  // Handle errors

  if (resp->payload[0] != cmd->payload[0] + 1)
    THROW_MSG("Invalid response message type");

  if (resp->payload[1] != cmd->payload[1])
    THROW_MSG("Invalid response message number");

  if (resp->payload[2] != 0)
    THROW_MSG_ERR("Command failed", resp->payload[2]);
}

// Retrieve the Remote I/O server version string
std::string RemoteIO::Client::Device_Class::Version()
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = RemoteIO::VERSION_REQUEST;
  this->Transaction(&cmd, &resp);

  return std::string((char *) (resp.payload + 3));
}

// Retrieve the Remote I/O server capability string
std::string RemoteIO::Client::Device_Class::Capability()
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = RemoteIO::CAPABILITY_REQUEST;
  this->Transaction(&cmd, &resp);

  return std::string((char *) (resp.payload + 3));
}

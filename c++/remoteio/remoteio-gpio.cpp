// Remote I/O Protocol GPIO pin services

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

#include <exception-raisers.h>
#include <remoteio.h>
#include <remoteio-gpio.h>

using namespace RemoteIO::GPIO;

// GPIO pin constructor

Pin_Class::Pin_Class(RemoteIO::Client::Device dev, unsigned num, unsigned dir,
  bool state)
{
  // Validate parameters

  if (dev == nullptr)
    THROW_MSG("dev parameter is NULL");

  if (num >= RemoteIO::MAX_CHANNELS)
    THROW_MSG("num parameter is out of range");

  if (dir > Interfaces::GPIO::OUTPUT)
    THROW_MSG("direction parameter is out of range");

  // Configure the GPIO pin

  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = GPIO_CONFIGURE_REQUEST;
  cmd.payload[2 + RemoteIO::BI(num)] = RemoteIO::BM(num);

  if (dir == Interfaces::GPIO::OUTPUT)
    cmd.payload[18 + RemoteIO::BI(num)] = RemoteIO::BM(num);

  dev->Transaction(&cmd, &resp);

  this->dev = dev;
  this->num = num;

  // Write initial state for output pin

  if (dir == Interfaces::GPIO::OUTPUT)
    this->write(state);
}

// GPIO pin methods

bool Pin_Class::read(void)
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = GPIO_READ_REQUEST;
  cmd.payload[2 + RemoteIO::BI(this->num)] = RemoteIO::BM(this->num);

  this->dev->Transaction(&cmd, &resp);

  return resp.payload[3 + RemoteIO::BI(this->num)] & RemoteIO::BM(this->num);
}

void Pin_Class::write(const bool state)
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = GPIO_WRITE_REQUEST;
  cmd.payload[2 + RemoteIO::BI(this->num)] = RemoteIO::BM(this->num);

  if (state)
    cmd.payload[18 + RemoteIO::BI(this->num)] = RemoteIO::BM(this->num);

  this->dev->Transaction(&cmd, &resp);
}

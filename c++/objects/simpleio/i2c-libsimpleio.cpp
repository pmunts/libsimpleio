// I2C bus controller services using libsimpleio

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

#include <unistd.h>

#include <exception-raisers.h>
#include <i2c-libsimpleio.h>
#include <libsimpleio/libi2c.h>

using namespace libsimpleio::I2C;

// Constructor

Bus_Class::Bus_Class(const char *name)
{
  // Validate parameters

  if (name == nullptr)
    THROW_MSG("The name parameter is NULL");

  int32_t fd;
  int32_t error;

  I2C_open(name, &fd, &error);
  if (error) THROW_MSG_ERR("I2C_open() failed", error);

  this->fd = fd;
}

// Methods

void Bus_Class::Transaction(unsigned slaveaddr, void *cmd, unsigned cmdlen,
  void *resp, unsigned resplen, unsigned delayus)
{
  // Validate parameters

  if (slaveaddr > 127)
    THROW_MSG("The slaveaddr parameter is out of range");

  if ((cmd == nullptr) && (resp == nullptr))
    THROW_MSG("cmd and resp cannot both be NULL");

  if ((cmd == nullptr) && (cmdlen != 0))
    THROW_MSG("cmd is NULL and cmd is nonzero");

  if ((cmd != nullptr) && (cmdlen == 0))
    THROW_MSG("cmd is not NULL and cmdlen is zero");

  if ((resp == nullptr) && (resplen != 0))
    THROW_MSG("resp is NULL and resplen is nonzero");

  if ((resp != nullptr) && (resplen == 0))
    THROW_MSG("resp is not NULL and resplen is zero");

  if (delayus > 65535)
    THROW_MSG("The delayus parameter is out of range");

  int32_t error;

  if (delayus)
  {
    I2C_transaction(this->fd, slaveaddr, cmd, cmdlen, nullptr, 0, &error);
    if (error) THROW_MSG_ERR("I2C_transaction() failed", error);

    usleep(delayus);

    I2C_transaction(this->fd, slaveaddr, nullptr, 0, resp, resplen, &error);
    if (error) THROW_MSG_ERR("I2C_transaction() failed", error);
  }
  else
  {
    I2C_transaction(this->fd, slaveaddr, cmd, cmdlen, resp, resplen, &error);
    if (error) THROW_MSG_ERR("I2C_transaction() failed", error);
  }
}

// I2C bus controller services using libsimpleio

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

#include <cerrno>

#include <i2c-libsimpleio.h>
#include <libi2c.h>

// Constructor

libsimpleio::I2C::Bus_Class::Bus_Class(const char *name)
{
  // Validate parameters

  if (name == nullptr) throw EINVAL;

  int32_t fd;
  int32_t error;

  I2C_open(name, &fd, &error);
  if (error) throw error;

  this->fd = fd;
}

// Methods

void libsimpleio::I2C::Bus_Class::Transaction(unsigned slaveaddr, void *cmd,
  unsigned cmdlen, void *resp, unsigned resplen)
{
  // Validate parameters

  if (slaveaddr > 127) throw EINVAL;
  if ((cmd == nullptr) && (resp == nullptr)) throw EINVAL;
  if ((cmd == nullptr) && (cmdlen != 0)) throw EINVAL;
  if ((cmd != nullptr) && (cmdlen == 0)) throw EINVAL;
  if ((resp == nullptr) && (resplen != 0)) throw EINVAL;
  if ((resp != nullptr) && (resplen == 0)) throw EINVAL;

  int32_t error;

  I2C_transaction(this->fd, slaveaddr, cmd, cmdlen, resp, resplen, &error);
  if (error) throw(error);
}

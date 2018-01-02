// SPI device services using libsimpleio

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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
#include <cstdlib>
#include <spi-libsimpleio.h>

// Constructor

SPI_libsimpleio::SPI_libsimpleio(const char *name, unsigned mode, unsigned wordsize,
  unsigned speed, int csfd)
{
  // Validate parameters

  if (name == NULL) throw EINVAL;
  if (mode > 3) throw EINVAL;

  int32_t fd;
  int32_t error;

  SPI_open(name, mode, wordsize, speed, &fd, &error);
  if (error) throw error;

  this->fd = fd;
  this->csfd = csfd;
}

// Methods

void SPI_libsimpleio::Transaction(void *cmd, unsigned cmdlen, unsigned delayus,
  void *resp, unsigned resplen)
{
  // Validate parameters

  if ((cmd == NULL) && (resp == NULL)) throw EINVAL;
  if ((cmd == NULL) && (cmdlen != 0)) throw EINVAL;
  if ((cmd != NULL) && (cmdlen == 0)) throw EINVAL;
  if ((resp == NULL) && (resplen != 0)) throw EINVAL;
  if ((resp != NULL) && (resplen == 0)) throw EINVAL;

  int error;

  SPI_transaction(this->fd, this->csfd, cmd, cmdlen, delayus, resp, resplen,
    &error);
  if (error) throw error;
}

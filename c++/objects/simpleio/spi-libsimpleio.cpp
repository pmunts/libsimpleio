// SPI device services using libsimpleio

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

#include <exception-raisers.h>
#include <spi-libsimpleio.h>
#include <libsimpleio/libspi.h>

using namespace libsimpleio::SPI;

// Constructor

Device_Class::Device_Class(const char *name, unsigned mode, unsigned wordsize,
  unsigned speed, libsimpleio::GPIO::Designator cspin)
{
  // Validate parameters

  if (name == nullptr) THROW_MSG("The name parameter is NULL");
  if (mode > 3)        THROW_MSG("The mode parameter is out of range");

  // Open SPI slave device

  int32_t fd;
  int32_t error;

  SPI_open(name, mode, wordsize, speed, &fd, &error);
  if (error) THROW_MSG_ERR("SPI_open() failed", error);

  this->fd = fd;

  // Open chip select GPIO, if necessary

  if ((cspin.chip == AUTOCHIPSELECT.chip) &&
      (cspin.line == AUTOCHIPSELECT.line))
    this->csfd = SPI_CS_AUTO;
  else
  {
    GPIO_line_open(cspin.chip, cspin.line, GPIOHANDLE_REQUEST_OUTPUT, 0, true,
      &this->csfd, &error);
    if (error) THROW_MSG_ERR("GPIO_line_open() failed", error);
  }
}

// Methods

void Device_Class::Transaction(void *cmd, unsigned cmdlen, void *resp,
  unsigned resplen, unsigned delayus)
{
  // Validate parameters

  if ((cmd == nullptr) && (resp == nullptr))
    THROW_MSG("cmd and resp cannot both be NULL");

  if ((cmd == nullptr) && (cmdlen != 0))
    THROW_MSG("cmd is NULL and cmdlen is nonzero");

  if ((cmd != nullptr) && (cmdlen == 0))
    THROW_MSG("cmd is not NULL and cmdlen is zero");

  if ((resp == nullptr) && (resplen != 0))
    THROW_MSG("resp is NULL and resplen is nonzero");

  if ((resp != nullptr) && (resplen == 0))
    THROW_MSG("resp is not NULL and resplen is zero");

  int error;

  SPI_transaction(this->fd, this->csfd, cmd, cmdlen, delayus, resp, resplen,
    &error);
  if (error) THROW_MSG_ERR("SPI_transaction() failed",  error);
}

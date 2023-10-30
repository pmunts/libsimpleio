// LabView LINX GPIO using libsimpleio, with old sysfs API

// Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

#include <libsimpleio/libgpio.h>

#include "gpio-libsimpleio-sysfs.h"

// GPIO pin constructor

GPIO_libsimpleio_sysfs::GPIO_libsimpleio_sysfs(int32_t pin)
{
  this->IsOutput = false;
  this->pin = pin;
  this->fd = -1;
}

// GPIO pin configuration method

void GPIO_libsimpleio_sysfs::configure(int32_t direction, int32_t *error)
{
  GPIO_configure(this->pin, direction, 0, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, error);
  if (*error) return;

  this->IsOutput = direction;

  if (this->fd == -1)
  {
    int fd;

    GPIO_open(this->pin, &fd, error);
    if (*error) return;

    this->fd = fd;
  }
}

// GPIO pin read method

void GPIO_libsimpleio_sysfs::read(int32_t *state, int32_t *error)
{
  if (this->fd == -1)
  {
    int fd;

    GPIO_configure(this->pin, GPIO_DIRECTION_INPUT, 0, GPIO_EDGE_NONE,
      GPIO_POLARITY_ACTIVEHIGH, error);
    if (*error) return;

    GPIO_open(this->pin, &fd, error);
    if (*error) return;

    this->IsOutput = false;
    this->fd = fd;
  }

  GPIO_read(this->fd, state, error);
}

// GPIO pin write method

void GPIO_libsimpleio_sysfs::write(int32_t state, int32_t *error)
{
  if (this->fd == -1)
  {
    int fd;

    GPIO_configure(this->pin, GPIO_DIRECTION_OUTPUT, state, GPIO_EDGE_NONE,
      GPIO_POLARITY_ACTIVEHIGH, error);
    if (*error) return;

    GPIO_open(this->pin, &fd, error);
    if (*error) return;

    this->IsOutput = true;
    this->fd = fd;
  }

  GPIO_write(this->fd, state, error);
}

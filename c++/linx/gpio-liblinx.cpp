// LabView LINX GPIO using libsimpleio

// Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

#include <libgpio.h>

#include "gpio-liblinx.h"

// GPIO pin constructor

GPIO_liblinx::GPIO_liblinx(int32_t number, int32_t *error)
{
  int fd;

  this->IsOutput = false;
  this->fd = -1;

  GPIO_configure(number, GPIO_DIRECTION_INPUT, 0, GPIO_EDGE_NONE, GPIO_ACTIVEHIGH, error);
  if (*error) return;

  GPIO_open(number, &fd, error);
  if (*error) return;

  this->IsOutput = false;
  this->fd = fd;
}

// GPIO pin constructor, with data direction parameter

GPIO_liblinx::GPIO_liblinx(int32_t number, int32_t dir, int32_t *error)
{
  int fd;

  this->IsOutput = false;
  this->fd = -1;

  GPIO_configure(number, dir, 0, GPIO_EDGE_NONE, GPIO_ACTIVEHIGH, error);
  if (*error) return;

  GPIO_open(number, &fd, error);
  if (*error) return;

  this->IsOutput = dir;
  this->fd = fd;
}

// GPIO pin constructor, with data direction and initial state parameters

GPIO_liblinx::GPIO_liblinx(int32_t number, int32_t dir, int32_t state, int32_t *error)
{
  int fd;

  this->IsOutput = false;
  this->fd = -1;

  GPIO_configure(number, dir, state, GPIO_EDGE_NONE, GPIO_ACTIVEHIGH, error);
  if (*error) return;

  GPIO_open(number, &fd, error);
  if (*error) return;

  this->IsOutput = dir;
  this->fd = fd;
}

// GPIO pin configuration method

void GPIO_liblinx::configure(int32_t dir, int32_t *error)
{
  GPIO_configure(this->number, dir, 0, GPIO_EDGE_NONE, GPIO_ACTIVEHIGH, error);
  if (*error) return;

  this->IsOutput = dir;
}

// GPIO pin read method

void GPIO_liblinx::read(int32_t *state, int32_t *error)
{
  GPIO_read(this->fd, state, error);
}

// GPIO pin write method

void GPIO_liblinx::write(int32_t state, int32_t *error)
{
  GPIO_write(this->fd, state, error);
}

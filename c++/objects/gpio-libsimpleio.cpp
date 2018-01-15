// GPIO pin services using libsimpleio

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
#include <gpio-libsimpleio.h>

// Constructor

GPIO_libsimpleio::GPIO_libsimpleio(unsigned pin, unsigned direction,
    bool state, unsigned edge, unsigned polarity)
{
  // Validate parameters

  if (direction > GPIO_DIRECTION_OUTPUT) throw EINVAL;
  if (edge > GPIO_EDGE_BOTH) throw EINVAL;
  if (polarity > GPIO_POLARITY_ACTIVEHIGH) throw EINVAL;

  int32_t error;
  int32_t fd;

  GPIO_configure(pin, direction, state, edge, polarity, &error);
  if (error) throw error;

  GPIO_open(pin, &fd, &error);
  if (error) throw error;

  this->fd = fd;
}

// GPIO Methods

bool GPIO_libsimpleio::read(void)
{
  int32_t state;
  int32_t error;

  GPIO_read(this->fd, &state, &error);
  if (error) throw error;

  return state;
}

void GPIO_libsimpleio::write(const bool state)
{
  int32_t error;

  GPIO_write(this->fd, state, &error);
  if (error) throw error;
}

// GPIO operators

GPIO_libsimpleio::operator bool(void)
{
  return this->read();
}

void GPIO_libsimpleio::operator =(const bool state)
{
  this->write(state);
}

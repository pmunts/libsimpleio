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

#include <exception-libsimpleio.h>
#include <gpio-libsimpleio.h>
#include <libsimpleio/libgpio.h>

static const int32_t DirectionFlags[] =
{
  GPIOHANDLE_REQUEST_INPUT,
  GPIOHANDLE_REQUEST_OUTPUT,
};

static const int32_t DriverFlags[] =
{
  GPIOHANDLE_REQUEST_PUSH_PULL,
  GPIOHANDLE_REQUEST_OPEN_DRAIN,
  GPIOHANDLE_REQUEST_OPEN_SOURCE,
};

static const int32_t PolarityFlags[] =
{
  GPIOHANDLE_REQUEST_ACTIVE_LOW,
  GPIOHANDLE_REQUEST_ACTIVE_HIGH,
};

static const int32_t EventFlags[] =
{
  GPIOEVENT_REQUEST_NONE,
  GPIOEVENT_REQUEST_RISING_EDGE,
  GPIOEVENT_REQUEST_FALLING_EDGE,
  GPIOEVENT_REQUEST_BOTH_EDGES,
};

// GPIO Constructors

libsimpleio::GPIO::Pin_Class::Pin_Class(libsimpleio::GPIO::Designator pin,
  unsigned direction, bool state, unsigned driver, unsigned polarity,
  unsigned edge)
{
  int32_t flags = 0;
  int32_t events = 0;
  int32_t error;
  int32_t fd;

  // Validate parameters

  if (pin.chip == libsimpleio::GPIO::Unavailable.chip)
    THROW_MSG("The GPIO pin is unavailable");

  if (pin.line == libsimpleio::GPIO::Unavailable.line)
    THROW_MSG("The GPIO pin is unavailable");

  if (direction > GPIO_DIRECTION_OUTPUT)
    THROW_MSG("The direction parameter is out of range");

  if (driver > GPIO_DRIVER_OPEN_SOURCE)
    THROW_MSG("The driver parameter is out of range");

  if (polarity > GPIO_POLARITY_ACTIVEHIGH)
    THROW_MSG("The polarity parameter is out of range");

  if (edge > GPIO_EDGE_BOTH)
    THROW_MSG("The edge parameter is out of range");

  // Compute the request flags

  flags = DirectionFlags[direction]|DriverFlags[driver]|PolarityFlags[polarity];
  events = EventFlags[edge];

  // Open the GPIO line

  GPIO_line_open(pin.chip, pin.line, flags, events, state, &fd, &error);
  if (error) THROW_MSG_ERR("GPIO_line_open() failed", error);

  this->fd = fd;
  this->interrupt = (edge != GPIO_EDGE_NONE);
}

libsimpleio::GPIO::Pin_Class::Pin_Class(unsigned chip, unsigned line,
  unsigned direction, bool state, unsigned driver, unsigned polarity,
  unsigned edge)
{
  int32_t flags = 0;
  int32_t events = 0;
  int32_t error;
  int32_t fd;

  // Validate parameters

  if (chip == libsimpleio::GPIO::Unavailable.chip)
    THROW_MSG("The GPIO pin is unavailable");

  if (line == libsimpleio::GPIO::Unavailable.line)
    THROW_MSG("The GPIO pin is unavailable");

  if (direction > GPIO_DIRECTION_OUTPUT)
    THROW_MSG("The direction parameter is out of range");

  if (driver > GPIO_DRIVER_OPEN_SOURCE)
    THROW_MSG("The driver parameter is out of range");

  if (polarity > GPIO_POLARITY_ACTIVEHIGH)
    THROW_MSG("The polarity parameter is out of range");

  if (edge > GPIO_EDGE_BOTH)
    THROW_MSG("The edge parameter is out of range");

  // Compute the request flags

  flags = DirectionFlags[direction]|DriverFlags[driver]|PolarityFlags[polarity];
  events = EventFlags[edge];

  // Open the GPIO line

  GPIO_line_open(chip, line, flags, events, state, &fd, &error);
  if (error) THROW_MSG_ERR("GPIO_line_open() failed", error);

  this->fd = fd;
  this->interrupt = (edge != GPIO_EDGE_NONE);
}

// GPIO Methods

bool libsimpleio::GPIO::Pin_Class::read(void)
{
  int32_t state;
  int32_t error;

  if (this->interrupt)
  {
    GPIO_line_event(this->fd, &state, &error);
    if (error) THROW_MSG_ERR("GPIO_line_event() failed", error);
  }
  else
  {
    GPIO_line_read(this->fd, &state, &error);
    if (error) THROW_MSG_ERR("GPIO_line_read() failed", error);
  }


  return state;
}

void libsimpleio::GPIO::Pin_Class::write(const bool state)
{
  int32_t error;

  if (this->interrupt) THROW_MSG("Cannot write to interrupt pin");

  GPIO_line_write(this->fd, state, &error);
  if (error) THROW_MSG_ERR("GPIO_line_write() failed", error);
}

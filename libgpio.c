/* GPIO services for Linux */

// $Id$

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

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <errmsg.inc>
#include <libgpio.h>

// Device nodes

#define GPIODIR		"/sys/class/gpio"
#define EXPORT		GPIODIR "/export"
#define UNEXPORT	GPIODIR "/unexport"
#define PINDIR		GPIODIR "/gpio%d"
#define DIRECTION	PINDIR  "/direction"
#define VALUE		PINDIR  "/value"
#define EDGE		PINDIR  "/edge"
#define ACTIVELOW	PINDIR  "/active_low"

// Open and configure a GPIO pin

void GPIO_configure(int pin, int direction, int state, int edge, int polarity, int *error)
{
  char buf[256];
  int fd;
  ssize_t status;

  // Validate parameters

  if ((direction < GPIO_DIRECTION_INPUT) || (direction > GPIO_DIRECTION_OUTPUT))
  {
    *error = EINVAL;
    ERRORMSG("Invalid direction argument", *error, __LINE__ - 3);
    return;
  }

  if ((state < false) || (state > true))
  {
    *error = EINVAL;
    ERRORMSG("Invalid state argument", *error, __LINE__ - 3);
    return;
  }

  if ((direction == GPIO_DIRECTION_INPUT) && state)
  {
    *error = EINVAL;
    ERRORMSG("Invalid state argument", *error, __LINE__ - 3);
    return;
  }

  if ((edge < GPIO_EDGE_NONE) || (edge > GPIO_EDGE_BOTH))
  {
    *error = EINVAL;
    ERRORMSG("Invalid edge argument", *error, __LINE__ - 3);
    return;
  }

  if ((direction == GPIO_DIRECTION_OUTPUT) && (edge != GPIO_EDGE_NONE))
  {
    *error = EINVAL;
    ERRORMSG("Invalid edge argument", *error, __LINE__ - 3);
    return;
  }

  if ((polarity < GPIO_ACTIVELOW) || (polarity > GPIO_ACTIVEHIGH))
  {
    *error = EINVAL;
    ERRORMSG("Invalid polarity argument", *error, __LINE__ - 3);
    return;
  }

  // Export the GPIO pin if necessary

  if (snprintf(buf, sizeof(buf), PINDIR, pin) < 0)
  {
    *error = errno;
    ERRORMSG("snprintf() failed", *error, __LINE__ - 3);
    return;
  }

  if (access(buf, F_OK))
  {
    if (snprintf(buf, sizeof(buf), "%d\n", pin) < 0)
    {
      *error = errno;
      ERRORMSG("snprintf() failed", *error, __LINE__ - 3);
      return;
    }

    fd = open(EXPORT, O_WRONLY);
    if (fd < 0)
    {
      *error = errno;
      ERRORMSG("open() for " EXPORT " failed", *error, __LINE__ - 4);
      return;
    }

    if (write(fd, buf, strlen(buf)) < 0)
    {
      *error = errno;
      ERRORMSG("write() failed", *error, __LINE__ - 3);
      close(fd);
      return;
    }

    if (close(fd) < 0)
    {
      *error = errno;
      ERRORMSG("close() failed", *error, __LINE__ - 3);
      return;
    }
  }

  // Set polarity

  if (snprintf(buf, sizeof(buf), ACTIVELOW, pin) < 0)
  {
    *error = errno;
    ERRORMSG("snprintf() failed", *error, __LINE__ - 3);
    return;
  }

  fd = open(buf, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  if (write(fd, polarity ? "0\n" : "1\n", 2) < 2)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 3);
    close(fd);
    return;
  }

  if (close(fd) < 0)
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  // Set direction and possibly initial output state

  if (snprintf(buf, sizeof(buf), DIRECTION, pin) < 0)
  {
    *error = errno;
    ERRORMSG("snprintf() failed", *error, __LINE__ - 3);
    return;
  }

  fd = open(buf, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  if (direction == GPIO_DIRECTION_INPUT)
    status = write(fd, "in\n", 3);
  else if (state)
    status = write(fd, "high\n", 5);
  else
    status = write(fd, "low\n", 4);

  if (status < 0)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 3);
    close(fd);
    return;
  }

  if (close(fd) < 0)
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  // Set active edge for input pin

  if (direction == GPIO_DIRECTION_INPUT)
  {
    if (snprintf(buf, sizeof(buf), EDGE, pin) < 0)
    {
      *error = errno;
      ERRORMSG("snprintf() failed", *error, __LINE__ - 3);
      return;
    }

    fd = open(buf, O_WRONLY);
    if (fd < 0)
    {
      *error = errno;
      ERRORMSG("open() failed", *error, __LINE__ - 4);
      return;
    }

    switch (edge)
    {
      case GPIO_EDGE_NONE :
        status = write(fd, "none\n", 5);
        break;

      case GPIO_EDGE_RISING :
        status = write(fd, "rising\n", 7);
        break;

      case GPIO_EDGE_FALLING :
        status = write(fd, "falling\n", 8);
        break;

      case GPIO_EDGE_BOTH :
        status = write(fd, "both\n", 5);
        break;
    }

    if (status < 0)
    {
      *error = errno;
      ERRORMSG("write() failed", *error, __LINE__ - 3);
      close(fd);
      return;
    }

    if (close(fd) < 0)
    {
      *error = errno;
      ERRORMSG("close() failed", *error, __LINE__ - 3);
      return;
    }
  }

  *error = 0;
}

// Open GPIO pin device

void GPIO_open(char *name, int *fd, int *error)
{
  *fd = open(name, O_RDWR);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

// Close GPIO pin device

void GPIO_close(int fd, int *error)
{
  if (close(fd))
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Read state from GPIO pin device

void GPIO_read(int fd, int *state, int *error)
{
  char buf[16];

  if (read(fd, buf, sizeof(buf)) < 2)
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 3);
    return;
  }

  switch(buf[0])
  {
    case '0' :
      *state = 0;
      break;

    case '1' :
      *state = 1;
      break;

    default :
      *error = EINVAL;
      return;
  }

  *error = 0;
}

// Write state to GPIO pin device

void GPIO_write(int fd, int state, int *error)
{
  if (write(fd, state ? "1\n" : "0\n", 2) < 2)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

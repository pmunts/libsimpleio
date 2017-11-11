/* GPIO services for Linux */

// Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libgpio.h"

// Device nodes

#define GPIODIR		"/sys/class/gpio"
#define EXPORT		GPIODIR "/export"
#define UNEXPORT	GPIODIR "/unexport"
#define PINDIR		GPIODIR "/gpio%d"
#define ACTIVELOW	PINDIR  "/active_low"
#define DIRECTION	PINDIR  "/direction"
#define EDGE		PINDIR  "/edge"
#define VALUE		PINDIR  "/value"

static uint64_t milliseconds(void)
{
  struct timespec t;

  clock_gettime(CLOCK_REALTIME, &t);
  return t.tv_sec*1000LL + (1LL*t.tv_nsec)/1000000LL;
}

// Configure GPIO pin device

void GPIO_configure(int32_t pin, int32_t direction, int32_t state, int32_t edge, int32_t polarity, int32_t *error)
{
  assert(error != NULL);

  char buf[MAXPATHLEN];
  int fd;
  uint64_t start;
  int status;

  // Validate parameters

  if (pin < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid pin number argument", *error, __LINE__ - 3);
    return;
  }

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

  if ((polarity < GPIO_POLARITY_ACTIVELOW) || (polarity > GPIO_POLARITY_ACTIVEHIGH))
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

    if (close(fd))
    {
      *error = errno;
      ERRORMSG("close() failed", *error, __LINE__ - 3);
      return;
    }

    // Wait for the GPIO pin directory to be created

    snprintf(buf, sizeof(buf), VALUE, pin);

    start = milliseconds();

    while (access(buf, W_OK))
    {
      if (milliseconds() - start > 1000)
      {
        *error = EIO;
        ERRORMSG("Timed out waiting for GPIO pin export", *error,
          __LINE__ - 3);
        return;
      }
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

  if (close(fd))
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

  if (close(fd))
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

    if (close(fd))
    {
      *error = errno;
      ERRORMSG("close() failed", *error, __LINE__ - 3);
      return;
    }
  }

#ifdef MAKE_GPIO_LINK
  // Symlink /dev/gpioN to /sys/class/gpio/gpioN/value -- requires superuser

  char linkname[MAXPATHLEN];
  char linktarget[MAXPATHLEN];

  snprintf(linktarget, sizeof(linktarget), "/sys/class/gpio/gpio%d/value", pin);
  snprintf(linkname, sizeof(linkname), "/dev/gpio%d", pin);

  if (access(linkname, F_OK))
  {
    if (symlink(linktarget, linkname))
    {
      *error = errno;
      ERRORMSG("symlink() failed", *error, __LINE__ - 3);
      return;
    }
  }
#endif

#ifdef WAIT_GPIO_LINK
  // Wait for /dev/gpioN to be created by udev or mdev

  snprintf(buf, sizeof(buf), "/dev/gpio%d", pin);

  start = milliseconds();

  while (access(buf, F_OK))
  {
    if (milliseconds() - start > 1000)
    {
      *error = EIO;
      ERRORMSG("Timed out waiting for GPIO symlink", *error, __LINE__ - 3);
      return;
    }
  }
#endif

  *error = 0;
}

// Open GPIO pin device

void GPIO_open(int32_t pin, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  char devname[MAXPATHLEN];
  char buf[16];

  // Validate parameters

  if (pin < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid pin number argument", *error, __LINE__ - 3);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  memset(devname, 0, sizeof(devname));
  snprintf(devname, sizeof(devname), "/dev/gpio%d", pin);

  *fd = open(devname, O_RDWR);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  // Priming read, needed to make edge detection work properly

  if (lseek(*fd, 0, SEEK_SET) < 0)
  {
    *error = errno;
    ERRORMSG("lseek() failed", *error, __LINE__ - 3);
    return;
  }

  if (read(*fd, buf, sizeof(buf)) < 0)
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Read state from GPIO pin device

void GPIO_read(int32_t fd, int32_t *state, int32_t *error)
{
  assert(error != NULL);

  char buf[4];

  // Validate parameters

  if (fd < 3)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (state == NULL)
  {
    *error = EINVAL;
    ERRORMSG("state argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (lseek(fd, 0, SEEK_SET) < 0)
  {
    *error = errno;
    ERRORMSG("lseek() failed", *error, __LINE__ - 3);
    return;
  }

  memset(buf, 0, sizeof(buf));

  if (read(fd, buf, sizeof(buf)) < 0)
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

void GPIO_write(int32_t fd, int32_t state, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 3)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((state < 0) || (state > 1))
  {
    *error = EINVAL;
    ERRORMSG("state argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (write(fd, state ? "1\n" : "0\n", 2) < 2)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

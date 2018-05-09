/* GPIO services for Linux */

// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
#include <sys/ioctl.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libgpio.h"

void GPIO_chip_info(int32_t chip, char *name, int32_t namesize,
  char *label, int32_t labelsize, int32_t *lines, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (name == NULL)
  {
    *error = EINVAL;
    ERRORMSG("name argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (namesize < 32)
  {
    *error = EINVAL;
    ERRORMSG("namesize argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (label == NULL)
  {
    *error = EINVAL;
    ERRORMSG("label argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (labelsize < 32)
  {
    *error = EINVAL;
    ERRORMSG("labelsize argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (lines == NULL)
  {
    *error = EINVAL;
    ERRORMSG("lines argument is NULL", *error, __LINE__ - 3);
    return;
  }

  // Open the GPIO controller device

  char nodename[32];
  memset(nodename, 0, sizeof(nodename));
  snprintf(nodename, sizeof(nodename), "/dev/gpiochip%d", chip);

  int chipfd = open(nodename, O_RDWR);

  if (chipfd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 3);
    return;
  }

  // Query the GPIO controller device info

  struct gpiochip_info info;

  if (ioctl(chipfd, GPIO_GET_CHIPINFO_IOCTL, &info) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
    close(chipfd);
    return;
  }

  close(chipfd);

  memset(name, 0, namesize);
  strncpy(name, info.name, namesize - 1);

  memset(label, 0, labelsize);
  strncpy(label, info.label, labelsize - 1);

  *lines = info.lines;
  *error = 0;
}

void GPIO_line_info(int32_t chip, int32_t line, int32_t *flags, char *name,
  int32_t namesize, char *label, int32_t labelsize, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (line < 0)
  {
    *error = EINVAL;
    ERRORMSG("line argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (flags == NULL)
  {
    *error = EINVAL;
    ERRORMSG("flags argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (name == NULL)
  {
    *error = EINVAL;
    ERRORMSG("name argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (namesize < 32)
  {
    *error = EINVAL;
    ERRORMSG("namesize argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (label == NULL)
  {
    *error = EINVAL;
    ERRORMSG("label argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (labelsize < 32)
  {
    *error = EINVAL;
    ERRORMSG("labelsize argument is invalid", *error, __LINE__ - 3);
    return;
  }

  // Open the GPIO controller device

  char nodename[32];
  memset(nodename, 0, sizeof(nodename));
  snprintf(nodename, sizeof(nodename), "/dev/gpiochip%d", chip);

  int chipfd = open(nodename, O_RDWR);

  if (chipfd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 3);
    return;
  }

  // Query the GPIO line info

  struct gpioline_info info = { line };

  if (ioctl(chipfd, GPIO_GET_LINEINFO_IOCTL, &info) < 0 )
  {
    *error = errno;
    ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
    close(chipfd);
    return;
  }

  memset(name, 0, namesize);
  memset(label, 0, labelsize);

  *flags = info.flags;
  strncpy(name, info.name, namesize - 1);
  strncpy(label, info.consumer, labelsize - 1);

  *error = 0;
}

// Exhaustive list of valid handle request flag combinations

static const bool ValidFlags[32] =
{
  false,  // 0x00
  true,   // 0x01 -- INPUT
  true,   // 0x02 -- OUTPUT
  false,  // 0x03 -- INPUT|OUTPUT
  false,  // 0x04 -- ACTIVE_LOW
  true,   // 0x05 -- INPUT|ACTIVE_LOW
  true,   // 0x06 -- OUTPUT|ACTIVE_LOW
  false,  // 0x07 -- INPUT|OUTPUT|ACTIVELOW
  false,  // 0x08 -- OPEN_DRAIN
  false,  // 0x09 -- INPUT|OPEN_DRAIN
  true,   // 0x0A -- OUTPUT|OPEN_DRAIN
  false,  // 0x0B -- INPUT|OUTPUT|OPEN_DRAIN
  false,  // 0x0C -- ACTIVE_LOW|OPEN_DRAIN
  false,  // 0x0D -- INPUT|ACTIVE_LOW|OPEN_DRAIN
  true,   // 0x0E -- OUTPUT|ACTIVE_LOW|OPEN_DRAIN
  false,  // 0x0F -- INPUT|OUTPUT|ACTIVE_LOW|OPEN_DRAIN
  false,  // 0x10 -- OPEN_SOURCE
  false,  // 0x11 -- INPUT|OPEN_SOURCE
  true,   // 0x12 -- OUTPUT|OPEN_SOURCE
  false,  // 0x13 -- INPUT|OUTPUT|OPEN_SOURCE
  false,  // 0x14 -- ACTIVE_LOW|OPEN_SOURCE
  false,  // 0x15 -- INPUT|ACTIVE_LOW|OPEN_SOURCE
  true,   // 0x16 -- OUTPUT_ACTIVE_LOW|OPEN_SOURCE
  false,  // 0x17 -- INPUT|OUTPUT|ACTIVE_LOW|OPEN_SOURCE
  false,  // 0x18 -- OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x19 -- INPUT|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1A -- OUTPUT|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1B -- INPUT|OUTPUT|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1C -- ACTIVE_LOW|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1D -- INPUT|ACTIVE_LOW|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1E -- OUTPUT|ACTIVE_LOW|OPEN_DRAIN|OPEN_SOURCE
  false,  // 0x1F -- INPUT|OUTPUT|ACTIVE_LOW|OPEN_DRAIN|OPEN_SOURCE
};

void GPIO_line_open(int32_t chip, int32_t line, int32_t flags, int32_t events,
  int32_t state, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (line < 0)
  {
    *error = EINVAL;
    ERRORMSG("line argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (flags & 0xFFFFFFE0)
  {
    *error = EINVAL;
    ERRORMSG("flags argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (!ValidFlags[flags])
  {
    *error = EINVAL;
    ERRORMSG("flags argument is inconsistent", *error, __LINE__ - 3);
    return;
  }

  if (events & 0xFFFFFFFC)
  {
    *error = EINVAL;
    ERRORMSG("events argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((flags & GPIOHANDLE_REQUEST_OUTPUT) && (events != 0))
  {
    *error = EINVAL;
    ERRORMSG("flags and events are inconsistent", *error, __LINE__ - 3);
    return;
  }

  if ((state < 0) || (state > 1))
  {
    *error = EINVAL;
    ERRORMSG("state argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  // Open GPIO controller device

  char nodename[32];
  memset(nodename, 0, sizeof(nodename));
  snprintf(nodename, sizeof(nodename), "/dev/gpiochip%d", chip);

  int chipfd = open(nodename, O_RDWR);

  if (chipfd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 3);
    return;
  }

  if (events)
  {
    // Request GPIO event handle

    struct gpioevent_request req;
    memset(&req,  0, sizeof(req));
    req.lineoffset = line;
    req.handleflags = flags;
    req.eventflags = events;

    if (ioctl(chipfd, GPIO_GET_LINEEVENT_IOCTL, &req) < 0)
    {
      *error = errno;
      ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
      close(chipfd);
      return;
    }

    *fd = req.fd;
  }
  else
  {
    // Request GPIO line handle

    struct gpiohandle_request req;
    memset(&req, 0, sizeof(req));
    req.lineoffsets[0] = line;
    req.flags = flags;
    req.default_values[0] = state;
    req.lines = 1;

    if (ioctl(chipfd, GPIO_GET_LINEHANDLE_IOCTL, &req) < 0)
    {
      *error = errno;
      ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
      close(chipfd);
      return;
    }

    *fd = req.fd;
  }

  close(chipfd);

  *error = 0;
}

void GPIO_line_read(int32_t fd, int32_t *state, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
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

  struct gpiohandle_data data = {{ 0 }};

  if (ioctl(fd, GPIOHANDLE_GET_LINE_VALUES_IOCTL, &data) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
    return;
  }

  *state = data.values[0];
  *error = 0;
}

void GPIO_line_write(int32_t fd, int32_t state, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
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

  struct gpiohandle_data data = {{ state }};

  if (ioctl(fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

void GPIO_line_event(int32_t fd, int32_t *state, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (state == NULL)
  {
    *error = EINVAL;
    ERRORMSG("event argument is NULL", *error, __LINE__ - 3);
    return;
  }

  // Read event data structure

  struct gpioevent_data data;

  if (read(fd, &data, sizeof(data)) != sizeof(data))
  {
    *error = EIO;
    ERRORMSG("read() failed", *error, __LINE__ - 3);
    return;
  }

  // Decode result

  switch (data.id)
  {
    case GPIOEVENT_EVENT_RISING_EDGE:
      *state = true;
      *error = 0;
      break;

    case GPIOEVENT_EVENT_FALLING_EDGE:
      *state = false;
      *error = 0;
      break;

    default:
      *error = EIO;
      break;
  }
}

//******************* Old GPIO sysfs API (now deprecated): ********************

// Device nodes

#define GPIODIR		"/sys/class/gpio"
#define EXPORT		GPIODIR "/export"
#define UNEXPORT	GPIODIR "/unexport"
#define PINDIR		GPIODIR "/gpio%d"
#define ACTIVELOW	PINDIR  "/active_low"
#define DIRECTION	PINDIR  "/direction"
#define EDGE		PINDIR  "/edge"
#define VALUE		PINDIR  "/value"
#define SYMLINK		"/dev/gpio%d"

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
    ERRORMSG("pin number argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((direction < GPIO_DIRECTION_INPUT) || (direction > GPIO_DIRECTION_OUTPUT))
  {
    *error = EINVAL;
    ERRORMSG("direction argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((state < false) || (state > true))
  {
    *error = EINVAL;
    ERRORMSG("state argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((direction == GPIO_DIRECTION_INPUT) && state)
  {
    *error = EINVAL;
    ERRORMSG("state argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((edge < GPIO_EDGE_NONE) || (edge > GPIO_EDGE_BOTH))
  {
    *error = EINVAL;
    ERRORMSG("edge argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((direction == GPIO_DIRECTION_OUTPUT) && (edge != GPIO_EDGE_NONE))
  {
    *error = EINVAL;
    ERRORMSG("edge argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((polarity < GPIO_POLARITY_ACTIVELOW) || (polarity > GPIO_POLARITY_ACTIVEHIGH))
  {
    *error = EINVAL;
    ERRORMSG("polarity argument is invalid", *error, __LINE__ - 3);
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
      ERRORMSG("open() failed", *error, __LINE__ - 4);
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

    // Wait for the GPIO pin device to be created

#ifdef WAIT_DEV_LINK
    snprintf(buf, sizeof(buf), SYMLINK, pin);
#else
    snprintf(buf, sizeof(buf), VALUE, pin);
#endif

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

      usleep(100000);
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

#ifdef MAKE_DEV_LINK
  // Symlink /dev/gpioN to /sys/class/gpio/gpioN/value -- requires superuser

  char linkname[MAXPATHLEN];
  char linktarget[MAXPATHLEN];

  snprintf(linktarget, sizeof(linktarget), VALUE, pin);
  snprintf(linkname, sizeof(linkname), SYMLINK, pin);

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

  *error = 0;
}

// Open GPIO pin device

void GPIO_open(int32_t pin, int32_t *fd, int32_t *error)
{
  char filename[MAXPATHLEN];
  char buf[16];

  // Validate parameters

  assert(error != NULL);

  if (pin < 0)
  {
    *error = EINVAL;
    ERRORMSG("pin number argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  memset(filename, 0, sizeof(filename));

#if defined(MAKE_DEV_LINK) || defined(WAIT_DEV_LINK)
  snprintf(filename, sizeof(filename), SYMLINK, pin);
#else
  snprintf(filename, sizeof(filename), VALUE, pin);
#endif

  *fd = open(filename, O_RDWR);
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

  if (fd < 0)
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

  if (fd < 0)
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


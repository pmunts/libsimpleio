/* Raw HID device wrapper services for Linux */

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
#include <string.h>
#include <unistd.h>
#include <linux/types.h>
#include <linux/input.h>
#include <linux/hidraw.h>
#include <sys/ioctl.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libhidraw.h"

// Open HID raw device

void HIDRAW_open(const char *name, int32_t *fd, int32_t *error)
{
  *fd = open(name, O_RDWR);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

// Close the HID raw device

void HIDRAW_close(int32_t fd, int32_t *error)
{
  if (close(fd))
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Get device information string

void HIDRAW_get_name(int32_t fd, char *name, int32_t size, int32_t *error)
{
  memset(name, 0, size);

  if (ioctl(fd, HIDIOCGRAWNAME(size), name) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for HIDIOCGRAWNAME failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Get device bus type, vendor and product information

void HIDRAW_get_info(int32_t fd, int32_t *bustype, int32_t *vendor, int32_t *product, int32_t *error)
{
  struct hidraw_devinfo devinfo;

  if (ioctl(fd, HIDIOCGRAWINFO, &devinfo) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for HIDIOCGRAWINFO failed", *error, __LINE__ - 3);
    return;
  }

  *bustype = devinfo.bustype;
  *vendor = devinfo.vendor;
  *product = devinfo.product;
  *error = 0;
}

// Send a message to the HID raw device

void HIDRAW_send(int32_t fd, void *buf, int32_t size, int32_t *error)
{
  int32_t len = write(fd, buf, size);
  if (len < 0)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

// Receive a message from the HID raw device

void HIDRAW_receive(int32_t fd, void *buf, int32_t *size, int32_t *error)
{
  int32_t len = read(fd, buf, *size);
  if (len < 0)
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 4);
    return;
  }

  *size = len;
  *error = 0;
}

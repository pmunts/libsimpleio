/* Raw HID device wrapper services for Linux */

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

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <linux/types.h>
#include <linux/input.h>
#include <linux/hidraw.h>
#include <sys/ioctl.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libhidraw.h"

// Find the raw HID device node matching the specified vendor and product ID's

void HIDRAW_find(int32_t VID, int32_t PID, char *name,
  int32_t size, int32_t *error)
{
  int i, fd;
  int32_t b, v, p, e;

  for (i = 0; i < 100; i++)
  {
    snprintf(name, size, "/dev/hidraw%d", i);

    // Open the candidate device node

    fd = open(name, O_RDWR);
    if (fd < 0) continue;

    // Try to get HID device info for the candidate device

    HIDRAW_get_info(fd, &b, &v, &p, &e);

    // Close the candidate device node

    close(fd);

    if (e) continue;

    // Look for a matching device

    if ((VID == v) && (PID == p))
    {
      *error = 0;
      return;
    }
  }

  *error = ENODEV;
  ERRORMSG("Cannot find matching raw HID device", *error, __LINE__ - 1);
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

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

#include <assert.h>
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

// Open the first raw HID device with matching vendor and product ID's

void HIDRAW_open_id(int32_t VID, int32_t PID, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  int i;
  char name[MAXPATHLEN];
  int32_t b, v, p, e;

  // Search raw HID devices, looking for matching VID and PID

  for (i = 0; i < 100; i++)
  {
    snprintf(name, sizeof(name), "/dev/hidraw%d", i);

    // Open the candidate device node

    *fd = open(name, O_RDWR);
    if (*fd < 0) continue;

    // Try to get HID device info for the candidate device

    HIDRAW_get_info(*fd, &b, &v, &p, &e);
    if (e) continue;

    // Look for a matching device

    if ((VID == v) && (PID == p))
    {
      *error = 0;
      return;
    }

    // Close the candidate device node

    close(*fd);
  }

  *fd = 0;
  *error = ENODEV;
  ERRORMSG("Cannot find matching raw HID device", *error, __LINE__ - 1);
}

// Get device information string

void HIDRAW_get_name(int32_t fd, char *name, int32_t size, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 3)
  {
    *error = EINVAL;
    ERRORMSG("Invalid fd argument", *error, __LINE__ - 3);
    return;
  }

  if (name == NULL)
  {
    *error = EINVAL;
    ERRORMSG("name argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (size < 16)
  {
    *error = EINVAL;
    ERRORMSG("size argument is too small", *error, __LINE__ - 3);
    return;
  }

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
  assert(error != NULL);

  // Validate parameters

  if (fd < 3)
  {
    *error = EINVAL;
    ERRORMSG("Invalid fd argument", *error, __LINE__ - 3);
    return;
  }

  if (bustype == NULL)
  {
    *error = EINVAL;
    ERRORMSG("bustype argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (vendor == NULL)
  {
    *error = EINVAL;
    ERRORMSG("vendor argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (product == NULL)
  {
    *error = EINVAL;
    ERRORMSG("product argument is NULL", *error, __LINE__ - 3);
    return;
  }

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

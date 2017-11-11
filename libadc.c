/* Industrial I/O A/D Converter services for Linux */

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libadc.h"

#define NAME_FILE	"/sys/bus/iio/devices/iio:device%d/name"
#define DATA_FILE	"/sys/bus/iio/devices/iio:device%d/in_voltage%d_raw"

void ADC_name(int32_t device, char *name, int32_t namesize, int32_t *error)
{
  char filename[MAXPATHLEN];
  int fd;
  ssize_t len;

  // Validate parameters

  if (device < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid device number", *error, __LINE__ - 3);
    return;
  }

  if (name == NULL)
  {
    *error = EINVAL;
    ERRORMSG("name is NULL", *error, __LINE__ - 3);
    return;
  }

  if (namesize < 16)
  {
    *error = EINVAL;
    ERRORMSG("namesize is too small", *error, __LINE__ - 3);
    return;
  }

  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename), NAME_FILE, device);

  fd = open(filename, O_RDONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  memset(name, 0, namesize);
  len = read(fd, name, namesize - 1);

  if (len >= 0)
    *error = 0;
  else
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 7);
  }

  while ((len > 0) && isspace(name[len-1]))
    name[--len] = 0;

  close(fd);
}

void ADC_open(int32_t device, int32_t channel, int32_t *fd, int32_t *error)
{
  char filename[MAXPATHLEN];

  // Validate parameters

  if (device < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid device number", *error, __LINE__ - 3);
    return;
  }

  // Validate parameters

  if (channel < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid channel number", *error, __LINE__ - 3);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd is NULL", *error, __LINE__ - 3);
    return;
  }

  snprintf(filename, sizeof(filename), DATA_FILE, device, channel);

  *fd = open(filename, O_RDONLY);
  if (*fd < 0)
  {
    *fd = -1;
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
    return;
  }

  *error = 0;
}

void ADC_read(int32_t fd, int32_t *sample, int32_t *error)
{
  char buf[32];
  ssize_t len;

  // Validate parameters

  if (fd < 3)
  {
    *sample = 0;
    *error = EINVAL;
    ERRORMSG("Invalid file descriptor", *error, __LINE__ - 3);
    return;
  }

  if (sample == NULL)
  {
    *error = EINVAL;
    ERRORMSG("sample is NULL", *error, __LINE__ - 3);
    return;
  }

  // Rewind the raw data file

  if (lseek(fd, SEEK_SET, 0) < 0)
  {
    *sample = 0;
    *error = errno;
    ERRORMSG("lseek() failed", *error, __LINE__ - 4);
    return;
  } 

  // Read the raw data file

  len = read(fd, buf, sizeof(buf) - 1);

  if (len < 0)
  {
    *sample = 0;
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 4);
    return;
  }

  buf[len] = 0;
  *sample = atoi(buf);
  *error = 0;
}

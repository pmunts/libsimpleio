/* Linux Industrial I/O common services */

// Copyright (C)2025, Philip Munts dba Munts Technologies.
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
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/param.h>

#include "iiocommon.inc"
#include "macros.inc"

#define NAME_FILE	"/sys/bus/iio/devices/iio:device%d/of_node/name"
#define VREFPH_FILE	"/sys/bus/iio/devices/iio:device%d/of_node/vref-supply"
#define REGPH_FILE	"/sys/class/regulator/regulator.%d/of_node/phandle"
#define UV_FILE		"/sys/class/regulator/regulator.%d/microvolts"

void IIO_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error)
{
  assert(error != NULL);

  char filename[MAXPATHLEN];
  int fd;
  ssize_t len;

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

  if (namesize < 16)
  {
    *error = EINVAL;
    ERRORMSG("namesize argument is too small", *error, __LINE__ - 3);
    return;
  }

  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename), NAME_FILE, chip);

  fd = open(filename, O_RDONLY);

  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
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

void IIO_get_vref(int32_t chip, double *reference, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (reference == NULL)
  {
    *error = EINVAL;
    ERRORMSG("vref argument is NULL", *error, __LINE__ - 3);
    return;
  }

  *reference = 0.0;

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 3);
    return;
  }

  // Get phandle for Vref regulator

  uint32_t vref_phandle = 0;

  char filename[MAXPATHLEN];
  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename) - 1, VREFPH_FILE, chip);

  if (access(filename, R_OK))
  {
    *error = errno;
    ERRORMSG("access() failed", *error, __LINE__ - 3);
    return;
  }

  int fd = open(filename, O_RDONLY);

  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
    return;
  }

  ssize_t len = read(fd, &vref_phandle, sizeof(vref_phandle));

  if (len < 0)
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 5);
    close(fd);
    return;
  }
  else if (len != sizeof(vref_phandle))
  {
    *error = EIO;
    ERRORMSG("read() failed", *error, __LINE__ - 11);
    close(fd);
    return;
  }

  close(fd);

  // Search regulators for matching phandle

  uint32_t reg_phandle = 0;

  int regnum;

  for (regnum = 0; regnum < 100; regnum++)
  {
    memset(filename, 0, sizeof(filename));
    snprintf(filename, sizeof(filename) - 1, REGPH_FILE, regnum);

    if (access(filename, R_OK))
      continue;

    fd = open(filename, O_RDONLY);

    if (fd < 0)
      continue;

    len = read(fd, &reg_phandle, sizeof(reg_phandle));

    close(fd);

    if (len != sizeof(vref_phandle))
      continue;

    if (reg_phandle == vref_phandle)
    {
      memset(filename, 0, sizeof(filename));
      snprintf(filename, sizeof(filename) - 1, UV_FILE, regnum);

      if (access(filename, R_OK))
      {
        *error = errno;
        ERRORMSG("access() failed", *error, __LINE__ - 3);
        return;
      }

      fd = open(filename, O_RDONLY);

      if (fd < 0)
      {
        *error = errno;
        ERRORMSG("open() failed", *error, __LINE__ - 5);
        return;
      }

      char inbuf[256];
      memset(inbuf, 0, sizeof(inbuf));

      len = read(fd, inbuf, sizeof(inbuf) - 1);

      if (len < 0)
      {
        *error = errno;
        ERRORMSG("read() failed", *error, __LINE__ - 5);
        close(fd);
        return;
      }

      close(fd);

      *reference = atof(inbuf)/1000000.0;
      *error = 0;
      return;
    }
  }

  *error = EIO;
  ERRORMSG("Matching regulator not found,", *error, __LINE__ - 4);
  return;
}

void IIO_get_scale(int32_t chip, int32_t channel, const char *scalefile1,
  const char *scalefile2, double *scale, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (scale == NULL)
  {
    *error = EINVAL;
    ERRORMSG("scale argument is NULL", *error, __LINE__ - 3);
    return;
  }

  *scale = 0.0;

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (channel < 0)
  {
    *error = EINVAL;
    ERRORMSG("channel argument is invalid", *error, __LINE__ - 4);
    return;
  }

  // Try xx_xxxxY_scale first

  char filename[MAXPATHLEN];
  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename) - 1, scalefile1, chip, channel);

  if (access(filename, R_OK))
  {
    // Now try xx_xxxx_scale

    memset(filename, 0, sizeof(filename));
    snprintf(filename, sizeof(filename) - 1, scalefile2, chip);
  }

  int fd = open(filename, O_RDONLY);

  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
    return;
  }

  char scalebuf[256];
  memset(scalebuf, 0, sizeof(scalebuf));

  ssize_t len = read(fd, scalebuf, sizeof(scalebuf) - 1);

  if (len >= 0)
  {
    // UGLY SPECIAL HACK: For MCP342x ADC chips, for which the kernel
    // generates incorrect values for xx_xxxxxxY_scale

    char chipname[256];
    memset(chipname, 0, sizeof(chipname));
    IIO_get_name(chip, chipname, sizeof(chipname) - 1, error);

    if (!strncmp(chipname, "mcp342", 6))
      *scale = atof(scalebuf);
    else
      *scale = atof(scalebuf)/1000;

    *error = 0;
  }
  else
  {
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 7);
  }

  close(fd);
}

void IIO_open(int32_t chip, int32_t channel, const char *datafile1,
  const char *datafile2, mode_t mode, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  *fd = -1;

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("chip argument is invalid", *error, __LINE__ - 4);
    return;
  }

  if (channel < 0)
  {
    *error = EINVAL;
    ERRORMSG("channel argument is invalid", *error, __LINE__ - 4);
    return;
  }

  // Try xx_xxxxxxY_raw first

  char filename[MAXPATHLEN];
  snprintf(filename, sizeof(filename), datafile1, chip, channel);

  if (access(filename, R_OK) && channel == 0)
  {
    // Now try xx_xxxxxx_raw IFF channel 0

    memset(filename, 0, sizeof(filename));
    snprintf(filename, sizeof(filename) - 1, datafile2, chip);
  }

  *fd = open(filename, mode);

  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
    return;
  }

  *error = 0;
}

void IIO_read_sample(int32_t fd, int32_t *sample, int32_t *error)
{
  assert(error != NULL);

  char buf[32];
  ssize_t len;

  // Validate parameters

  if (sample == NULL)
  {
    *error = EINVAL;
    ERRORMSG("sample argument is NULL", *error, __LINE__ - 3);
    return;
  }

  *sample = 0;

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  // Rewind the raw data file

  if (lseek(fd, SEEK_SET, 0) < 0)
  {
    *error = errno;
    ERRORMSG("lseek() failed", *error, __LINE__ - 4);
    return;
  }

  // Read from the raw data file

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

void IIO_write_sample(int32_t fd, int32_t sample, int32_t *error)
{
  assert(error != NULL);

  char buf[32];
  int count;
  ssize_t len;

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  // Write to the raw data file

  count = snprintf(buf, sizeof(buf), "%d\n", sample);

  len = write(fd, buf, count);

  if (len < 0)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

void ADC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error) ALIAS("IIO_get_name");
void ADC_get_reference(int32_t chip, double *reference, int32_t *error) ALIAS("IIO_get_vref");
void ADC_read(int32_t fd, int32_t *sample, int32_t *error) ALIAS("IIO_read_sample");
void DAC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error) ALIAS("IIO_get_name");
void DAC_get_reference(int32_t chip, double *reference, int32_t *error) ALIAS("IIO_get_vref");
void DAC_write(int32_t fd, int32_t sample, int32_t *error) ALIAS("IIO_write_sample");
void TEMP_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error) ALIAS("IIO_get_name");
void TEMP_read(int32_t fd, int32_t *sample, int32_t *error) ALIAS("IIO_read_sample");

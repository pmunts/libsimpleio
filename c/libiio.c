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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/param.h>

#include "libiio.h"
#include "macros.inc"

#define NAME_FILE	"/sys/bus/iio/devices/iio:device%d/of_node/name"
#define VREFPH_FILE	"/sys/bus/iio/devices/iio:device%d/of_node/vref-supply"
#define REGPH_FILE	"/sys/class/regulator/regulator.%d/of_node/phandle"
#define UV_FILE		"/sys/class/regulator/regulator.%d/microvolts"
#define DATA_FILE1	"/sys/bus/iio/devices/iio:device%d/%s%d_%s"
#define DATA_FILE2	"/sys/bus/iio/devices/iio:device%d/%s_%s"

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

void IIO_open(int32_t chip, int32_t channel, const char *property,
  const char *suffix, mode_t mode, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

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

  if (property == NULL)
  {
    *error = EINVAL;
    ERRORMSG("property argument is NULL", *error, __LINE__ - 3);
    return;
  }
  if (suffix == NULL)
  {
    *error = EINVAL;
    ERRORMSG("property argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  // Try xx_xxxxY_xxx first

  char filename[MAXPATHLEN];
  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename) - 1, DATA_FILE1, chip, property,
    channel, suffix);

  if (access(filename, F_OK) && (channel == 0))
  {
    // Now try xx_xxxx_xxx

    memset(filename, 0, sizeof(filename));
    snprintf(filename, sizeof(filename) - 1, DATA_FILE2, chip, property,
    suffix);
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

void IIO_get_double(int32_t fd, double *item, int32_t *error)
{
  assert(error != NULL);

  char buf[32];
  ssize_t len;

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (item == NULL)
  {
    *error = EINVAL;
    ERRORMSG("item argument is NULL", *error, __LINE__ - 3);
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
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 4);
    return;
  }

  buf[len] = 0;
  *item = atof(buf);
  *error = 0;
}

void IIO_get_int(int32_t fd, int32_t *item, int32_t *error)
{
  assert(error != NULL);

  char buf[32];
  ssize_t len;

  // Validate parameters

  if (item == NULL)
  {
    *error = EINVAL;
    ERRORMSG("item argument is NULL", *error, __LINE__ - 3);
    return;
  }

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
    *error = errno;
    ERRORMSG("read() failed", *error, __LINE__ - 4);
    return;
  }

  buf[len] = 0;
  *item = atoi(buf);
  *error = 0;
}

void IIO_put_int(int32_t fd, int32_t item, int32_t *error)
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

  count = snprintf(buf, sizeof(buf), "%d\n", item);

  len = write(fd, buf, count);

  if (len < 0)
  {
    *error = errno;
    ERRORMSG("write() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

void IIO_close(int32_t fd, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (close(fd))
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

/*****************************************************************************/

// Compatibility wrapper functions

#include "libadc.h"

void ADC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error) ALIAS("IIO_get_name");

void ADC_get_reference(int32_t chip, double *reference, int32_t *error) ALIAS("IIO_get_vref");

void ADC_get_scale(int32_t chip, int32_t channel, double *scale, int32_t *error)
{
  char chipname[256];
  int fd;

  IIO_get_name(chip, chipname, sizeof(chipname) - 1, error);
  if (*error) return;

  IIO_open(chip, channel, "in_voltage", "scale", O_RDONLY, &fd, error);
  if (*error) return;

  IIO_get_double(fd, scale, error);
  close(fd);
  if (*error) return;

  *scale /= 1000.0; // Convert millivolts per step to volts per step

  // UGLY SPECIAL HACK: Apply correction factor for certain ADC chips,
  // (e.g. MCP3428) for which the kernel generates an incorrect value in
  // in_voltage[Y]_scale, which SHOULD be millivolts per step, according to:
  //
  // https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-bus-iio

  if (!strncmp(chipname, "mcp342", 6))
    *scale *= 1000.0;
}

void ADC_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error)
{
  IIO_open(chip, channel, "in_voltage", "raw", O_RDONLY, fd, error);
}

void ADC_read(int32_t fd, int32_t *sample, int32_t *error) ALIAS("IIO_get_int");

void ADC_close(int32_t fd, int32_t *error) ALIAS("IIO_close");

#include "libdac.h"

void DAC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error) ALIAS("IIO_get_name");

void DAC_get_reference(int32_t chip, double *reference, int32_t *error) ALIAS("IIO_get_vref");

void DAC_get_scale(int32_t chip, int32_t channel, double *scale, int32_t *error)
{
  char chipname[256];
  int fd;

  IIO_get_name(chip, chipname, sizeof(chipname) - 1, error);
  if (*error) return;

  IIO_open(chip, channel, "out_voltage", "scale", O_RDONLY, &fd, error);
  if (*error) return;

  IIO_get_double(fd, scale, error);
  close(fd);
  if (*error) return;

  *scale /= 1000.0; // Convert millivolts per step to volts per step
}

void DAC_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error)
{
  IIO_open(chip, channel, "out_voltage", "raw", O_WRONLY, fd, error);
}

void DAC_write(int32_t fd, int32_t sample, int32_t *error) ALIAS("IIO_put_int");

void DAC_close(int32_t fd, int32_t *error) ALIAS("IIO_close");

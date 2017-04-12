/* PWM (Pulse Width Modulated) output services for Linux */

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

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libpwm.h"

// Device nodes

#define DIR_CLASS	"/sys/class/pwm"
#define DIR_CHIP	DIR_CLASS "/pwmchip%d"
#define FILE_EXPORT	DIR_CHIP "/export"
#define FILE_UNEXPORT	DIR_CHIP "/unexport"
#define DIR_CHAN	DIR_CHIP "/pwm%d/"
#define FILE_ENABLE	DIR_CHAN "/enable"
#define FILE_POLARITY	DIR_CHAN "/polarity"	// "normal" or "inversed" [sic]
#define FILE_PERIOD	DIR_CHAN "/period"	// nanoseconds
#define FILE_ONTIME	DIR_CHAN "/duty_cycle"	// nanoseconds
#define FILE_UEVENT	DIR_CHAN "/uevent"

static uint64_t milliseconds(void)
{
  struct timespec t;

  clock_gettime(CLOCK_REALTIME, &t);
  return t.tv_sec*1000LL + (1LL*t.tv_nsec)/1000000LL;
}

// Configure PWM output device

void PWM_configure(int32_t chip, int32_t channel, int32_t period,
  int32_t ontime, int32_t polarity, int32_t *error)
{
  char filename[MAXPATHLEN];
  char buf[16];
  int fd;
  int len;

  // Validate parameters

  if (chip < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid PWM chip number argument", *error, __LINE__ - 3);
    return;
  }

  if (channel < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid PWM channel number argument", *error, __LINE__ - 3);
    return;
  }

  if (period < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid PWM output period argument", *error, __LINE__ - 3);
    return;
  }

  if (ontime < 0)
  {
    *error = EINVAL;
    ERRORMSG("Invalid PWM output on-time argument", *error, __LINE__ - 3);
    return;
  }

  if ((polarity < PWM_ACTIVELOW) || (polarity > PWM_ACTIVEHIGH))
  {
    *error = EINVAL;
    ERRORMSG("Invalid PWM output polarity argument", *error, __LINE__ - 3);
    return;
  }

  // Export the PWM channel, if necessary

  snprintf(filename, sizeof(filename), DIR_CHAN, chip, channel);

  if (access(filename, F_OK))
  {
    snprintf(filename, sizeof(filename), FILE_EXPORT, chip);

    // Open the PWM chip export file

    fd = open(filename, O_WRONLY);
    if (fd < 0)
    {
      *error = errno;
      ERRORMSG("Cannot open export", *error, __LINE__ - 4);
      return;
    }

    // Export the PWM output channel

    len = snprintf(buf, sizeof(buf), "%d\n", channel);

    if (write(fd, buf, len) < len)
    {
      *error = errno;
      ERRORMSG("Cannot write to export", *error, __LINE__ - 3);
      close(fd);
      return;
    }

    // Close th PWM chip export file

    close(fd);

    // Wait for the PWM output channel directory to be created

    snprintf(filename, sizeof(filename), FILE_ONTIME, chip, channel);

    uint64_t start = milliseconds();

    while (access(filename, W_OK))
    {
      if (milliseconds() - start > 500)
      {
        *error = EIO;
        ERRORMSG("Timed out waiting for PWM output export", *error,
          __LINE__ - 3);
        return;
      }
    }
  }

#ifdef NOT_IMPLEMENTED_IN_KERNEL
  // Disable the PWM output

  snprintf(filename, sizeof(filename), FILE_ENABLE, chip, channel);

  fd = open(filename, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open enable", *error, __LINE__ - 4);
    return;
  }

  if (write(fd, "0\n", 2) < 2)
  {
    *error = errno;
    ERRORMSG("Cannot write to enable", *error, __LINE__ - 3);
    return;
  }

  close(fd);

  // Write to polarity

  snprintf(filename, sizeof(filename), FILE_POLARITY, chip, channel);

  fd = open(filename, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open polarity", *error, __LINE__ - 4);
    return;
  }

  if (polarity == PWM_ACTIVEHIGH)
    len = snprintf(buf, sizeof(buf), "normal\n");
  else
    len = snprintf(buf, sizeof(buf), "inversed\n");

  if (write(fd, buf, len) < len)
  {
    *error = errno;
    ERRORMSG("Cannot write to polarity", *error, __LINE__ - 3);
    return;
  }

  close(fd);

  // Reenable the PWM output

  snprintf(filename, sizeof(filename), FILE_ENABLE, chip, channel);

  fd = open(filename, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open enable", *error, __LINE__ - 4);
    return;
  }

  if (write(fd, "1\n", 2) < 2)
  {
    *error = errno;
    ERRORMSG("Cannot write to enable", *error, __LINE__ - 3);
    return;
  }

  close(fd);
#endif

  // Write to period

  snprintf(filename, sizeof(filename), FILE_PERIOD, chip, channel);

  fd = open(filename, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open period", *error, __LINE__ - 4);
    return;
  }

  len = snprintf(buf, sizeof(buf), "%d\n", period);

  if (write(fd, buf, len) < len)
  {
    *error = errno;
    ERRORMSG("Cannot write to period", *error, __LINE__ - 3);
    return;
  }

  close(fd);

  // Write to duty_cycle (which is actually the on time in nanosecods...)

  snprintf(filename, sizeof(filename), FILE_ONTIME, chip, channel);

  fd = open(filename, O_WRONLY);
  if (fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open duty_cycle", *error, __LINE__ - 4);
    return;
  }

  len = snprintf(buf, sizeof(buf), "%d\n", ontime);

  if (write(fd, buf, len) < len)
  {
    *error = errno;
    ERRORMSG("Cannot write to duty_cycle", *error, __LINE__ - 3);
    return;
  }

  close(fd);

  *error = 0;
}

// Open PWM output device

void PWM_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error)
{
  char filename[MAXPATHLEN];

  snprintf(filename, sizeof(filename), FILE_ONTIME, chip, channel);

  *fd = open(filename, O_WRONLY);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("Cannot open duty_cycle", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

// Write to PWM output device

void PWM_write(int32_t fd, int32_t ontime, int32_t *error)
{
  char buf[16];
  int len;

  // Convert on time to string

  len = snprintf(buf, sizeof(buf), "%d\n", ontime);

  // Write string to the device

  if (write(fd, buf, len) < len)
  {
    *error = errno;
    ERRORMSG("Cannot write to duty_cycle", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

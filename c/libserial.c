/* Serial port device wrapper services for Linux */

// Copyright (C)2016-2025, Philip Munts dba Munts Technologies.
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

#include "macros.inc"
#include "libserial.h"

void SERIAL_open(const char *name, int32_t baudrate, int32_t parity,
  int32_t databits, int32_t stopbits, int32_t *fd, int32_t *error)
{
  assert(error != NULL);

  struct termios cfg;

  // Validate parameters

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  if (name == NULL)
  {
    *fd = -1;
    *error = EINVAL;
    ERRORMSG("name argument is NULL", *error, __LINE__ - 4);
    return;
  }

#if (__GLIBC__ == 2 && __GLIBC_MINOR__ < 42)
  // After glibc release 2.42, arbitrary baud rates are supported and the Bxxx
  // macros are no longer relevant.

  switch (baudrate)
  {
    case 50 :
    case 75 :
    case 110 :
    case 134 :
    case 150 :
    case 200 :
    case 300 :
    case 600 :
    case 1200 :
    case 1800 :
    case 2400 :
    case 4800 :
    case 9600 :
    case 19200 :
    case 38400 :
    case 57600 :
    case 115200 :
    case 230400 :
#ifdef B460800
    case 460800 :
#endif
#ifdef B500000
    case 500000 :
#endif
#ifdef B576000
    case 576000 :
#endif
#ifdef B921600
    case 921600 :
#endif
#ifdef B1000000
    case 1000000 :
#endif
#ifdef B1152000
    case 1152000 :
#endif
#ifdef B1500000
    case 1500000 :
#endif
#ifdef B2000000
    case 2000000 :
#endif
#ifdef B2500000
    case 2500000 :
#endif
#ifdef B3000000
    case 3000000 :
#endif
#ifdef B3500000
    case 3500000 :
#endif
#ifdef B4000000
    case 4000000 :
#endif
      break;

    default :
      *fd = -1;
      *error = EINVAL;
      ERRORMSG("baudrate argument is invalid", *error, __LINE__ - 25);
      return;
  }
#endif

  if ((parity < SERIAL_PARITY_NONE) || (parity > SERIAL_PARITY_ODD))
  {
    *fd = -1;
    *error = EINVAL;
    ERRORMSG("parity argument is invalid", *error, __LINE__ - 4);
    return;
  }

  if ((databits < 5) || (databits > 8))
  {
    *fd = -1;
    *error = EINVAL;
    ERRORMSG("databits argument is invalid", *error, __LINE__ - 4);
    return;
  }

  if ((stopbits < 1) || (stopbits > 2))
  {
    *fd = -1;
    *error = EINVAL;
    ERRORMSG("stopbits argument is invalid", *error, __LINE__ - 4);
    return;
  }

  // Open serial port device

  *fd = open(name, O_RDWR|O_NOCTTY);
  if (*fd < 0)
  {
    *fd = -1;
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 5);
    return;
  }

  // Configure serial port device

  if (tcgetattr(*fd, &cfg))
  {
    *error = errno;
    ERRORMSG("tcgetattr() failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  // Put serial port into raw mode

  cfmakeraw(&cfg);

  cfg.c_cflag &= ~HUPCL;
  cfg.c_iflag = 0;
  cfg.c_oflag = 0;
  cfg.c_lflag = 0;

  // Set baud rate

#if (__GLIBC__ == 2 && __GLIBC_MINOR__ < 42)
  // After glibc release 2.42, arbitrary baud rates are supported and the Bxxx
  // macros are no longer relevant.

  switch (baudrate)
  {
    case 50:
      baudrate = B50;
      break;

    case 75:
      baudrate = B75;
      break;

    case 110:
      baudrate = B110;
      break;

    case 134:
      baudrate = B134;
      break;

    case 150:
      baudrate = B150;
      break;

    case 200:
      baudrate = B200;
      break;

    case 300:
      baudrate = B300;
      break;

    case 600:
      baudrate = B600;
      break;

    case 1200:
      baudrate = B1200;
      break;

    case 1800:
      baudrate = B1800;
      break;

    case 2400:
      baudrate = B2400;
      break;

    case 4800:
      baudrate = B4800;
      break;

    case 9600:
      baudrate = B9600;
      break;

    case 19200:
      baudrate = B19200;
      break;

    case 38400:
      baudrate = B38400;
      break;

    case 57600:
      baudrate = B57600;
      break;

    case 115200:
      baudrate = B115200;
      break;

    case 230400:
      baudrate = B230400;
      break;

#ifdef B460800
    case 460800:
      baudrate = B460800;
      break;
#endif

#ifdef B500000
    case 500000:
      baudrate = B500000;
      break;
#endif

#ifdef B576000
    case 576000:
      baudrate = B576000;
      break;
#endif

#ifdef B921600
    case 921600:
      baudrate = B921600;
      break;
#endif

#ifdef B1000000
    case 1000000:
      baudrate = B1000000;
      break;
#endif

#ifdef B1152000
    case 1152000:
      baudrate = B1152000;
      break;
#endif

#ifdef B1500000
    case 1500000:
      baudrate = B1500000;
      break;
#endif

#ifdef B2000000
    case 2000000:
      baudrate = B2000000;
      break;
#endif

#ifdef B2500000
    case 2500000:
      baudrate = B2500000;
      break;
#endif

#ifdef B3000000
    case 3000000:
      baudrate = B3000000;
      break;
#endif

#ifdef B350000
    case 3500000:
      baudrate = B3500000;
      break;
#endif

#ifdef B4000000
    case 4000000:
      baudrate = B4000000;
      break;
#endif
  }
#endif

  cfsetispeed(&cfg, baudrate);
  cfsetospeed(&cfg, baudrate);

  // Set parity mode

  switch (parity)
  {
    case SERIAL_PARITY_NONE :
      cfg.c_cflag &= ~PARENB;
      cfg.c_cflag &= ~PARODD;
      cfg.c_iflag &= ~INPCK;
      break;

    case SERIAL_PARITY_EVEN :
      cfg.c_cflag |= PARENB;
      cfg.c_cflag &= ~PARODD;
      cfg.c_iflag |= INPCK;
      break;

    case SERIAL_PARITY_ODD :
      cfg.c_cflag |= PARENB;
      cfg.c_cflag |= PARODD;
      cfg.c_iflag |= INPCK;
      break;
  }

  // Set data bits

  cfg.c_cflag &= ~CSIZE;

  switch (databits)
  {
    case 5 :
      cfg.c_cflag |= CS5;
      break;

    case 6 :
      cfg.c_cflag |= CS6;
      break;

    case 7 :
      cfg.c_cflag |= CS7;
      break;

    case 8 :
      cfg.c_cflag |= CS8;
      break;
  }

  // Set stop bits

  switch (stopbits)
  {
    case 2 :
      cfg.c_cflag |= CSTOPB;
      break;
  }

  if (tcsetattr(*fd, TCSANOW, &cfg))
  {
    *error = errno;
    ERRORMSG("tcgetattr() failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  // Flush serial buffers

  usleep(100000); // Don't know why this delay is necessary

  if (tcflush(*fd, TCIOFLUSH) < 0)
  {
    *error = errno;
    ERRORMSG("tcflush() failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  *error = 0;
}

static const int32_t QueueSelector[3] = { TCIFLUSH, TCOFLUSH, TCIOFLUSH };

void SERIAL_flush(int32_t fd, int32_t what, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((what < SERIAL_FLUSH_INPUT) || (what > SERIAL_FLUSH_BOTH))
  {
    *error = EINVAL;
    ERRORMSG("what argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (tcflush(fd, QueueSelector[what]) < 0)
  {
    *error = errno;
    ERRORMSG("tcflush() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

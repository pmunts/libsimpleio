/* Serial port device wrapper services for Linux */

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
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

#include "errmsg.inc"
#include "libserial.h"

void SERIAL_open(const char *name, int32_t baudrate, int32_t parity, int32_t databits, int32_t stopbits, int32_t *fd, int32_t *error)
{
  struct termios cfg;

  // Validate parameters

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
      break;

    default :
      *fd = -1;
      *error = EINVAL;
      return;
  }

  if ((parity < SERIAL_PARITY_NONE) || (parity > SERIAL_PARITY_ODD))
  {
    *fd = -1;
    *error = EINVAL;
    return;
  }

  if ((databits < 5) || (databits > 8))
  {
    *fd = -1;
    *error = EINVAL;
    return;
  }

  if ((stopbits < 1) || (stopbits > 2))
  {
    *fd = -1;
    *error = EINVAL;
    return;
  }

  // Open serial port device

  *fd = open(name, O_RDWR);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
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

  cfmakeraw(&cfg);

  switch (baudrate)
  {
    case 50:
      cfg.c_cflag |= B50;
      break;

    case 75:
      cfg.c_cflag |= B75;
      break;

    case 110:
      cfg.c_cflag |= B110;
      break;

    case 134:
      cfg.c_cflag |= B134;
      break;

    case 150:
      cfg.c_cflag |= B150;
      break;

    case 200:
      cfg.c_cflag |= B200;
      break;

    case 300:
      cfg.c_cflag |= B300;
      break;

    case 600:
      cfg.c_cflag |= B600;
      break;

    case 1200:
      cfg.c_cflag |= B1200;
      break;

    case 1800:
      cfg.c_cflag |= B1800;
      break;

    case 2400:
      cfg.c_cflag |= B2400;
      break;

    case 4800:
      cfg.c_cflag |= B4800;
      break;

    case 9600:
      cfg.c_cflag |= B9600;
      break;

    case 19200:
      cfg.c_cflag |= B19200;
      break;

    case 38400:
      cfg.c_cflag |= B38400;
      break;

    case 57600:
      cfg.c_cflag |= B57600;
      break;

    case 115200:
      cfg.c_cflag |= B115200;
      break;

    case 230400:
      cfg.c_cflag |= B230400;
      break;
  }

  switch (parity)
  {
    case SERIAL_PARITY_EVEN :
      cfg.c_cflag |= PARENB;
      break;

    case SERIAL_PARITY_ODD :
      cfg.c_cflag |= PARENB;
      cfg.c_cflag |= PARODD;
      break;
  }

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

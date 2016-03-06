/* SPI transaction services for Linux */

// $Id$

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
#include <sys/ioctl.h>
#include <sys/param.h>

#include <libspi.h>
#include "errmsg.inc"

// Open and configure the SPI port

void SPI_open(char *name, int mode, int wordsize, int speed, int *fd, int *error)
{
  // Open the SPI device

  *fd = open(name, O_RDWR);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    *fd = -1;
    return;
  }

  // Configure SPI transfer mode (clock polarity and phase)

  if (ioctl(*fd, SPI_IOC_WR_MODE, &mode) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for SPI_IOC_WR_MODE failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  // Configure SPI transfer word size

  if (ioctl(*fd, SPI_IOC_WR_BITS_PER_WORD, &wordsize) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for SPI_IOC_WR_BITS_PER_WORD failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  // Configure (maximum) SPI transfer speed

  if (ioctl(*fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for SPI_IOC_WR_MAX_SPEED_HZ failed", *error, __LINE__ - 3);
    close(*fd);
    *fd = -1;
    return;
  }

  *error = 0;
}

// Close the SPI port

void SPI_close(int fd, int *error)
{
  if (close(fd))
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Perform an SPI I/O transaction (command and response)

void SPI_transaction(int fd, void *cmd, int cmdlen, int delayus, void *resp, int resplen, int *error)
{
  struct spi_ioc_transfer xfer[2];

  // Prepare the SPI ioctl transfer structure
  //   xfer[0] is the outgoing command to the slave MCU
  //   xfer[1] is the incoming response from the slave MCU

  // The command and response transfers are executed back to back with
  // with a inter-transfer delay in microseconds specfied by xfer[0].delay
  // This delay determines the time available to the slave MCU to decode the
  // command and generate the response.

  memset(xfer, 0, sizeof(xfer));
  xfer[0].tx_buf = (typeof(xfer[0].tx_buf)) cmd;
  xfer[0].len = cmdlen;
  xfer[0].delay_usecs = delayus;
  xfer[1].rx_buf = (typeof(xfer[1].rx_buf)) resp;
  xfer[1].len = resplen;

  // Execute the SPI transfer operations

  if (ioctl(fd, SPI_IOC_MESSAGE(2), xfer) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl for SPI_IOC_MESSAGE failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

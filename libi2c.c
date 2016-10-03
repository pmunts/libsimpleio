/* I2C services for Linux */

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
#include <linux/i2c-dev.h>
#ifndef I2C_M_RD
#include <linux/i2c.h>
#endif
#include <sys/ioctl.h>
#include <sys/param.h>

#include "errmsg.inc"
#include "libi2c.h"

// Open I2C device

void I2C_open(const char *name, int32_t *fd, int32_t *error)
{
  // Open the I2C device

  *fd = open(name, O_RDWR);
  if (*fd < 0)
  {
    *error = errno;
    ERRORMSG("open() failed", *error, __LINE__ - 4);
    return;
  }

  *error = 0;
}

// Close I2C device

void I2C_close(int32_t fd, int32_t *error)
{
  if (close(fd))
  {
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Perform an I2C transaction

void I2C_transaction(int32_t fd, int32_t slaveaddr, void *cmd, int32_t cmdlen, void *resp, int32_t resplen, int32_t *error)
{
  struct i2c_rdwr_ioctl_data cmdblk;
  struct i2c_msg msgs[2];
  struct i2c_msg *p;

  memset(&cmdblk, 0, sizeof(cmdblk));
  cmdblk.msgs = msgs;

  memset(&msgs, 0, sizeof(msgs));
  p = msgs;

  if ((cmd != NULL) && (cmdlen != 0))
  {
    p->addr = slaveaddr;
    p->len = cmdlen;
    p->buf = cmd;
    p++;
    cmdblk.nmsgs++;
  }

  if ((resp != NULL) && (resplen != 0))
  {
    p->addr = slaveaddr;
    p->flags = I2C_M_RD;
    p->len = resplen;
    p->buf = resp;
    cmdblk.nmsgs++;
  }

  if (ioctl(fd, I2C_RDWR, &cmdblk) < 0)
  {
    *error = errno;
    ERRORMSG("ioctl() for I2C_RDWR failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

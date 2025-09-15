/* I2C services for Linux */

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
#include <string.h>
#include <unistd.h>
#include <linux/i2c-dev.h>
#ifndef I2C_M_RD
#include <linux/i2c.h>
#endif
#include <sys/ioctl.h>
#include <sys/param.h>

#include "macros.inc"
#include "libi2c.h"
#include "liblinux.h"

// An I2C bus controller device can be shared among two or more I2C slave
// devices.  We save open I2C bus controller file descriptors in fdtable so
// we can reuse them if the program attempts to create multiple instances of
// the same I2C bus.  An important use case is a mikroBUS shield with multiple
// sockets all sharing the same I2C bus.  We want to avoid opening a new I2C
// bus controller file descriptor for each socket.

#define MAX_BUSES 64

typedef struct
{
  unsigned refcount;
  int32_t fd;
  char name[MAXPATHLEN];
} fdentry_t;

static fdentry_t fdtable[MAX_BUSES] = { 0 };

// Open I2C bus controller device

void I2C_open(const char *name, int32_t *fd, int32_t *error)
{
  int i;

  assert(error != NULL);

  // Validate parameters

  if (name == NULL)
  {
    *fd = -1;
    *error = EINVAL;
    ERRORMSG("name argument is NULL", *error, __LINE__ - 4);
    return;
  }

  if (fd == NULL)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is NULL", *error, __LINE__ - 3);
    return;
  }

  // Search fdtable for existing entry (bus has already been opened)

  for (i = 0; i < MAX_BUSES; i++)
    if ((fdtable[i].refcount > 0) &&
        (fdtable[i].fd >= 0)      &&
        !strncmp((char *) fdtable[i].name, name, MAXPATHLEN-1))
    {
      fdtable[i].refcount++;
      *fd = fdtable[i].fd;
      *error = 0;
      return;
    }

  // Bus has not already been opened, now search for an empty entry
  // and open the bus

  for (i = 0; i < MAX_BUSES; i++)
    if (fdtable[i].refcount == 0)
    {
      LINUX_open_readwrite(name, fd, error);
      if (*error) return;

      fdtable[i].refcount = 1;
      fdtable[i].fd = *fd;
      memset(fdtable[i].name, 0, MAXPATHLEN);
      strncpy(fdtable[i].name, name, MAXPATHLEN-1);

      *error = 0;
      return;
    }

  // The fd table is full!

  *error = EMFILE;
  ERRORMSG("Cannot open another I2C bus, fdtable is full", *error, __LINE__ - 1);
}

// Close I2C bus controller device

void I2C_close(int32_t fd, int32_t *error)
{
  int i;

  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  // Search fdtable for a matching entry

  for (i = 0; i < MAX_BUSES; i++)
    if ((fdtable[i].refcount > 0) && (fdtable[i].fd == fd))
      if (--fdtable[i].refcount == 0)
      {
        fdtable[i].fd = -1;
        memset(fdtable[i].name, 0, MAXPATHLEN);
	LINUX_close(fd, error);
        return;
      }

  *error = EINVAL;
  ERRORMSG("fd argument not found", *error, __LINE__ - 3);
}

// Perform an I2C transaction

void I2C_transaction(int32_t fd, int32_t slaveaddr, void *cmd, int32_t cmdlen,
  void *resp, int32_t resplen, int32_t *error)
{
  assert(error != NULL);

  // Validate parameters

  if (fd < 0)
  {
    *error = EINVAL;
    ERRORMSG("fd argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((slaveaddr < 0) || (slaveaddr > 127))
  {
    *error = EINVAL;
    ERRORMSG("slaveaddr argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (cmdlen < 0)
  {
    *error = EINVAL;
    ERRORMSG("cmdlen argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if (resplen < 0)
  {
    *error = EINVAL;
    ERRORMSG("resplen argument is invalid", *error, __LINE__ - 3);
    return;
  }

  if ((cmd == NULL) && (cmdlen != 0))
  {
    *error = EINVAL;
    ERRORMSG("cmd and cmdlen arguments are inconsistent", *error, __LINE__ - 3);
    return;
  }

  if ((cmd != NULL) && (cmdlen == 0))
  {
    *error = EINVAL;
    ERRORMSG("cmd and cmdlen arguments are inconsistent", *error, __LINE__ - 3);
    return;
  }

  if ((resp == NULL) && (resplen != 0))
  {
    *error = EINVAL;
    ERRORMSG("resp and resplen arguments are inconsistent", *error, __LINE__ - 3);
    return;
  }

  if ((resp != NULL) && (resplen == 0))
  {
    *error = EINVAL;
    ERRORMSG("resp and resplen arguments are inconsistent", *error, __LINE__ - 3);
    return;
  }

  if ((cmd == NULL) && (resp == NULL))
  {
    *error = EINVAL;
    ERRORMSG("cmd and resp arguments are both NULL", *error, __LINE__ - 3);
    return;
  }

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

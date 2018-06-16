/* Linux syscall wrappers.  These are primarily for the benefit of other */
/* programming languages, such as Ada, Pascal, Java, etc.                */

// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

#ifndef LIBLINUX_H
#define LIBLINUX_H

#include <libsimpleio/cplusplus.h>
#include <poll.h>
#include <stdint.h>
#include <syslog.h>

#define LOG_PROGNAME	""

_BEGIN_STD_C

// Detach process from the controlling terminal and run it in the background

extern void LINUX_detach(int32_t *error);

// Drop privileges from superuser to ordinary user

extern void LINUX_drop_privileges(const char *username, int32_t *error);

// Open syslog connection

extern void LINUX_openlog(const char *id, int32_t options, int32_t facility,
  int32_t *error);

// Post syslog message

extern void LINUX_syslog(int32_t priority, const char *msg, int32_t *error);

// Retrieve errno message

extern void LINUX_strerror(int32_t error, char *buf, int32_t bufsize);

// Wait for an event on one or more files

extern void LINUX_poll(int32_t numfiles, int32_t *files, int32_t *events,
  int32_t *results, int32_t timeout, int32_t *error);

// Sleep for some number of microseconds

extern void LINUX_usleep(int32_t microseconds, int32_t *error);

/****************************************************************************/
/*   The following helper functions should not be called directly.  They    */
/*   will be wrapped for each type of I/O device and language binding.      */
/*   Example: SERIAL_close() is defined as a macro wrapping LINUX_close().  */
/****************************************************************************/

// Open a file descriptor

extern void LINUX_open(const char *name, int32_t flags, int32_t mode,
  int32_t *fd, int32_t *error);

// Open a file descriptor for read access

extern void LINUX_open_read(const char *name, int32_t *fd, int32_t *error);

// Open a file descriptor for write access

extern void LINUX_open_write(const char *name, int32_t *fd, int32_t *error);

// Open a file descriptor for read/write access

extern void LINUX_open_readwrite(const char *name, int32_t *fd, int32_t *error);

// Close a file descriptor

extern void LINUX_close(int32_t fd, int32_t *error);

// Read from a file descriptor

extern void LINUX_read(int32_t fd, void *buf, int32_t bufsize, int32_t *count,
  int32_t *error);

// Write to a file descriptor

extern void LINUX_write(int32_t fd, void *buf, int32_t bufsize, int32_t *count,
  int32_t *error);

_END_STD_C

#endif

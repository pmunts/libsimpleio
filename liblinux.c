/* Linux syscall wrappers.  These are primarily for the benefit of other */
/* programming languages, such as Ada, Pascal, Java, etc.                */

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
#include <grp.h>
#include <pwd.h>
#include <string.h>
#include <unistd.h>

#include "liblinux.h"
#include "errmsg.inc"

// Detach process from the controlling terminal and run it in the background

void LINUX_detach(int32_t *error)
{
  if (daemon(0, 0))
  {
    *error = errno;
    ERRORMSG("daemon() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

// Drop privileges from superuser to ordinary user

void LINUX_drop_privileges(const char *username, int32_t *error)
{
  struct passwd *pwent;

  // Look up the user name

  pwent = getpwnam(username);
  if (pwent == NULL)
  {
    *error = errno;
    ERRORMSG("getpwnam() failed", *error, __LINE__ - 4);
    return;
  }

  // Set group membership

  if (initgroups(pwent->pw_name, pwent->pw_gid))
  {
    *error = errno;
    ERRORMSG("initgroups() failed", *error, __LINE__ - 3);
    return;
  }

  // Change gid

  if (setgid(pwent->pw_gid))
  {
    *error = errno;
    ERRORMSG("setgid() failed", *error, __LINE__ - 3);
    return;
  }

  // Change uid

  if (setuid(pwent->pw_uid))
  {
    *error = errno;
    ERRORMSG("setuid() failed", *error, __LINE__ -3);
    return;
  }

  *error = 0;
}

// Open syslog connection

static char ident[256];

void LINUX_openlog(const char *id, int32_t options, int32_t facility, int32_t *error)
{
  memset(ident, 0, sizeof(ident));
  strncpy(ident, id, sizeof(ident) - 1);

  openlog(ident, options, facility);
  *error = 0;
}

// Post syslog message

void LINUX_syslog(int32_t priority, const char *msg, int32_t *error)
{
  syslog(priority, msg);
  *error = 0;
}

// USB Raw HID Hotplug Helper

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/param.h>
#include <sys/stat.h>

#define PROGNAME	"usb-hid-hotplug-attach"
#define DEVNAME		argv[1]
#define VENDOR		argv[2]+2
#define PRODUCT		argv[3]+2
#define SERIALNUMBER	argv[4]

int main(int argc, char **argv)
{
  char devname[MAXPATHLEN];
  char linkname[MAXPATHLEN];

  openlog(PROGNAME, LOG_PERROR|LOG_PID, LOG_LOCAL0);

  // Validate command line arguments

  if (argc != 5) exit(0);
  if (strncmp(DEVNAME, "uhid", 4)) exit(0);

  snprintf(devname, sizeof(devname) - 1, "/dev/%s", DEVNAME);

  // Create some useful symbolic links

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%s:%s",
    VENDOR, PRODUCT);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }

  if (strlen(SERIALNUMBER) == 0) exit(0);

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%s:%s-%s",
    VENDOR, PRODUCT, SERIALNUMBER);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }

  // Relax permissions

  if (chmod(devname, 0660))
    syslog(LOG_ERR, "chmod() failed, %s", strerror(errno));
}

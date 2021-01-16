// USB Raw HID Hotplug Helper

// Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
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

#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/param.h>
#include <sys/stat.h>

#define PROGNAME	"usb-hid-hotplug-detach"
#define DEVNAME		argv[1]

int main(int argc, char **argv)
{
  DIR *dirp;
  struct dirent *dire;
  char devname[MAXPATHLEN];
  char linkname[MAXPATHLEN];
  char linktarget[MAXPATHLEN];

  openlog(PROGNAME, LOG_PERROR|LOG_PID, LOG_LOCAL0);

  // Validate command line arguments

  if (argc != 2) exit(0);
  if (!strncmp(DEVNAME, "uhidev", 6)) exit(0);
  if (strncmp(DEVNAME, "uhid", 4)) exit(0);

  snprintf(devname, sizeof(devname)-1, "/dev/%s", DEVNAME);

  dirp = opendir("/dev");

  if (dirp == NULL)
  {
    syslog(LOG_ERR, "opendir failed(), %s", strerror(errno));
    exit(0);
  }

  // Scan the /dev directory, looking for symbolic links created by
  // usb-hid-hotplug-attach

  dire = readdir(dirp);

  while (dire != NULL)
  {
    if (!strncmp(dire->d_name, "hidraw-", 7))
    {
      memset(linkname, 0, sizeof(linkname));
      snprintf(linkname, sizeof(linkname)-1, "/dev/%s", dire->d_name);

      memset(linktarget, 0, sizeof(linktarget));
      readlink(linkname, linktarget, sizeof(linktarget)-1);

      if (!strcmp(linktarget, DEVNAME))
      {
	if (unlink(linkname))
          syslog(LOG_ERR, "unlink() for %s failed, %s", linkname,
	    strerror(errno));

	chmod(devname, 0600);
      }
    }

    dire = readdir(dirp);
  }

  closedir(dirp);
}

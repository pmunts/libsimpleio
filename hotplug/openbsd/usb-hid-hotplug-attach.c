// USB Raw HID Hotplug Helper

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <dev/usb/usb.h>
#include <sys/param.h>
#include <sys/stat.h>

#define PROGNAME	"usb-hid-hotplug-attach"
#define DEVNAME		argv[1]

// Search the config file for a matching device ID

void SearchConfig(uint16_t VID, uint16_t PID)
{
  FILE *cfg;
  char devid[32];
  char inbuf[256];

  // Open the configuration file

  cfg = fopen("/etc/hidraw.conf", "rt");

  if (cfg == NULL)
  {
    syslog(LOG_ERR, "fopen() failed, %s", strerror(errno));
    exit(0);
  }

  // Search for a matching entry in the configuration file

  snprintf(devid, sizeof(devid)-1, "%04X:%04X", VID, PID);

  while (fgets(inbuf, sizeof(inbuf)-1, cfg) != NULL)
    if (!strncasecmp(devid, inbuf, 9))
    {
      fclose(cfg);
      return;
    }

  // Nothing found

  exit(0);
}

int main(int argc, char **argv)
{
  char devname[MAXPATHLEN];
  int fd;
  struct usb_device_info devinfo;
  char linkname[MAXPATHLEN];

  openlog(PROGNAME, LOG_PERROR|LOG_PID, LOG_LOCAL0);

  // Validate command line arguments

  if (argc != 2) exit(0);
  if (!strncmp(DEVNAME, "uhidev", 6)) exit(0);
  if (strncmp(DEVNAME, "uhid", 4)) exit(0);

  snprintf(devname, sizeof(devname) - 1, "/dev/%s", DEVNAME);

  // Try to create a device node (just in case)

  mknod(devname, S_IFCHR | 0600, makedev(62, atoi(DEVNAME + 4)));

  // Open the candidate raw HID device

  fd = open(devname, O_RDONLY);

  if (fd < 0)
  {
    syslog(LOG_ERR, "open() failed, %s", strerror(errno));
    exit(0);
  }

  // Fetch the USB device information

  if (ioctl(fd, USB_GET_DEVICEINFO, &devinfo) < 0)
  {
    syslog(LOG_ERR, "ioctl() failed, %s", strerror(errno));
    exit(0);
  }

  close(fd);

  // Search the configuration file for a matching device entry

  SearchConfig(devinfo.udi_vendorNo, devinfo.udi_productNo);

  // Relax permissions of the raw HID device

  if (chmod(devname, 0660) < 0)
  {
    syslog(LOG_ERR, "chmod() failed, %s", strerror(errno));
    exit(0);
  }

  // Create some useful symbolic links to the raw HID device

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%04x:%04x",
    devinfo.udi_vendorNo, devinfo.udi_productNo);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }

  if (strlen(devinfo.udi_serial) == 0) exit(0);

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%04x:%04x-%s",
    devinfo.udi_vendorNo, devinfo.udi_productNo, devinfo.udi_serial);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }
}

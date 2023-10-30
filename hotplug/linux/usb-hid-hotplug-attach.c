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
#include <grp.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <linux/types.h>
#include <linux/input.h>
#include <linux/hidraw.h>
#include <sys/ioctl.h>
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
  int devfd;
  struct hidraw_devinfo devinfo;
  char linkname[MAXPATHLEN];
  char serialpath[MAXPATHLEN];
  int serialfd;
  char devserial[256];

  openlog(PROGNAME, LOG_PERROR|LOG_PID, LOG_LOCAL0);

  // Validate command line arguments

  if (argc != 2) exit(0);

  if (getenv("PRODUCT") && getenv("ID_BUS") && getenv("DEVPATH"))
  {
    int VID;
    int PID;

    // Try to match vendor and product ID

    sscanf(getenv("PRODUCT"), "%x/%x", &VID, &PID);
    SearchConfig(VID, PID);

    // Override USB power limit, if necessary

    char bcv[MAXPATHLEN];
    snprintf(bcv, sizeof(bcv) - 1, "/sys%s/bConfigurationValue", getenv("DEVPATH"));

    char cmdbuf[16384];
    snprintf(cmdbuf, sizeof(cmdbuf) - 1,
      "read <%s INBUF ; test -z \"$INBUF\" && echo 1 >%s", bcv, bcv);

    system(cmdbuf);
    exit(0);
  }

  if (strncmp(DEVNAME, "hidraw", 6)) exit(0);

  snprintf(devname, sizeof(devname) - 1, "/dev/%s", DEVNAME);

  // Open the raw HID device

  devfd = open(devname, O_RDONLY);

  if (devfd < 0)
  {
    syslog(LOG_ERR, "open() failed, %s", strerror(errno));
    exit(0);
  }

  // Fetch the USB device information for the raw HID device

  if (ioctl(devfd, HIDIOCGRAWINFO, &devinfo) < 0)
  {
    syslog(LOG_ERR, "ioctl() failed, %s", strerror(errno));
    exit(0);
  }

  close(devfd);

  // Search the configuration file for a matching device entry

  SearchConfig(devinfo.vendor, devinfo.product);

  // Change group ownership of the raw HID device

  struct group *groupinfo = getgrnam("plugdev");

  if (groupinfo == NULL)
  {
    syslog(LOG_ERR, "getgrnam() failed, %s", strerror(errno));
    exit(0);
  }

  if (chown(devname, 0, groupinfo->gr_gid))
  {
    syslog(LOG_ERR, "chown() failed, %s", strerror(errno));
    exit(0);
  }

  // Change permissions of the raw HID device

  if (chmod(devname, 0660) < 0)
  {
    syslog(LOG_ERR, "chmod() failed, %s", strerror(errno));
    exit(0);
  }

  // Create a useful symbolic link to the raw HID device

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%04x:%04x",
    devinfo.vendor, devinfo.product);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }

  // Fetch the serial number for the raw HID device

  snprintf(serialpath, sizeof(serialpath),
    "/sys/class/hidraw/%s/../../../../serial", DEVNAME);

  serialfd = open(serialpath, O_RDONLY);

  if (serialfd < 0)
    exit(0);

  memset(devserial, 0, sizeof(0));
  read(serialfd, devserial, sizeof(devserial)-1);
  close(serialfd);

  // Check whether we found a serial number

  if (strlen(devserial) == 0)
    exit(0);

  // Remove trailing LF, if any

  if (devserial[strlen(devserial)-1] == 10)
    devserial[strlen(devserial)-1] = 0;

  // Create another useful symbolic link to the raw HID device

  snprintf(linkname, sizeof(linkname) - 1, "/dev/hidraw-%04x:%04x-%s",
    devinfo.vendor, devinfo.product, devserial);

  unlink(linkname);

  if (symlink(DEVNAME, linkname) < 0)
  {
    syslog(LOG_ERR, "symlink() failed, %s", strerror(errno));
    exit(0);
  }
}

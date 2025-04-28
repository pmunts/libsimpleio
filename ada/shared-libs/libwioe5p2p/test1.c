#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "libwioe5p2p.h"

static void msleep(unsigned milliseconds)
{
  usleep(milliseconds*1000);
}

int main(void)
{
  int handle;
  uint8_t msg[243];
  int len;
  int rss;
  int snr;
  int error;

  wioe5p2p_init("/dev/ttyAMA0", 115200, 915.0, 7, 500, 12, 15, 22, &handle, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5p2p_init() failed, %s\n", strerror(error));
    exit(1);
  }

  wioe5p2p_send(handle, "This is a test.", 15, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5p2p_send_string() failed, %s\n", strerror(error));
    exit(1);
  }

  msleep(300);

  wioe5p2p_receive(handle, msg, &len, &rss, &snr, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5p2p_receive() failed, %s\n", strerror(error));
    exit(1);
  }

  if (len > 0)
  {
    printf("Received %d bytes => \"%s\", From node %d to node %d, %d dBm %d dB\n", len, msg, rss, snr);
  }
}

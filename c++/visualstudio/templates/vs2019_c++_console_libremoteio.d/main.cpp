#include <cstdio>
#include <cstdlib>

#include <remoteio-client.h>

int main(void)
{
  puts("\nRemote I/O Protocol Client Program\n");

  // Create a Remote I/O client object

  RemoteIO::Client::Device_Class dev;

  // Display Remote I/O server information and capability strings

  printf("Information:  %s\n", dev.Version.c_str());
  printf("Capabilities: %s\n", dev.Capability.c_str());

  exit(0);
}

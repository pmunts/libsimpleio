// TH02 Temperature/Humidity Sensor Test

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>

#include <i2c-libsimpleio.h>
#include <th02.h>

int main(int argc, char *argv[])
{
  puts("\nTH02 Temperature/Humidity Sensor Test\n");

  if (argc != 2)
  {
    puts("Usage: test_th02 <bus>\n");
    exit(1);
  }

  // Create sensor device object

  Devices::TH02::Device sensor =
    new Devices::TH02::Device_Class(new libsimpleio::I2C::Bus_Class(argv[1]));

  // Display device identification

  printf("Device ID: 0x%02X\n\n", sensor->deviceID());

  // Display temperature and humidity

  for (;;)
  {
    printf("Temperature: %1.1fC  Humidity: %1.1f%%\n",
      sensor->temperature(), sensor->humidity());
    sleep(1);
  }
}

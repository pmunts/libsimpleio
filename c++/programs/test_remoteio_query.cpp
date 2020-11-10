// Remote I/O Device Information Query

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

#include <cstdio>
#include <cstdlib>

#include <hid-libsimpleio.h>
#include <remoteio_client.h>

int main(void)
{
  puts("\nRemote I/O Device Information Query\n");

  libsimpleio::HID::Messenger_Class msg(0x16D0, 0x0AFA);
  RemoteIO::Client::Device_Class dev(&msg);

  printf("Manufacturer:            %s\n", msg.Manufacturer().c_str());
  printf("Product:                 %s\n", msg.Product().c_str());
  printf("Serial Number:           %s\n", msg.SerialNumber().c_str());

  printf("Information:             %s\n", dev.Version.c_str());
  printf("Capabilities:            %s\n", dev.Capability.c_str());

  if (!dev.ADC_Inputs.empty())
  {
    printf("Found ADC inputs:       ");

    for (auto channel : dev.ADC_Inputs)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.DAC_Outputs.empty())
  {
    printf("Found DAC outputs:      ");

    for (auto channel : dev.DAC_Outputs)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.GPIO_Pins.empty())
  {
    printf("Found GPIO pins:        ");

    for (auto channel : dev.GPIO_Pins)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.I2C_Buses.empty())
  {
    printf("Found I2C buses:        ");

    for (auto channel : dev.I2C_Buses)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.PWM_Outputs.empty())
  {
    printf("Found PWM outputs:      ");

    for (auto channel : dev.PWM_Outputs)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.SPI_Slaves.empty())
  {
    printf("Found SPI slave devices:");

    for (auto channel : dev.SPI_Slaves)
      printf(" %d", channel);

    putchar('\n');
  }

  if (!dev.Abstract_Devices.empty())
  {
    printf("Found abstract devices: ");

    for (auto channel : dev.Abstract_Devices)
      printf(" %d", channel);

    putchar('\n');
  }

  exit(0);
}

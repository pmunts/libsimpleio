// Remote I/O PWM Output Test

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

#include <chrono>
#include <cstdio>
#include <cstring>
#include <thread>

#include <pwm-interface.h>
#include <hid-hidapi.h>
#include <remoteio-client.h>
#include <remoteio-pwm.h>

int main(void)
{
  puts("\nRemote I/O PWM Output Test\n");

  hidapi::HID::Messenger_Class msg(0x16D0, 0x0AFA);
  RemoteIO::Client::Device_Class dev(&msg);

  printf("Enter PWM channel number:  ");
  fflush(stdout);

  char buf[256];
  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  unsigned chan = atoi(buf);

  printf("Enter PWM pulse frequency: ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  unsigned freq = atoi(buf);

  // Create a PWM output object

  Interfaces::PWM::Output outp =
    new RemoteIO::PWM::Output_Class(&dev, chan, freq, 100.0);

  // Sweep the pulse width back and forth

  puts("\nPress CONTROL-C to exit.\n");

  int n;

  for (;;)
  {
    for (n = 0; n <= 100; n++)
    {
      *outp = double(n);
      std::this_thread::sleep_for(std::chrono::milliseconds(50));
    }

    for (n = 100; n >= 0; n--)
    {
      *outp = double(n);
      std::this_thread::sleep_for(std::chrono::milliseconds(50));
    }
  }
}

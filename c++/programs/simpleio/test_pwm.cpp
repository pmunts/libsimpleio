// PWM Output using libsimpleio Test

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

#include <pwm-libsimpleio.h>

int main(void)
{
  puts("\nPWM Output Test using libsimpleio\n");

  char buf[256];
  unsigned chip, chan, freq;

  printf("Enter PWM chip number:     ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chip = atoi(buf);

  printf("Enter PWM channel number:  ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chan = atoi(buf);

  printf("Enter PWM pulse frequency: ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  freq = atoi(buf);

  // Create a PWM output object

  Interfaces::PWM::Output PWM0 =
    new libsimpleio::PWM::Output_Class(chip, chan, freq);

  // Sweep the pulse width back and forth

  puts("\nPress CONTROL-C to exit.\n");

  int n;

  for (;;)
  {
    for (n = 0; n <= 100; n++)
    {
      *PWM0 = double(n);
      usleep(50000);
    }

    for (n = 100; n >= 0; n--)
    {
      *PWM0 = double(n);
      usleep(50000);
    }
  }
}

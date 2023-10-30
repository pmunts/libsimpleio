// Motor output test using two PWM outputs (CW and CCW)

// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

#include <motor-pwm.h>
#include <pwm-libsimpleio.h>

int main(void)
{
  puts("\nMotor Output Test using libsimpleio\n");

  char buf[256];
  unsigned chipCW, chanCW, chipCCW, chanCCW;

  printf("Enter PWM chip number:    ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chipCW = atoi(buf);

  printf("Enter PWM channel number: ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chanCW = atoi(buf);

  printf("Enter PWM chip number:    ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chipCCW = atoi(buf);

  printf("Enter PWM channel number: ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chanCCW = atoi(buf);

  // Create PWM and motor objects

  Interfaces::PWM::Output PWM0 =
    new libsimpleio::PWM::Output_Class(chipCW, chanCW, 100);

  Interfaces::PWM::Output PWM1 =
    new libsimpleio::PWM::Output_Class(chipCCW, chanCCW, 100);

  Interfaces::Motor::Output Motor0 =
    new Motor::PWM::Output_Class(PWM0, PWM1);

  // Sweep the motor velocity up and down

  puts("\nPress CONTROL-C to exit.\n");

  int n;

  for (;;)
  {
    for (n = -100; n <= 100; n++)
    {
      *Motor0 = double(n/100.0);
      usleep(50000);
    }

    for (n = 100; n >= -100; n--)
    {
      *Motor0 = double(n/100.0);
      usleep(50000);
    }
  }
}

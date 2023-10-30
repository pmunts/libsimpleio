// LED Toggle Test using PWM Output

// Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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
#include <cstdlib>
#include <cstring>
#include <thread>

#include <gpio-pwm.h>
#include <pwm-libsimpleio.h>

int main(void)
{
  puts("\nLED Toggle Test using PWM Output\n");

  char buf[256];
  unsigned chip, chan, freq;
  double duty;

  printf("Enter PWM chip number:       ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chip = atoi(buf);

  printf("Enter PWM channel number:    ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  chan = atoi(buf);

  printf("Enter PWM pulse frequency:   ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  freq = atoi(buf);

  printf("Enter PWM output duty cycle: ");
  fflush(stdout);

  memset(buf, 0, sizeof(buf));
  fgets(buf, sizeof(buf), stdin);

  duty = atof(buf);

  // Create a PWM output object

  Interfaces::PWM::Output PWM0 =
    new libsimpleio::PWM::Output_Class(chip, chan, freq);

  // Create a GPIO output pin object

  Interfaces::GPIO::Pin LED =
    new GPIO::PWM::Pin_Class(PWM0, false, duty);

  // Flash the LED

  for (;;)
  {
    *LED = !*LED;
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
  }
}

// GPIO Button and LED Test using libsimpleio

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
#include <unistd.h>

#include <gpio-interface.h>
#include <gpio-libsimpleio.h>

int main(void)
{
  puts("\nGPIO Button and LED Test using libsimpleio\n");

  // Configure GPIO pins for a button input and an LED output

  Interfaces::GPIO::Pin Button =
    new libsimpleio::GPIO::Pin_Class(0, 6, Interfaces::GPIO::INPUT);

  Interfaces::GPIO::Pin LED =
    new libsimpleio::GPIO::Pin_Class(0, 26, Interfaces::GPIO::OUTPUT);

  bool newstate;
  bool oldstate;

  // Force state detection

  oldstate = !*Button;

  puts("Press CONTROL-C to exit...\n");

  for (;;)
  {
    newstate = *Button;

    if (newstate != oldstate)
    {
      puts(newstate ? "PRESSED" : "RELEASED");
      *LED = newstate;
      oldstate = newstate;
    }
  }
}

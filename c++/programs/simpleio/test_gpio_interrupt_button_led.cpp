// GPIO Interrupt Button and LED Test using libsimpleio

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
  puts("\nGPIO Interrupt Button and LED Test using libsimpleio\n");

  // Configure GPIO pins for a button input and an LED output

  Interfaces::GPIO::Pin Button =
    new libsimpleio::GPIO::Pin_Class(0, 10, GPIO_DIRECTION_INPUT, false,
    GPIO_DRIVER_PUSHPULL, GPIO_POLARITY_ACTIVEHIGH, GPIO_EDGE_BOTH);

  Interfaces::GPIO::Pin LED =
    new libsimpleio::GPIO::Pin_Class(0, 26, GPIO_DIRECTION_OUTPUT);

  // Process state transitions

  puts("Press CONTROL-C to exit...\n");

  for (;;)
    switch (*Button)
    {
      case true :
        puts("PRESSED");
        *LED = true;
        break;

      case false :
        puts("RELEASED");
        *LED = false;
        break;
    }
}

// AB Electronics ADC Pi Zero Test

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
#include <unistd.h>

#include <watchdog-libsimpleio.h>

int main(void)
{
  int i;

  puts("\nWatchdog Timer Test\n");

  // Create watchdog timer device instance

  Interfaces::Watchdog::Timer wd = new libsimpleio::Watchdog::Timer_Class();

  // Display default watchdog timeout period

  printf("Default timeout: %d\n", wd->GetTimeout());

  // Change the watchdog timeout period

  wd->SetTimeout(5);

  printf("New timeout:     %d\n\n", wd->GetTimeout());

  // Kick the dog for 5 seconds

  for (i = 0; i < 5; i++)
  {
    puts("Kick the dog...");
    wd->Kick();
    sleep(1);
  }

  putchar('\n');

  // Stop kicking the dog

  for (i = 0; i < 10; i++)
  {
    puts("Don't kick the dog...");
    sleep(1);
  }
}

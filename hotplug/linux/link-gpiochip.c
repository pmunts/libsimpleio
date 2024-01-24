// Find Raspberry Pi GPIO device node

// Copyright (C)2024, Philip Munts.
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

#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <libsimpleio/libgpio.h>

static void Try(int chip, const char *s)
{
  char name[256];
  char label[256];
  int32_t lines;
  int32_t error;
  char cmdbuf[4096];

  memset(name, 0, sizeof(name));
  memset(label, 0, sizeof(label));

  GPIO_chip_info(chip, name, sizeof(name), label, sizeof(label), &lines, &error);
  if (error) return;

  if (!strcasecmp(label, s))
  {
    memset(cmdbuf, 0, sizeof(cmdbuf));
    snprintf(cmdbuf, sizeof(cmdbuf)-1, "ln -s -f %s /dev/gpiochip-rpi", name);
    system(cmdbuf);
    exit(0);
  }
}

void main(void)
{
  int32_t chip;

  for (chip = 0 ; chip < 100 ; chip++)
  {
    Try(chip, "pinctrl-bcm2835"); // Raspberry Pi 1, 2, 3
    Try(chip, "pinctrl-bcm2711"); // Raspberry Pi 4
    Try(chip, "pinctrl-rp1");     // Raspberry Pi 5
  }
}

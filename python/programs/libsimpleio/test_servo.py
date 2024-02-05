#! /usr/bin/python3

# Servo Output Test using libsimpleio

# Copyright (C)2024, Philip Munts.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import libsimpleio.servo
import libsimpleio.raspberrypi
import time

from libsimpleio.common import irange

print("\nServo Output Test using libsimpleio\n")

# Create a Servo output object instance

outp = libsimpleio.servo.Output(libsimpleio.raspberrypi.PWM0)

# Sweep the servo back and forth

for pos in irange(0, 100, 1):       # Neutral to maximum
  outp.position = float(pos/100.0)
  time.sleep(0.05)

for pos in irange(100, -100, -1):   # Maximum to minimum
  outp.position = float(pos/100.0)
  time.sleep(0.05)

for pos in irange(-100, 0, 1):      # Minimum back to neutral
  outp.position = float(pos/100.0)
  time.sleep(0.05)

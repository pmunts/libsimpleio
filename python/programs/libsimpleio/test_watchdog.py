#! /usr/bin/python3

# Watchdog Timer Test using libsimpleio

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

import libsimpleio.watchdog
import time

def irange(start, end, incr = 1):
  if incr > 0:
    return range(start, end + 1, incr)
  if incr < 0:
    return range(start, end - 1, incr)

print("\nWatchdog Timer Test using libsimpleio\n")

# Create a watchdog timer device object

wd = libsimpleio.watchdog.Timer()

# Display the default watchdog timeout period

print("Default timeout: " + str(wd.timeout))

# Change the watchdog timeout period to 5 seconds

wd.timeout = 5

print("New timeout:     " + str(wd.timeout))

# Kick the watchdog timer for 5 seconds

print()

for tick in irange(1, 5):
  print("Kick the dog...")
  wd.Kick()
  time.sleep(1.0)

# Don't kick the watchdog timer anymore

print()

for tick in irange(1, 10):
  print("Don't kick the dog...")
  time.sleep(1.0)

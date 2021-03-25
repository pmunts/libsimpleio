#!/usr/bin/python3

# Python Remote I/O Protocol LED Test

# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

import ctypes
import os
import time

print("\nPython Remote I/O Protocol LED Test\n")

# Select the OS appropriate shared library file

if os.name == 'nt':
  libremoteio = ctypes.cdll.LoadLibrary(os.environ.get("LIBSIMPLEIO") + "/win/win64/libremoteio.dll")
elif os.name == 'posix':
  libremoteio = ctypes.cdll.LoadLibrary("/usr/local/lib/libremoteio.so")

# Declare some variables

handle   = ctypes.c_int()
error    = ctypes.c_int()
channels = ctypes.create_string_buffer(128)
state    = ctypes.c_int()

# Open USB Raw HID Remote I/O Protocol Server

libremoteio.open(0x16D0, 0x0AFA, "".encode(encoding='UTF-8'), 1000, ctypes.byref(handle), ctypes.byref(error))

if error.value != 0:
  print("ERROR: open() failed, error=" + str(error.value))
  quit()

# Probe available GPIO pins

libremoteio.gpio_channels(handle, channels, ctypes.byref(error))

if error.value != 0:
  print("ERROR: gpio_channels() failed, error=" + str(error.value))
  quit()

print('Available GPIO channels: ', end='')

for c in range(len(channels)):
  if channels[c] == b'\x01':
    print(c, end=' ')

print()

# Configure GPIO0 as an output

libremoteio.gpio_configure(handle, 0, 1, 0, ctypes.byref(error))

if error.value != 0:
  print("ERROR: gpio_configure() failed, error=" + str(error.value))
  quit()

# Toggle GPIO0

while True:
  libremoteio.gpio_read(handle, 0, ctypes.byref(state), ctypes.byref(error))

  if error.value != 0:
    print("ERROR: gpio_read() failed, error=" + str(error.value))
    quit()

  state.value ^= 1

  libremoteio.gpio_write(handle, 0, state, ctypes.byref(error))

  if error.value != 0:
    print("ERROR: gpio_write() failed, error=" + str(error.value))
    quit()

  time.sleep(0.5)

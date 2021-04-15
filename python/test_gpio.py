#!/usr/bin/python3

# Python Remote I/O Protocol GPIO Toggle Test

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

print('\nPython Remote I/O Protocol GPIO Toggle Test\n')

# Select the OS appropriate shared library file

if os.name == 'nt':
  libremoteio = ctypes.cdll.LoadLibrary(os.environ.get('LIBSIMPLEIO') + '/win/win64/libremoteio.dll')
elif os.name == 'posix':
  libremoteio = ctypes.cdll.LoadLibrary('/usr/local/lib/libremoteio.so')

# Declare some C library interface variables

handle    = ctypes.c_int()
error     = ctypes.c_int()
mask      = ctypes.create_string_buffer(128)
direction = ctypes.create_string_buffer(128)
state     = ctypes.create_string_buffer(128)

# Open USB Raw HID Remote I/O Protocol Server

libremoteio.open(0x16D0, 0x0AFA, None, 1000, ctypes.byref(handle), ctypes.byref(error))

if error.value != 0:
  print('ERROR: open() failed, error=' + str(error.value))
  quit()

# Probe available GPIO pins

channels = ctypes.create_string_buffer(128)

libremoteio.gpio_channels(handle, channels, ctypes.byref(error))

if error.value != 0:
  print('ERROR: gpio_channels() failed, error=' + str(error.value))
  quit()

# Convert byte array to set

pins = set()

for c in range(len(channels)):
  if channels[c] == b'\x01':
    pins.add(c)

del channels

print('Available GPIO pin channels: ' + str(pins))
print()

# Configure all GPIO pins as outputs initially off

for c in pins:
  mask[c]      = b'\x01'
  direction[c] = b'\x01'
  state[c]     = b'\x00'

libremoteio.gpio_configure_all(handle, mask, direction, state, ctypes.byref(error))

if error.value != 0:
  print('ERROR: gpio_configure_all() failed, error=' + str(error.value))
  quit()

# Toggle all GPIO outputs

print('Toggling all GPIO outputs')
print()

while True:
  libremoteio.gpio_read_all(handle, mask, state, ctypes.byref(error))

  if error.value != 0:
    print('ERROR: gpio_read_all() failed, error=' + str(error.value))
    quit()

  for c in pins:
    if state[c] == b'\x01':
      state[c] = b'\x00'
    else:
      state[c] = b'\x01'

  libremoteio.gpio_write_all(handle, mask, state, ctypes.byref(error))

  if error.value != 0:
    print('ERROR: gpio_write_all() failed, error=' + str(error.value))
    quit()

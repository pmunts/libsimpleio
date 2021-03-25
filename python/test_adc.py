#!/usr/bin/python3

# Python Remote I/O Protocol Analog Input Test

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

print("\nPython Remote I/O Protocol Analog Input Test\n")

# Select the OS appropriate shared library file

if os.name == 'nt':
  libremoteio = ctypes.cdll.LoadLibrary(os.environ.get("LIBSIMPLEIO") + "/win/win64/libremoteio.dll")
elif os.name == 'posix':
  libremoteio = ctypes.cdll.LoadLibrary("/usr/local/lib/libremoteio.so")

# Declare some variables

handle      = ctypes.c_int()
error       = ctypes.c_int()
channels    = ctypes.create_string_buffer(128)
resolution  = ctypes.c_int()
sample      = ctypes.c_int()

# Open USB Raw HID Remote I/O Protocol Server

libremoteio.open(0x16D0, 0x0AFA, "".encode(encoding='UTF-8'), 1000, ctypes.byref(handle), ctypes.byref(error))

if error.value != 0:
  print("ERROR: open() failed, error=" + str(error.value))
  quit()

# Probe available ADC channels

libremoteio.adc_channels(handle, channels, ctypes.byref(error))

if error.value != 0:
  print("ERROR: adc_channels() failed, error=" + str(error.value))
  quit()

print('Available ADC channels: ', end='')

for c in range(len(channels)):
  if channels[c] == b'\x01':
    print(c, end=' ')

print()

# Configure ADC1

libremoteio.adc_configure(handle, 1, ctypes.byref(resolution), ctypes.byref(error))

if error.value != 0:
  print("ERROR: adc_configure() failed, error=" + str(error.value))
  quit()

print("Resolution: " + str(resolution.value) + " bits")

# Read from ADC1

while True:
  libremoteio.adc_read(handle, 1, ctypes.byref(sample), ctypes.byref(error))

  if error.value != 0:
    print("ERROR: adc_read() failed, error=" + str(error.value))
    quit()

  print(sample.value)

  time.sleep(1.0)

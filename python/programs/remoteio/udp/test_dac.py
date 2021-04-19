#!/usr/bin/python3

# Python Remote I/O Protocol Analog Output Test

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

print('\nPython Remote I/O Protocol Analog Output Test\n')

# Select the OS appropriate shared library file

if os.name == 'nt':
  libremoteio = ctypes.cdll.LoadLibrary(os.environ.get('LIBSIMPLEIO') + '/win/win64/libremoteio.dll')
elif os.name == 'posix':
  libremoteio = ctypes.cdll.LoadLibrary('/usr/local/lib/libremoteio.so')

# Declare some C library interface variables

handle      = ctypes.c_int()
error       = ctypes.c_int()
resolution  = ctypes.c_int()

# Open Remote I/O Protocol Server

libremoteio.open_udp('usbgadget.munts.net'.encode(), 8087, 1000, ctypes.byref(handle), ctypes.byref(error))

if error.value != 0:
  print('ERROR: open_udp() failed, error=' + str(error.value))
  quit()

# Display version information

vers = ctypes.create_string_buffer(64)

libremoteio.get_version(handle, vers, len(vers), ctypes.byref(error))

if error.value != 0:
  print('ERROR: get_version() failed, error=' + str(error.value))
  quit()

print(vers.raw.decode())

# Display capabilities

caps = ctypes.create_string_buffer(64)

libremoteio.get_capability(handle, caps, len(caps), ctypes.byref(error))

if error.value != 0:
  print('ERROR: get_capability() failed, error=' + str(error.value))
  quit()

print(caps.raw.decode())
print()

# Probe available DAC channels

channels    = ctypes.create_string_buffer(128)

libremoteio.dac_channels(handle, channels, ctypes.byref(error))

if error.value != 0:
  print('ERROR: dac_channels() failed, error=' + str(error.value))
  quit()

# Convert byte array to set

dacoutputs = set()

for c in range(len(channels)):
  if channels[c] == b'\x01':
    dacoutputs.add(c)

del channels

print('Available DAC output channels: ' + str(dacoutputs))
print()

# Configure DAC output

outp = list(dacoutputs)[0]

libremoteio.dac_configure(handle, outp, ctypes.byref(resolution), ctypes.byref(error))

if error.value != 0:
  print('ERROR: dac_configure() failed, error=' + str(error.value))
  quit()

print('Resolution: ' + str(resolution.value) + ' bits')
print()

# Write to DAC output

while True:
  for s in range(2**resolution.value):
    libremoteio.dac_write(handle, outp, s, ctypes.byref(error))

    if error.value != 0:
      print('ERROR: dac_write() failed, error=' + str(error.value))
      quit()

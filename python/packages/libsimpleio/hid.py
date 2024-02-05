# Raw HID (Human Interface Device) Services

# Copyright (C)2024, Philip Munts dba Munts Technologies
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

__author__	= "Philip Munts <phil@munts.net>"

import ctypes
import errno
import enum
import select

from libsimpleio.common import libsimpleio

##############################################################################

# Raw HID device class

class Device:

  # Constructor

  def __init__(self, VID, PID, serial):
    if serial == None:
      sernum = None
    else:
      sernum = ctypes.c_char_p(serial.encode("ascii"))

    error  = ctypes.c_int()
    fd     = ctypes.c_int()

    libsimpleio.HIDRAW_open3(VID, PID, sernum, ctypes.byref(fd),
      ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "HIDRAW_open() failed")

    # Save instance file descriptor

    self.__fd__   = fd.value

    # Save a polling object

    self.__poll__ = select.poll()

  # Send a 64-byte report

  def Send(self, outbuf):
    error = ctypes.c_int()
    count = ctypes.c_int()

    libsimpleio.HIDRAW_send(self.__fd__, bytes(outbuf), 64,
      ctypes.byref(count), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "HIDRAW_send() failed")

    return count.value == 64

  # Receive a 64-byte report
 
  def Receive(self, inbuf, timeoutms = 0):
    sinbuf = ctypes.create_string_buffer(bytes(inbuf), 64)
    error  = ctypes.c_int()
    count  = ctypes.c_int()

    if timeoutms > 0:
      self.__poll__.register(self.__fd__, select.POLLIN)
      result = self.__poll__.poll(timeoutms)

      if not result:
        return False;
      elif result[0] != (self.__fd__, select.POLLIN):
        return False

    libsimpleio.HIDRAW_receive(self.__fd__, sinbuf, 64, ctypes.byref(count),
      ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "HIDRAW_receive() failed")

    if count.value != 64:
      raise IOError(errno.EIO, "HIDRAW_receive() returned less than 64 bytes")

    inbuf[:] = sinbuf.raw
    return True

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

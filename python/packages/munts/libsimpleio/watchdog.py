# Watchdog Timer Services

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

__author__	= "Philip Munts <phil@munts.net>"

import ctypes
import munts.interfaces.watchdog

from munts.libsimpleio.common import libhandle

##############################################################################

class Timer(munts.interfaces.watchdog.TimerInterface):

  # Constructor

  def __init__(self, devname = "/dev/watchdog", timeout = 0):
    fd      = ctypes.c_int()
    error   = ctypes.c_int()

    # Open the watchdog timer device

    libhandle.WATCHDOG_open(ctypes.c_char_p(devname.encode("ascii")),
      ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "WATCHDOG_open() failed")

    self.__fd__  = fd.value

    # Set timeout, if requested

    if timeout != 0:
      self.timeout = timeout

  # Timeout getter

  @property
  def timeout(self):
    nsecs = ctypes.c_int()
    error = ctypes.c_int()

    libhandle.WATCHDOG_get_timeout(self.__fd__, ctypes.byref(nsecs),
      ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "WATCHDOG_get_timeout() failed")

    return nsecs.value

  # Timeout setter

  @timeout.setter
  def timeout(self, T):
    timeout_requested = ctypes.c_int(T)
    timeout_actual    = ctypes.c_int()
    error             = ctypes.c_int()

    libhandle.WATCHDOG_set_timeout(self.__fd__, timeout_requested,
      ctypes.byref(timeout_actual), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "WATCHDOG_set_timeout() failed")

  # Method: Kick the dog

  def Kick(self):
    error   = ctypes.c_int()

    libhandle.WATCHDOG_kick(self.__fd__, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "WATCHDOG_kick() failed")

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

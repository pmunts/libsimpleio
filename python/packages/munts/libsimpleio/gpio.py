# GPIO (General Purpose Input Output) Pin Services

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
import enum

from munts.interfaces.gpio    import Direction
from munts.interfaces.gpio    import Interface
from munts.libsimpleio.common import libhandle

##############################################################################

# Public enumeration types

Driver    = enum.Enum("Driver", ["PushPull", "OpenDrain", "OpenSource"])
Edge      = enum.Enum("Edge", ["Neither", "Rising", "Falling", "Both"])
Polarity  = enum.Enum("Polarity", ["ActiveHigh", "ActiveLow"])

# Private ioctl() constants

_LINE_REQUEST_INPUT       = 0x0001
_LINE_REQUEST_OUTPUT      = 0x0002
_LINE_REQUEST_ACTIVE_HIGH = 0x0000
_LINE_REQUEST_ACTIVE_LOW  = 0x0004
_LINE_REQUEST_PUSH_PULL   = 0x0000
_LINE_REQUEST_OPEN_DRAIN  = 0x0008
_LINE_REQUEST_OPEN_SOURCE = 0x0010

_EVENT_REQUEST_NONE       = 0x0000
_EVENT_REQUEST_RISING     = 0x0001
_EVENT_REQUEST_FALLING    = 0x0002
_EVENT_REQUEST_BOTH       = 0x0003

# Private enumeration types

__Kinds__ = enum.Enum("__Kinds__", ["Unconfigured", "Input", "Output", "Interrupt"])

##############################################################################

# GPIO pin class

class Pin(Interface):

# Constructor

  def __init__(self, desg, direction, state = False, driver = Driver.PushPull,
               edge = Edge.Neither, polarity = Polarity.ActiveHigh):
    chip   = desg[0]
    line   = desg[1]
    flags  = 0
    events = 0

    if direction == Direction.Input:
      self.__kind__ = __Kinds__.Input
      flags += _LINE_REQUEST_INPUT

    if direction == Direction.Output:
      self.__kind__ = __Kinds__.Output
      flags += _LINE_REQUEST_OUTPUT

    if driver == Driver.PushPull:
      flags += _LINE_REQUEST_PUSH_PULL

    if driver == Driver.OpenDrain:
      flags += _LINE_REQUEST_OPEN_DRAIN

    if driver == Driver.OpenSource:
      flags += _LINE_REQUEST_OPEN_SOURCE

    if polarity == Polarity.ActiveHigh:
      flags += _LINE_REQUEST_ACTIVE_HIGH

    if polarity == Polarity.ActiveLow:
      flags += _LINE_REQUEST_ACTIVE_LOW

    if edge == Edge.Neither:
      events += _EVENT_REQUEST_NONE

    if edge == Edge.Rising:
      __kind__ = __Kinds__.Interrupt
      events += _EVENT_REQUEST_RISING

    if edge == Edge.Falling:
      __kind__ = __Kinds__.Interrupt
      events += _EVENT_REQUEST_FALLING

    if edge == Edge.Both:
      __kind__ = __Kinds__.Interrupt
      events += _EVENT_REQUEST_BOTH

    fd    = ctypes.c_int()
    error = ctypes.c_int()

    libhandle.GPIO_line_open(chip, line, flags, events, state,
      ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "GPIO_line_open() failed")

    self.__fd__ = fd.value

# Logic state property getter

  @property
  def state(self):
    value = ctypes.c_int()
    error = ctypes.c_int()

    if self.__kind__ == __Kinds__.Interrupt:
      libhandle.GPIO_line_event(self.__fd__, ctypes.byref(value), ctypes.byref(error))

      if error.value != 0:
        raise IOError(error.value, "GPIO_line_event() failed")
    else:
      libhandle.GPIO_line_read(self.__fd__, ctypes.byref(value), ctypes.byref(error))

      if error.value != 0:
        raise IOError(error.value, "GPIO_line_read() failed")

    return value.value

# Logic state property setter

  @state.setter
  def state(self, value):
    error = ctypes.c_int()

    if self.__kind__ != __Kinds__.Output:
      raise IOError("Cannot write to an input pin")

    libhandle.GPIO_line_write(self.__fd__, value, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "GPIO_line_write() failed")

# File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

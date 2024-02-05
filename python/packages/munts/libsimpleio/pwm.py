# PWM (Pulse Width Modulated) Output Services

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

from munts.interfaces.pwm     import MINIMUM_DUTYCYCLE
from munts.interfaces.pwm     import MAXIMUM_DUTYCYCLE
from munts.libsimpleio.common import libhandle

##############################################################################

# Public enumeration types

Polarity  = enum.Enum("Polarity", ["ActiveLow", "ActiveHigh"], start=0)

##############################################################################

# PWM output class

class Output:

  # Constructor

  def __init__(self, designator, frequency, dutycycle = MINIMUM_DUTYCYCLE,
               polarity = Polarity.ActiveHigh):
    if dutycycle < MINIMUM_DUTYCYCLE or dutycycle > MAXIMUM_DUTYCYCLE:
      raise IO_Error(errno.EINVAL, "Duty cycle is out of range")

    if frequency < 50:
      raise IO_Error(errno.EINVAL, "Frequency is out of range")

    chip    = int(designator[0])
    channel = int(designator[1])
    period  = int(1.0E9/frequency) # nanoseconds
    ontime  = int(dutycycle/MAXIMUM_DUTYCYCLE*period) # nanoseconds
    error   = ctypes.c_int()
    fd      = ctypes.c_int()

    # Configure the PWM output.  Note that if the PWM controller has multiple
    # channels, they often share the same PWM pulse frequency and therefore
    # share the same period.  If you configure different frequencies for
    # different channels on the same PWM controller, they will all share the
    # same PWM pulse frequency, the last one configured.

    libhandle.PWM_configure(chip, channel, period, ontime, polarity.value,
      ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_configure() failed")

    # Open the PWM output device

    libhandle.PWM_open(chip, channel, ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_open() failed")

    # Save to private fields

    self.__fd__     = fd.value
    self.__period__ = period
    self.__duty__   = dutycycle

  # Duty cycle property getter

  @property
  def dutycycle(self):
    return self.__duty__

  # Duty cycle property setter

  @dutycycle.setter
  def dutycycle(self, value):
    if value < MINIMUM_DUTYCYCLE or value > MAXIMUM_DUTYCYCLE:
      raise IO_Error(errno.EINVAL, "Duty cycle is out of range")

    ontime  = int(value/MAXIMUM_DUTYCYCLE*self.__period__) # nanoseconds
    error   = ctypes.c_int()

    libhandle.PWM_write(self.__fd__, ontime, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_write() failed")

    self.__duty__ = value

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

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

from munts.interfaces.servo   import MINIMUM_POSITION
from munts.interfaces.servo   import MAXIMUM_POSITION
from munts.interfaces.servo   import NEUTRAL_POSITION
from munts.libsimpleio.common import libhandle

##############################################################################

# Servo output class

class Output:

  # Constructor

  def __init__(self, designator, frequency = 50, position = NEUTRAL_POSITION):
    if position < MINIMUM_POSITION or position > MAXIMUM_POSITION:
      raise IO_Error(errno.EINVAL, "Position is out of range")

    if frequency < 50:
      raise IO_Error(errno.EINVAL, "Frequency is out of range")

    chip    = int(designator[0])
    channel = int(designator[1])
    period  = int(1.0E9/frequency) # nanoseconds
    ontime  = int(1500000.0 + 500000.0*position) # nanoseconds
    error   = ctypes.c_int()
    fd      = ctypes.c_int()

    # Configure the PWM output.  Note that if the PWM controller has multiple
    # channels, they often share the same PWM pulse frequency and therefore
    # share the same period.  If you configure different frequencies for
    # different channels on the same PWM controller, they will all share the
    # same PWM pulse frequency, the last one configured.

    libhandle.PWM_configure(chip, channel, period, ontime, 1,
      ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_configure() failed")

    # Open the PWM output device

    libhandle.PWM_open(chip, channel, ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_open() failed")

    # Save to private fields

    self.__fd__       = fd.value
    self.__period__   = period
    self.__position__ = position

  # Position property getter

  @property
  def position(self):
    return self.__position__

  # Position property setter

  @position.setter
  def position(self, value):
    if value < MINIMUM_POSITION or value > MAXIMUM_POSITION:
      raise IO_Error(errno.EINVAL, "Position is out of range")

    ontime = int(1500000.0 + 500000.0*value) # nanoseconds
    error  = ctypes.c_int()

    libhandle.PWM_write(self.__fd__, ontime, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "PWM_write() failed")

    self.__position__ = value

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

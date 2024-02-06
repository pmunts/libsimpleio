# Analog Input Services

# Copyright (C)2024, Philip Munts dba Munts Technologies.
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

import munts.interfaces.adc

from munts.libsimpleio.common import libhandle

##############################################################################

# PWM output class

class Input(munts.interfaces.adc.AnalogInputInterface):

  # Constructor

  def __init__(self, designator, resolution, Vref, signed = False):
    chip    = int(designator[0])
    channel = int(designator[1])
    fd      = ctypes.c_int()
    error   = ctypes.c_int()

    libhandle.ADC_open(chip, channel, ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "ADC_open() failed")

    # Save to private fields

    self.__fd__         = fd.value
    self.__resolution__ = resolution

    if signed:
      self.__stepsize__ = Vref/2.0**(resolution-1)
    else:
      self.__stepsize__ = Vref/2.0**(resolution)

  # Raw sample property getter

  @property
  def sample(self):
    sample = ctypes.c_int()
    error  = ctypes.c_int()
   
    libhandle.ADC_read(self.__fd__, ctypes.byref(sample), ctypes.byref(error))
 
    if error.value != 0:
      raise IOError(error.value, "ADC_read() failed")

    return sample.value

  # Voltage property getter

  @property
  def voltage(self):
    return self.sample*self.__stepsize__

  # Resolution property getter

  @property
  def resolution(self):
    return self.__resolution__

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

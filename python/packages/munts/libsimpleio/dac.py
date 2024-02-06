# Analog Output Services

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
import math

import munts.interfaces.dac

from munts.libsimpleio.common import libhandle

##############################################################################

# Analog output class

class Output(munts.interfaces.dac.AnalogOutputInterface):

  # Constructor

  def __init__(self, designator, resolution, Vref, signed = False):
    chip    = int(designator[0])
    channel = int(designator[1])
    fd      = ctypes.c_int()
    error   = ctypes.c_int()

    libhandle.DAC_open(chip, channel, ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "DAC_open() failed")

    # Save to private fields

    self.__fd__         = fd.value
    self.__resolution__ = resolution
    self.__sample__     = 0
    self.sample         = 4095

    if signed:
      self.__stepsize__ = float(Vref)/2.0**(resolution-1)
    else:
      self.__stepsize__ = float(Vref)/2.0**(resolution)

  # Raw sample property getter

  @property
  def sample(self):
    return self.__sample__

  # Raw sample property setter

  @sample.setter
  def sample(self, S):
    sample = ctypes.c_int()
    error  = ctypes.c_int()

    libhandle.DAC_write(self.__fd__, int(S), ctypes.byref(error))
 
    if error.value != 0:
      raise IOError(error.value, "DAC_write() failed")

    self.__sample__ = S

  # Voltage property getter

  @property
  def voltage(self, V):
    return self.__sample__*self.__stepsize__

  # Voltage property setter

  @voltage.setter
  def voltage(self, V):
    self.sample = int(math.floor(float(V)/self.__stepsize__))

  # Resolution property getter

  @property
  def resolution(self):
    return self.__resolution__

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

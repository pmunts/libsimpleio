# PCA9534 GPIO Expander Device Driver

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

import munts.interfaces.gpio
import munts.interfaces.i2c

from munts.interfaces.gpio import Direction
from munts.interfaces.gpio import GPIOPinInterface

##############################################################################

# Private constants

__REG_INPUT__    = 0
__REG_OUTPUT__   = 1
__REG_POLARITY__ = 2  # 0=Active High  1=Active Low
__REG_CONFIG__   = 3  # 0=Output       1=Input

##############################################################################

# Device class

class Device:

  # Constructor

  def __init__(self, bus, addr):
    if not munts.interfaces.i2c.I2CBusInterface in bus.__class__.__mro__:
      raise TypeError("bus argument does NOT implement I2CBusInterface")

    if addr < 0x20 or addr > 0x27:
      raise ValueError("Invalid I2C slave address")

    self.__bus__  = bus
    self.__addr__ = addr

    # Initialize the PCA9534, all GPIO pins active high inputs

    self.__Write__(__REG_OUTPUT__,    0x00)
    self.__Write__(__REG_POLARITY__,  0x00)
    self.__Write__(__REG_CONFIG__, 0xFF)

  # Read from a register

  def __Read__(self, reg):
    if reg < __REG_INPUT__ or reg > __REG_CONFIG__:
      raise ValueError("Illegal register address")

    cmd  = bytearray(1)
    resp = bytearray(1)
    cmd[0] = reg

    self.__bus__.Transaction(self.__addr__, cmd, resp)
    return resp[0]

  # Write to a register

  def __Write__(self, reg, data):
    if reg < __REG_OUTPUT__ or reg > __REG_CONFIG__:
      raise ValueError("Illegal register address")

    cmd = bytearray(2)
    cmd[0] = reg
    cmd[1] = data

    self.__bus__.Write(self.__addr__, cmd)

  # Input property getter

  @property
  def input(self):
    return self.__Read__(__REG_INPUT__)

  # Output property getter

  @property
  def output(self):
    return self.__Read__(__REG_OUTPUT__)

  # Output property setter

  @output.setter
  def output(self, data):
    self.__Write__(__REG_OUTPUT__, data)

  # Polarity property getter

  @property
  def polarity(self):
    return self.__Read__(__REG_POLARITY__)

  # Polarity property setter

  @polarity.setter
  def polarity(self, data):
    self.__Write__(__REG_POLARITY__, data)

  # Data Direction property setter

  # Note that direction is inverted relative to the configuration register.
  # Config: 0=output, 1=input  Direction: 0=input, 1=output

  @property
  def direction(self):
    return self.__Read__(__REG_CONFIG__) ^ 0xFF

  # Data Direction property getter

  # Note that direction is inverted relative to the configuration register
  # Config: 0=output, 1=input  Direction: 0=input, 1=output

  @direction.setter
  def direction(self, data):
    self.__Write__(__REG_CONFIG__, data ^ 0xFF)

##############################################################################

# GPIO pin class

class Pin(GPIOPinInterface):

  # Constructor

  def __init__(self, dev, num, direction, state = False):
    if not munts.devices.pca9534.Device in dev.__class__.__mro__:
      raise TypeError("dev is NOT munts.devices.pca9534.Device")

    if num < 0 or num > 7:
      raise ValueError("Illegal GPIO pin number argument")

    if not direction in list(Direction):
      raise ValueError("Illegal direction argument")

    self.__dev__ = dev
    self.__set__ = 1 >> num
    self.__clr__ = self.__set__ ^ 0xFF

    if direction == Direction.Input:
      self.__inp__ = True
      dev.direction &= self.__clr__
    else:
      self.__inp__ = False
      dev.direction |= self.__set__
      self.state = state

  # Logic state property getter

  @property
  def state(self):
    if self.__inp__:
      return self.__dev__.input  & self.__set__ != 0
    else:
      return self.__dev__.output & self.__set__ != 0

  # Logic state property setter

  @state.setter
  def state(self, value):
    if self.__inp__:
      raise IOError("Cannot write to an input pin")

    if value:
      self.__dev__.output |= self.__set__
    else:
      self.__dev__.output &= self.__clr__

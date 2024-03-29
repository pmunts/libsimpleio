# Type 2 Motor Driver: 2 PWM outputs for clockwise and counterclockwise
# rotation.  Both the PWM output and GPIO output must be fully configured

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

import munts.interfaces.motor
import munts.interfaces.pwm

from munts.interfaces.motor import MAXIMUM_VELOCITY
from munts.interfaces.motor import MINIMUM_VELOCITY
from munts.interfaces.motor import STOPPED_VELOCITY
from munts.interfaces.pwm   import MAXIMUM_DUTYCYCLE

##############################################################################

# Motor driver output class

class Output(munts.interfaces.motor.MotorOutputInterface):

  # Constructor

  def __init__(self, clockwise, counterclockwise, velocity = STOPPED_VELOCITY):
    if not munts.interfaces.pwm.PWMOutputInterface in clockwise.__class__.__mro__:
      raise TypeError("clockwise argument does NOT implement PWMOutputInterface ")

    if not munts.interfaces.pwm.PWMOutputInterface in counterclockwise.__class__.__mro__:
      raise TypeError("counterclockwise argument does NOT implement PWMOutputInterface ")

    if velocity < MINIMUM_VELOCITY or velocity > MAXIMUM_VELOCITY:
      raise ValueError("Velocity is out of range")

    self.__cw__       = clockwise
    self.__ccw__      = counterclockwise
    self.__velocity__ = STOPPED_VELOCITY

    # Set initial velocity

    self.velocity = velocity

  # Velocity property getter

  @property
  def velocity(self):
    return self.__velocity__

  # Velocity property setter

  @velocity.setter
  def velocity(self, value):
    if value < MINIMUM_VELOCITY or value > MAXIMUM_VELOCITY:
      raise ValueError("Velocity is out of range")

    if value > STOPPED_VELOCITY:
      # Nominal forward rotation
      self.__ccw__.dutycycle = 0.0
      self.__cw__.dutycycle  = abs(value*MAXIMUM_DUTYCYCLE)
    elif value < STOPPED_VELOCITY:
      # Nominal reverse rotation
      self.__cw__.dutycycle  = 0.0
      self.__ccw__.dutycycle = abs(value*MAXIMUM_DUTYCYCLE)
    else:
      # Stopped
      self.__cw__.dutycycle  = 0.0
      self.__ccw__.dutycycle = 0.0

    self.__velocity__ = value

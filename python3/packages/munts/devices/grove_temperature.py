# Grove Temperature (thermistor) Module v1.2 Device Driver

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

# https://wiki.seeedstudio.com/Grove-Temperature_Sensor_V1.2 with NTC
# thermistor type NCP18WF104F03RC

__author__	= "Philip Munts <phil@munts.net>"

import munts.devices.thermistor
import munts.interfaces.adc
import munts.interfaces.temperature

class Sensor(munts.interfaces.temperature.TemperatureSensorInterface):

  # Constructor

  def __init__(self, Volts):
    if not munts.interfaces.adc.AnalogInputInterface in Volts.__class__.__mro__:
      raise TypeError("Volts argument does NOT implement AnalogInputInterface ")

    self.__Volts__ = Volts
    self.__Model__ = munts.devices.thermistor.Model(B=4250.0, R0=100000.0, T0=25.0)

  # Kelvin temperature property getter

  @property
  def kelvins(self):
    return self.__Model__.Kelvins(3.3*100000/self.__Volts__.voltage - 100000)

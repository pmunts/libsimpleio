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

###############################################################################

# Public constants for percentage duty cycle

MINIMUM_DUTYCYCLE = 0.0    # percent
MAXIMUM_DUTYCYCLE = 100.0  # percent

###############################################################################

# Define an interface (aka abstract base class) for PWM outputs

from abc import ABC, abstractmethod

class PWMOutputInterface(ABC):

  # Duty cycle (0.0 to 100.0%) property getter

  @property
  @abstractmethod
  def dutycycle(self):
    pass

  # Duty cycle (0.0 to 100.0%) property setter

  @dutycycle.setter
  @abstractmethod
  def dutycycle(self, value):
    pass

  # Frequency property getter

  @property
  @abstractmethod
  def frequency(self):
    pass

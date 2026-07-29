# Copyright (C)2026, Philip Munts dba Munts Technologies.
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

from munts.interfaces.pwm      import PWMOutputInterface
from munts.interfaces.remoteio import ServerInterface

class Output(PWMOutputInterface):
    def __init__(self, server, channel, freq = 50, duty = 0.0):

        # Validate arguments

        assert isinstance(server, ServerInterface)
        assert isinstance(channel, int)
        assert channel >= 0 and channel <= 127
        assert isinstance(freq, int)
        assert freq >= 50
        assert isinstance(duty, float)
        assert (duty >= 0.0) and (duty <= 100.0)

        self.__srv__    = server
        self.__chan__   = channel
        self.__freq__   = freq
        self.__period__ = 1000000000 // freq

        # Configure a PWM output

        cmd = bytearray(64)
        cmd[0] = 40
        cmd[2] = self.__chan__
        cmd[3] = (self.__period__ >> 24) & 0xFF
        cmd[4] = (self.__period__ >> 16) & 0xFF
        cmd[5] = (self.__period__ >>  8) & 0xFF
        cmd[6] = (self.__period__ >>  0) & 0xFF
        self.__srv__.transaction(cmd)

        self.dutycycle = duty

    # Duty cycle (0.0 to 100.0%) property getter

    @property
    def dutycycle(self):
        return self.__duty__

    # Duty cycle (0.0 to 100.0%) property setter

    @dutycycle.setter
    def dutycycle(self, value):
        assert isinstance(value, float)

        dutyns = int(value/100.0*self.__period__ + 0.5)

        # Write PWM output duty cycle

        cmd = bytearray(64)
        cmd[0] = 42
        cmd[2] = self.__chan__
        cmd[3] = (dutyns >> 24) & 0xFF
        cmd[4] = (dutyns >> 16) & 0xFF
        cmd[5] = (dutyns >>  8) & 0xFF
        cmd[6] = (dutyns >>  0) & 0xFF
        self.__srv__.transaction(cmd)

        self.__duty__ = value

    # Frequency property getter

    @property
    def frequency(self):
        return self.__freq__

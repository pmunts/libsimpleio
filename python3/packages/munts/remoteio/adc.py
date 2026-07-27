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

from munts.interfaces.adc      import AnalogInputInterface
from munts.interfaces.remoteio import ServerInterface

class Input(AnalogInputInterface):
    def __init__(self, server, channel, Vref = 0.0):

        # Validate arguments

        assert isinstance(server, ServerInterface)
        assert isinstance(channel, int)
        assert channel >= 0 and channel <= 127
        assert isinstance(Vref, float)

        self.__srv__   = server
        self.__chan__  = channel
        self.__Vref__  = Vref

        # Configure an analog input

        cmd = bytearray(64)
        cmd[0] = 28
        cmd[2] = channel

        resp = self.__srv__.transaction(cmd)

        self.__resolution__ = resp[3]
        self.__stepsize__   = Vref/2.0**self.__resolution__

    # Raw sample property getter

    @property
    def sample(self):
        cmd = bytearray(64)
        cmd[0] = 30
        cmd[2] = self.__chan__

        resp = self.__srv__.transaction(cmd)
        return resp[3]*16777216 + resp[4]*65536 + resp[5]*256 + resp[6]

    # Voltage property getter

    @property
    def voltage(self):
        return self.sample*self.__stepsize__

    # Resolution (number of bits) property getter

    @property
    def resolution(self):
        return self.__resolution__

    # Reference voltage property getter

    @property
    def reference(self):
        return self.__Vref__

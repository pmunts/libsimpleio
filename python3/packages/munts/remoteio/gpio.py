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

from munts.interfaces.gpio import Direction, GPIOPinInterface
from munts.remoteio.common import ChannelToByte, ChannelToMask

class Pin(GPIOPinInterface):
    def __init__(self, server, num, direction, state = False):
        self.__srv__   = server
        self.__byte__  = ChannelToByte(num)
        self.__mask__  = ChannelToMask(num)
        self.__isout__ = direction == Direction.Output

        # Configure a GPIO pin

        cmd = bytearray(64)
        cmd[0] = 8
        cmd[2 + self.__byte__] |= self.__mask__

        if self.__isout__:
          cmd[18 + self.__byte__] |= self.__mask__

        self.__srv__.transaction(cmd)

        # Write GPIO output pin initial state

        if self.__isout__:
            self.state = state

    # GPIO pin state getter

    @property
    def state(self):
        cmd = bytearray(64)
        cmd[0] = 10
        cmd[2 + self.__byte__] |= self.__mask__

        resp = self.__srv__.transaction(cmd)

        return (resp[3 + self.__byte__] & self.__mask__) != 0

    # GPIO pin state setter

    @state.setter
    def state(self, value):
        if not self.__isout__:
          raise IOError("Cannot write to GPIO input pin")

        cmd = bytearray(64)
        cmd[0] = 12
        cmd[2 + self.__byte__] |= self.__mask__

        if value:
            cmd[18 + self.__byte__] |= self.__mask__

        self.__srv__.transaction(cmd)

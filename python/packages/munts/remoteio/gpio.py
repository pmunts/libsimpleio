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

import munts.interfaces.remoteio
import munts.interfaces.gpio

class Pin(munts.interfaces.gpio.GPIOPinInterface):
    def __init__(self, server, num, direction, state = False):
        self.__srv__ = server
        self.__num__ = num
        self.__dir__ = direction

        cmd = bytearray(64)
        cmd[0] = 8
        cmd[2 + self.__num__ // 8] |= 7 - self.__num__ % 8

        if direction == munts.interfaces.gpio.Direction.Output:
          cmd[18 + self.__num__ // 8] |= 7 - self.__num__ % 8

        self.__srv__.transaction(cmd)

    # Logic state property getter

    @property
    def state(self):
      cmd = bytearray(64)
      cmd[0] = 10
      cmd[2 + self.__num__ // 8] |= 7 - self.__num__ % 8

      resp = self.__srv__.transaction(cmd)

      return (resp[3 + self.__num__ // 8] & 7 - self.__num__ % 8) != 0

    # Logic state property setter

    @state.setter
    def state(self, value):
      cmd = bytearray(64)
      cmd[0] = 12
      cmd[2 + self.__num__ // 8] |= 7 - self.__num__ % 8

      self.__srv__.transaction(cmd)

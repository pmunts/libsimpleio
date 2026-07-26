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

import zmq

import munts.interfaces.remoteio

class Server(munts.interfaces.remoteio.ServerInterface):
    def __init__(self, hostname, port):
        self.__context__ = zmq.Context()
        self.__socket__  = self.__context__.socket(zmq.REQ)
        self.__socket__.connect("tcp://" + hostname + ":" + str(port))
        self.__seq__ = 0

        cmd  = bytearray(64)

        # Fetch server version string

        cmd[0] = 2
        resp = self.transaction(cmd)
        self.__version__ = resp[3:].decode("utf-8").strip("\0")

        # Fetch server capability string

        cmd[0] = 4
        resp = self.transaction(cmd)
        self.__capability__ = resp[3:].decode("utf-8").strip("\0")

    # Execute a Remote I/O Protocol transaction

    def transaction(self, cmd, timeout = 1000):
        self.__seq__ = (self.__seq__ + 113) % 256
        cmd[1] = self.__seq__

        self.__socket__.send(cmd)

        # Poll for received data available.

        if self.__socket__.poll(timeout, zmq.POLLIN) == 0:
            raise IOError("poll() timed out")

        resp = self.__socket__.recv()

        # Check for errors

        if resp[0] != cmd[0] + 1:
            raise IOError("Message type mismatch")

        if resp[1] != cmd[1]:
            raise IOError("Message number mismatch")

        if resp[2] != 0:
            raise IOError("Remote I/O operation failed, error " + str(resp[2]))

        return resp

    # Fetch channels present
    def __GetChannels__(self, capstring):
        CommandBytes = {
          "ADC"    : 26,
          "DAC   " : 32,
          "DEVICE" : 44,
          "GPIO"   : 6,
          "I2C"    : 14,
          "PWM"    : 38,
          "SPI"    : 20,
        }

        if capstring in self.__capability__:
            cmd    = bytearray(64)
            cmd[0] = CommandBytes[capstring]
            resp   = self.transaction(cmd)

            return munts.remoteio.common.ChannelsToSet(resp)
        else:
            return set()

    # version string property

    @property
    def version(self):
        return self.__version__

    # capability string property

    @property
    def capability(self):
        return self.__capability__

    # Channels present properties

    @property
    def ADC_Channels(self):
      return self.__GetChannels__("ADC");

    @property
    def DAC_Channels(self):
      return self.__GetChannels__("DAC");

    @property
    def DEVICE_Channels(self):
      return self.__GetChannels__("DEVICE");

    @property
    def GPIO_Channels(self):
      return self.__GetChannels__("GPIO");

    @property
    def I2C_Channels(self):
      return self.__GetChannels__("I2C");

    @property
    def PWM_Channels(self):
      return self.__GetChannels__("PWM");

    @property
    def SPI_Channels(self):
      return self.__GetChannels__("SPI");

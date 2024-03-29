# SPI Slave Device (/dev/spidevxx) Services

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

import ctypes

import munts.interfaces.spi

from munts.libsimpleio.common import libhandle

##############################################################################

# Public constants

AUTOCS = -1  # Hardware or otherwise automatically configured slave select

##############################################################################

# SPI slave device class

class Device(munts.interfaces.spi.SPIDeviceInterface):

  # Constructor

  def __init__(self, designator, mode, wordsize, speed, csfd = AUTOCS):
    chip    = int(designator[0])
    channel = int(designator[1])
    error   = ctypes.c_int(0)
    fd      = ctypes.c_int()

    # Open designated SPI slave device node

    devname = "/dev/spidev%d.%d" % (chip, channel)

    libhandle.SPI_open(ctypes.c_char_p(devname.encode("ascii")), mode,
      wordsize, speed, ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "SPI_open() failed")

    # Save instance file descriptor

    self.__fd__   = fd.value
    self.__csfd__ = csfd

  # Write/Read transaction

  def Transaction(self, outbuf = None, delayus = 0, inbuf = None):
    if inbuf != None:
      sinbuf = ctypes.create_string_buffer(bytes(inbuf), len(inbuf))
      size   = len(inbuf)
    else:
      sinbuf = None
      size   = 0

    error   = ctypes.c_int()

    libhandle.SPI_transaction(self.__fd__, self.__csfd__, bytes(outbuf),
      len(outbuf), delayus, sinbuf, size, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "SPI_transaction() failed")

    if inbuf != None:
      inbuf[:] = sinbuf.raw

# File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

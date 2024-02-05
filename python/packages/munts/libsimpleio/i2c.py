# I2C Bus Services

# Copyright (C)2024, Philip Munts dba Munts Technologies
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

from munts.libsimpleio.common import libhandle

##############################################################################

# I2C bus class

class Bus:
  __fds__ = {}

  # Constructor

  def __init__(self, designator):
    chip    = int(designator[0])
    bus     = int(designator[1])
    error   = ctypes.c_int(0)
    fd      = ctypes.c_int()

    # Validate parameters

    if chip != 0:
      raise ValueError("Illegal chip number")

    if bus < 0:
      raise ValueError("Illegal bus number")

    # See if requested I2C bus device node is already open, and return the
    # saved file descriptor if it is.

    if bus in Bus.__fds__:
      fd.value = Bus.__fds__[bus]
      return

    # Open designated I2C device node

    devname = "/dev/i2c-%d" % bus

    libhandle.I2C_open(ctypes.c_char_p(devname.encode("ascii")),
      ctypes.byref(fd), ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "I2C_open() failed")

    # Save instance file descriptor

    self.__fd__  = fd.value

    # Save file descriptor in classwide dictionary

    Bus.__fds__[bus] = fd.value

  # Perform Write/Read transaction

  def Transaction(self, addr, cmd, resp):
    if addr < 0x00:
      raise ValueError("Invalid I2C device address")

    if addr > 0x7F:
      raise ValueError("Invalid I2C device address")

    if cmd == None:
      scmd     = None
      scmdlen  = 0
    else:
      scmd     = bytes(cmd)
      scmdlen  = len(cmd)

    if resp == None:
      sresp    = None
      sresplen = 0
    else:
      sresp    = ctypes.create_string_buffer(bytes(resp), len(resp))
      sresplen = len(resp)

    error  = ctypes.c_int()

    libhandle.I2C_transaction(self.__fd__, addr, scmd, scmdlen, sresp,
      sresplen, ctypes.byref(error))

    if error.value != 0:
      raise IOError(error.value, "I2C_transaction() failed")

    if resp != None:
      resp[:] = sresp.raw

  # Read data from I2C device
 
  def Read(self, addr, resp):
    self.Transaction(addr, None, resp)

  # Write data to I2C device

  def Write(self, addr, cmd):
    self.Transaction(addr, cmd, None)

  # File descriptor property getter

  @property
  def fd(self):
    return self.__fd__

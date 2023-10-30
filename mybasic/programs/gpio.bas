' GPIO pin wrapper class

' Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
'
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
'
' * Redistributions of source code must retain the above copyright notice,
'   this list of conditions and the following disclaimer.
'
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
' ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
' LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
' CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
' SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
' INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
' CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
' ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
' POSSIBILITY OF SUCH DAMAGE.

class GPIO_Pin
  var myfd = -1

  'dir   : 0=input, 1=output
  'state : 0=off/low, 1=on/high

  def Open(chip, channel, dir, state)
    myfd = libsimpleio.gpio_open(chip, channel, dir, state)
  enddef

  def Close()
    libsimpleio.gpio_close(myfd)
    myfd = -1
  enddef

  'Returns : 0=off/low, 1=on/high

  def Read()
    return libsimpleio.gpio_read(myfd)
  enddef

  'state : 0=off/low, 1=on/high

  def Write(state)
    libsimpleio.gpio_write(myfd, state)
  enddef
endclass

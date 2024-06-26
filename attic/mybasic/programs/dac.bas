' DAC output wrapper class

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

class DAC_Output
  var mynumsteps = -1
  var mystepsize = -1
  var myfd       = -1

  ' resolution : D/A converter resolution in bits
  ' reference  : D/A converter full scale voltage in volts

  def Open(chip, channel, resolution, reference)
    mynumsteps = 2^resolution
    mystepsize = reference/2.0^resolution
    myfd       = libsimpleio.dac_open(chip, channel)
  enddef

  def Close()
    libsimpleio.dac_close(myfd)
    mynumsteps = -1
    mystepsize = -1
    myfd       = -1
  enddef

  def Write(V)
    sample = V/mystepsize

    if sample < 0 then
      sample = 0
    endif

    if sample >= mynumsteps then
      sample = mynumsteps - 1
    endif

    libsimpleio.dac_write(myfd, sample)
  enddef
endclass

' Servo output wrapper class

' Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

class Servo_Output
  var myperiod = -1
  var myfd     = -1

  ' freq     : PWM pulse frequency in Hz
  ' position : Normalized servo position (-1.0 to +1.0)

  def Open(chip, channel, freq, position)
    myperiod = 1000000000/freq
    ontime = 1500000 + round(500000.0*position)
    myfd = pwm_open(chip, channel, myperiod, ontime)
  enddef

  def Close()
    pwm_close(myfd)
    myperiod = -1
    myfd     = -1
  enddef

  ' position : Normalized servo position (-1.0 to +1.0)

  def Write(position)
    ontime = 1500000 + round(500000.0*position)
    pwm_write(myfd, ontime)
  enddef
endclass

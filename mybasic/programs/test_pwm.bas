' PWM Output Test

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

import "pwm.bas"

print "PWM Output Test";;

' Get test parameters

print "Enter PWM chip number:     "
input chip


print "Enter PWM channel number:  "
input channel

print "Enter PWM pulse frequency: "
input freq

' Open the PWM output

PWM0 = new(PWM_Output)
PWM0.Open(chip, channel, freq, 0.0)

' Write to the PWM output

while true
  print "Increasing duty cycle...";

  for duty = 0.0 to 100.0 step 0.1
    PWM0.Write(duty)
    delay(5000)
  next duty

  print "Decreasing duty cycle...";

  for duty = 100.0 to 0.0 step -0.1
    PWM0.Write(duty)
    delay(5000)
  next duty
wend

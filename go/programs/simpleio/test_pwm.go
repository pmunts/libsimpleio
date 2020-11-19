// PWM Output Test

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package main

import (
  "fmt"
  "time"
  "munts.com/interfaces/PWM"
  "munts.com/objects/Error"
  "munts.com/objects/simpleio/Designator"
  "munts.com/objects/simpleio/PWM_libsimpleio"
)

func main() {
  fmt.Printf("\nPWM Output Test\n\n")

  var chip int32
  fmt.Printf("Enter PWM chip number:      ")
  fmt.Scanln(&chip)

  var channel int32
  fmt.Printf("Enter PWM channel number:   ")
  fmt.Scanln(&channel)

  var freq PWM.Frequency
  fmt.Printf("Enter PWM output frequency: ")
  fmt.Scanln(&freq)

  // Configure a PWM output

  var outp PWM.Output
  var err error

  outp, err = PWM_libsimpleio.New(Designator.Designator { chip, channel }, freq,
    PWM.MinimumDutyCycle, PWM_libsimpleio.ActiveHigh)
  Error.Exit(err, "NewOutput() failed")

  // Sweep the PWM output duty cycle

  var d int

  for {
    for d = 0; d <= 100; d++ {
      outp.Put(PWM.DutyCycle(d))
      time.Sleep(50000000)
    }

    for d = 100; d >= 0; d-- {
      outp.Put(PWM.DutyCycle(d))
      time.Sleep(50000000)
    }
  }
}

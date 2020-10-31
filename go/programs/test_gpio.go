// GPIO Output Toggle Test

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
  "munts.com/libsimpleio/Designator"
  "munts.com/interfaces/GPIO"
  GPIO_libsimpleio "munts.com/libsimpleio/GPIO"
)

func main() {
  fmt.Printf("\nGPIO Output Toggle Test\n\n")

  var chip uint
  fmt.Printf("Enter GPIO chip number:    ")
  fmt.Scanln(&chip)

  var channel uint
  fmt.Printf("Enter GPIO channel number: ")
  fmt.Scanln(&channel)

  // Configure a GPIO output

  var err error
  var outp GPIO.Pin

  outp, err = GPIO_libsimpleio.NewPin(Designator.Create(chip, channel),
    GPIO.Output, false, GPIO_libsimpleio.PushPull, GPIO_libsimpleio.None,
    GPIO_libsimpleio.ActiveHigh)

  if err != nil {
    fmt.Printf("\nGPIO_libsimpleio.NewPin() failed, %v\n\n", err)
    return
  }

  // Toggle the GPIO output

  for {
    outp.Put(true)
    outp.Put(false)
  }
}

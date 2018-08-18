//  GPIO Interrupt Button and LED Test using libsimpleio

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

using System;
using System.Threading;

namespace test_gpio_button_led
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\n GPIO Interrupt Button and LED Test using libsimpleio\n");

      // Create GPIO pin objects

      IO.Interfaces.GPIO.Pin Button =
        new IO.Objects.libsimpleio.GPIO.Pin(0, 19,
          IO.Interfaces.GPIO.Direction.Input, false,
          IO.Objects.libsimpleio.GPIO.Pin.Driver.PushPull,
          IO.Objects.libsimpleio.GPIO.Pin.Edge.Both);

      IO.Interfaces.GPIO.Pin LED =
        new IO.Objects.libsimpleio.GPIO.Pin(0, 26,
          IO.Interfaces.GPIO.Direction.Output, false);

      // Main event loop

      for (;;)
      {
        if (Button.state)
        {
          Console.WriteLine("PRESSED");
          LED.state = true;
        }
        else
        {
          Console.WriteLine("RELEASED");
          LED.state = false;
        }
      }
    }
  }
}

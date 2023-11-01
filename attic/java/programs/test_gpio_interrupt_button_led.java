// GPIO Interrupt Button and LED Test

// Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

import com.munts.interfaces.GPIO.*;
import com.munts.libsimpleio.objects.GPIO.*;

public class test_gpio_interrupt_button_led
{
  public static void main(String args[])
  {
    Builder b;

    System.out.println("\nGPIO Interrupt Button and LED Test\n");

    // Configure button and LED GPIO's

    b = new Builder(0, 6);
    b.SetDirection(Direction.Input);
    b.SetInterrupt(Edge.Both);
    Pin Button = b.Create();

    b = new Builder(0, 26);
    b.SetDirection(Direction.Output);
    Pin LED = b.Create();

    System.out.println("Press CONTROL-C to exit...\n");

    // Process state transitions

    for (;;)
      if (Button.read())
      {
        System.out.println("PRESSED");
        LED.write(true);
      }
      else
      {
        System.out.println("RELEASED");
        LED.write(false);
      }
  }
}

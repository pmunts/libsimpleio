// LED Test using libsimpleio

// Copyright (C)2026, Philip Munts dba Munts Technologies.
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
import com.munts.libsimpleio.platforms.RaspberryPi;

public class test_led
{
  public static void main(String args[])
  {
    Builder b;
    boolean oldstate;
    boolean newstate;

    System.out.println("\nLED Test using libsimpleio\n");

    // Configure LED

    b = new Builder(RaspberryPi.GPIO26);
    b.SetDirection(Direction.Output);
    Pin LED = b.Create();

    System.out.println("Press CONTROL-C to exit...\n");

    for (;;)
    {
      LED.write(!LED.read());

      try
      {
        Thread.sleep(500);
      }
      catch (Exception e)
      {
      }
    }
  }
}

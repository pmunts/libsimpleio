// PWM Output Test using libsimpleio

// Copyright (C)2017-2026, Philip Munts dba Munts Technologies.
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

import com.munts.interfaces.PWM.*;
import com.munts.libsimpleio.objects.PWM.*;

public class test_pwm
{
  public static void main(String args[]) throws InterruptedException
  {
    System.out.println("\nPWM Output Test using libsimpleio\n");

    if (args.length != 3)
    {
      System.out.println("Usage: java -jar test_pwm.jar " +
        "<chip number> <line number> <frequency>\n");
      System.exit(1);
    }

    int chip = Integer.parseInt(args[0]);
    int line = Integer.parseInt(args[1]);
    int freq = Integer.parseInt(args[2]);

    // Create PWM output instance

    Output PWM0 = new OutputSubclass(chip, line, freq);

    // Sweep the PWM output pulse width back and forth

    int d;

    for (d = 0; d <= 100; d++)
    {
      PWM0.write(d);
      Thread.sleep(50);
    }

    for (d = 100; d >= 0; d--)
    {
      PWM0.write(d);
      Thread.sleep(50);
    }
  }
}

// GPIO Toggle Test using libsimpleio

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

import com.munts.interfaces.GPIO.*;
import com.munts.libsimpleio.objects.Designator;
import com.munts.libsimpleio.objects.GPIO.*;

public class test_gpio
{
  public static void main(String args[])
  {
    System.out.println("\nGPIO Toggle Speed Test using libsimpleio\n");

    if (args.length != 3)
    {
      System.out.println("Usage: java -jar test_gpio.jar " +
        "<chip number> <line number> <iterations>\n");
      System.exit(1);
    }

    int chip = Integer.parseInt(args[0]);
    int line = Integer.parseInt(args[1]);
    int iterations = Integer.parseInt(args[2]);

    Builder b = new Builder(new Designator(chip, line));
    b.SetDirection(Direction.Output);
    Pin p = b.Create();

    System.out.println("Performing " + Integer.toString(iterations) +
      " GPIO writes...\n");

    // Perform GPIO toggle speed test

    long start_time = System.currentTimeMillis();

    for (int i = 0; i < iterations/2; i++)
    {
      p.write(true);
      p.write(false);
    }

    long stop_time = System.currentTimeMillis();

    // Display results

    double deltat = (stop_time - start_time)/1000.0;
    double rate = iterations/deltat;
    double cycletime = deltat/iterations;

    System.out.println("Performed " + Integer.toString(iterations) +
      " in " + String.format("%1.1f", deltat) + " seconds");

    System.out.println("  " + String.format("%1.1f", rate) +
      " iterations per second");

    System.out.println("  " + String.format("%1.1f", cycletime*1E6) +
      " microseconds per iteration\n");
  }
}

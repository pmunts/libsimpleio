// Watchdog Timer Test using libsimpleio

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

import com.munts.interfaces.Watchdog.*;
import com.munts.libsimpleio.objects.Watchdog.*;

public class test_watchdog
{
  public static void main(String args[]) throws InterruptedException
  {
    System.out.println("\nWatchdog Timer Test using libsimpleio\n");

    // Create watchdog timer instance

    Timer wd = new TimerSubclass();

    // Display the default watchdog timeout period

    System.out.println("Default timeout: " +
      Integer.toString(wd.GetTimeout()));

    // Change the watchdog timeout period

    wd.SetTimeout(5);

    System.out.println("New timeout:     " +
      Integer.toString(wd.GetTimeout()) + "\n");

    // Kick the dog for 5 seconds

    for (int i = 0; i < 5; i++)
    {
      System.out.println("Kick the dog...");
      wd.Kick();
      Thread.sleep(1000);
    }

    // Stop kicking the dog

    for (int i = 0; i < 5; i++)
    {
      System.out.println("Don't kick the dog...");
      Thread.sleep(1000);
    }
  }
}

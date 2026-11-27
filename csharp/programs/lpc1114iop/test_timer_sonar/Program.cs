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

using static System.Console;

using IO.Objects.LPC1114IOP.Timer;

WriteLine("\nLPC1114 I/O Processor HC-SR04 SONAR Test\n");

// Open connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Open();

// Configure LPC1114 timer 1 to measure pulse width on CAP0 input

var Timer1 = new Counter(timer_id_t.CT32B1);

Timer1.ConfigurePrescaler(1);

Timer1.ConfigureCapture(capture_edge_t.CAP0_BOTH,
  capture_interrupt_t.DISABLED);
 
Timer1.ConfigureMode(mode_t.PCLK);

// Configure GPIO1 as transmit ping trigger

var Trigger = new IO.Objects.LPC1114IOP.GPIO.Pin
 (IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO1,
  IO.Interfaces.GPIO.Direction.Output);

WriteLine("Press any key to exit\n");

for (;;)
{
  if (KeyAvailable) break;

  // Pulse trigger output

  Trigger.state = true;
  Trigger.state = false;

  // Get echo pulse width result

  var count = Timer1.GetCaptureDelta();

  // Skip zero result (happens at startup, or if no ultrasonic module attached)

  if (count == 0) continue;

  // Calculate distance in millimeters from echo time

  var distance = (int) count/282.35;

  // Display detected distance, if it is sane

  if (distance < 2000)
    WriteLine("Distance is " + distance.ToString("F0") + " mm");

  System.Threading.Thread.Sleep(1000);
}

// Close connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Close();

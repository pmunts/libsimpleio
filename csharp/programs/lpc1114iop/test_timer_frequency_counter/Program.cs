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

WriteLine("\nLPC1114 I/O Processor Frequency Counter Test\n");

// Open connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Open();

// Configure LPC1114 timer 1 to measure pulse width on CAP0 input

var Timer1 = new Counter(timer_id_t.CT32B1);

Timer1.ConfigurePrescaler(1);

Timer1.ConfigureCapture(capture_edge_t.CAP0_RISING,
  capture_interrupt_t.DISABLED);

Timer1.ConfigureMode(mode_t.PCLK);

WriteLine("Press any key to exit\n");

for (;;)
{
  if (KeyAvailable) break;

  var count = Timer1.GetCaptureDelta();
  if (count < 1920) continue;

  var freq = 48000000.0/count + 0.5;

  WriteLine("Frequency: " + freq.ToString("F0"));
  System.Threading.Thread.Sleep(1000);
}

// Close connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Close();

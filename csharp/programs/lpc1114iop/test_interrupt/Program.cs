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

using System.Threading.Tasks;

using static System.Console;
using static System.Threading.Thread;

using IO.Objects.LPC1114IOP.GPIO;
using IO.Objects.LPC1114IOP.Interrupt;

static void InterruptHandlerProc()
{
  // Configure the host computer to handle interrupts
  // from the LPC1114 I/O Processor.

  Handler.Enable();

  // Interrupt handler event loop:

  for (;;)
  {
    interrupt_outcome_t outcome;
    Handler.Wait(5000, out outcome);
    WriteLine(outcome.ToString());
  }
}

WriteLine("\nLPC1114 I/O Processor Interrupt Test\n");

// Open connection to LPC1114 I/O Processor.

IO.Objects.LPC1114IOP.Transport.Open();

// Start a background task to handle interrupts from the LPC1114 I/O
// Processor

Task InterruptHandlerTask = Task.Run(InterruptHandlerProc);

// Configure the LPC1114 I/O Processor to detect a falling edge on GPIO0
// and pulse the interrupt output pin to the host computer.

var IntIn = new Pin(pin_id_t.GPIO0, mode_t.GPIO_MODE_INPUT_PULLUP,
  edge_t.GPIO_INTERRUPT_BOTH);

// Main program event loop follows.
//
// Note that spiagent_interrupt_wait() *DOES NOT BLOCK* the following main
// program code!

WriteLine("Press CONTROL-C to exit\n");

for (;;)
{
  Sleep(1000);
  WriteLine("Tick...");
}

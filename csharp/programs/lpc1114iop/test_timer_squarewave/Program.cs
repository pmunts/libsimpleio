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

WriteLine("\nLPC1114 I/O Processor Square Wave Output Test\n");

if (args.Length != 1)
{
  WriteLine("Usage: test_timer_squarewave <frequency>\n");
  System.Environment.Exit(1);
}

var freq = System.Convert.ToUInt32(args[0]);

// Open connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Open();

// Configure Timer 1 Match output 0 to generate a square wave

var Timer1 = new Counter(timer_id_t.CT32B1);

Timer1.ConfigurePrescaler(1);

Timer1.ConfigureMatch(match_register_t.MATCH0, 24000000/freq,
  match_action_t.TOGGLE, match_interrupt_t.DISABLED,
  match_reset_t.ENABLED, match_stop_t.DISABLED);

Timer1.ConfigureMode(mode_t.PCLK);

// Close connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Close();

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
using static System.Threading.Thread;

using IO.Objects.LPC1114IOP;
using IO.Objects.LPC1114IOP.PWM;

WriteLine("\nLPC1114 I/O Processor PWM Output Test\n");

// Open connection to LPC1114 I/O Processor

Transport.Open();

// Create a PWM output object instance

var outp = new Output(pin_id_t.PWM1, 10000);

// Sweep PWM pulse width back and forth

WriteLine("\nPress CONTROL-C to exit");

for (;;)
{
  int n;

  for (n = 0; n < 100; n++)
  {
    outp.dutycycle = n;
    Sleep(50);
  }

  for (n = 100; n >= 0; n--)
  {
    outp.dutycycle = n;
    Sleep(50);
  }
}

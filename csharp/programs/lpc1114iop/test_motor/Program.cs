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
using IO.Objects.LPC1114IOP.Motor;

WriteLine("\nLPC1114 I/O Processor H-Bridge DC Motor Test\n");

// Open connection to LPC1114 I/O Processor

Transport.Open();

// Set common PWM output pulse frequency

IO.Objects.LPC1114IOP.PWM.Output.frequency = 10000;

// Create a DC motor object instance

var outp = new Output(IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO0,
  IO.Objects.LPC1114IOP.PWM.pin_id_t.PWM1);

// Sweep motor velocity

WriteLine("\nPress CONTROL-C to exit");

for (;;)
{
  for (int n = -100; n < 100; n++)
  {
    outp.velocity = n / 100.0;
    Sleep(50);
  }

  for (int n = 100; n >= -100; n--)
  {
    outp.velocity = n / 100.0;
    Sleep(50);
  }
}

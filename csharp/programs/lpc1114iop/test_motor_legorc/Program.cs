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
using IO.Objects.LPC1114IOP.GPIO;
using IO.Objects.LPC1114IOP.LEGORC;

WriteLine("\nLPC1114 I/O Processor LEGO® Power Functions Remote Control Motor Test\n");

// Open connection to LPC1114 I/O Processor

Transport.Open();

// Create motor object instances

var outpA = new Output(pin_id_t.GPIO7, 1, legorc_motor_id_t.MOTORA, 0.0);
var outpB = new Output(pin_id_t.GPIO7, 1, legorc_motor_id_t.MOTORB, 0.0);

// Sweep motor velocity

for (int v = 1; v <= 7; v++)
{
  outpA.velocity = v / 7.0;
  Sleep(1000);
}

for (int v = 6; v >= -7; v--)
{
  outpA.velocity = v / 7.0;
  Sleep(1000);
}

for (int v = -6; v <= 0; v++)
{
  outpA.velocity = v / 7.0;
  Sleep(1000);
}

for (int v = 1; v <= 7; v++)
{
  outpB.velocity = v / 7.0;
  Sleep(1000);
}

for (int v = 6; v >= -7; v--)
{
  outpB.velocity = v / 7.0;
  Sleep(1000);
}

for (int v = -6; v <= 0; v++)
{
  outpB.velocity = v / 7.0;
  Sleep(1000);
}

// Close connection to LPC1114 I/O Processor

IO.Objects.LPC1114IOP.Transport.Close();

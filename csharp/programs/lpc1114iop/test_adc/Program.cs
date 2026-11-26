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
using IO.Objects.LPC1114IOP.ADC;

WriteLine("\nLPC1114 I/O Processor ADC Input Test\n");

// Open connection to LPC1114 I/O Processor

Transport.Open();

// Create ADC input objects

var AIN1 = new Input(pin_id_t.ADC1);
var AIN2 = new Input(pin_id_t.ADC2);
var AIN3 = new Input(pin_id_t.ADC3);
var AIN4 = new Input(pin_id_t.ADC4);
var AIN5 = new Input(pin_id_t.ADC5);

// Measure ADC input voltages

for (;;)
{
  WriteLine("ADC1 input voltage is " + AIN1.voltage.ToString("F3"));
  WriteLine("ADC2 input voltage is " + AIN2.voltage.ToString("F3"));
  WriteLine("ADC3 input voltage is " + AIN3.voltage.ToString("F3"));
  WriteLine("ADC4 input voltage is " + AIN4.voltage.ToString("F3"));
  WriteLine("ADC5 input voltage is " + AIN5.voltage.ToString("F3"));
  WriteLine();
  Sleep(2000);
}

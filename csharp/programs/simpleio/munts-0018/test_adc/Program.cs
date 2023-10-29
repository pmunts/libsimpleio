// MUNTS-0018 Raspberry Pi Tutorial I/O Board LED Test

// Copyright (C)2023, Philip Munts.
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

using System.Collections.Generic;

#if OrangePiZero2W
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.OrangePiZero2W
#else
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.RaspberryPiZero;
#endif
using static System.Console;
using static System.Threading.Thread;

WriteLine("\nMUNTS-0018 Analog Input Test\n");

// Create a list of analog input objects

var AnalogInputs = new List<IO.Interfaces.ADC.Voltage>();

AnalogInputs.Add(AnalogInputFactory(J10A0));
AnalogInputs.Add(AnalogInputFactory(J10A1));
AnalogInputs.Add(AnalogInputFactory(J11A0));
AnalogInputs.Add(AnalogInputFactory(J11A1));

// Display the analog input voltages

for (;;)
{
  foreach (var V in AnalogInputs)
  {
    Write("{0:0.000}V  ", V.voltage);
  }

  WriteLine();
  Sleep(1000);
}

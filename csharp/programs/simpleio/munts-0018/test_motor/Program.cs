// MUNTS-0018 Raspberry Pi Tutorial I/O Board Motor Driver Test

// Copyright (C)2023, Philip Munts dba Munts Technologies.
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

#if OrangePiZero2W
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.OrangePiZero2W;
#else
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.RaspberryPi;
#endif

WriteLine("\nMUNTS-0018 Motor Driver Test\n");

// Create GPIO pin object for direction signal

var GPIO0 = new IO.Objects.SimpleIO.GPIO.Pin(J6DIR,
    IO.Interfaces.GPIO.Direction.Output);

// Create PWM output object for speed signal

var PWM0 = new IO.Objects.SimpleIO.PWM.Output(J6PWM, 100);

// Create motor object

var Motor0 = new IO.Objects.Motor.PWM.Output(GPIO0, PWM0);

// Sweep motor velocity up and down

WriteLine("Press CONTROL-C to exit");

for (;;)
{
    int n;

    for (n = -100; n < 100; n++)
    {
        Motor0.velocity = n / 100.0;
        Sleep(50);
    }

    for (n = 100; n >= -100; n--)
    {
        Motor0.velocity = n / 100.0;
        Sleep(50);
    }
}

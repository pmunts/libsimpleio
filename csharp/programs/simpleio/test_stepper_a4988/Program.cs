// Test a stepper motor driven with an Allegro A4988 Stepper Motor Driver.

// Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

WriteLine("\nA4988 Stepper Motor Driver Test\n");

// Create STEP signal GPIO pin object

var desg = new IO.Objects.SimpleIO.Device.Designator("Enter STEP signal GPIO pin channel: ");

IO.Interfaces.GPIO.Pin Step_Pin =
    new IO.Objects.SimpleIO.GPIO.Pin(desg,
        IO.Interfaces.GPIO.Direction.Output, false);

// Create DIR signal GPIO pin object

desg = new IO.Objects.SimpleIO.Device.Designator("Enter DIR  signal GPIO pin channel: ");

IO.Interfaces.GPIO.Pin Dir_Pin =
    new IO.Objects.SimpleIO.GPIO.Pin(desg,
        IO.Interfaces.GPIO.Direction.Output, false);

// Get the number of descrete steps the motor under test has

Write("Enter the number of motor steps:    ");
int numsteps = int.Parse(ReadLine());

// Create A4988 device object

IO.Interfaces.Stepper.Output outp =
    new IO.Devices.A4988.Device(numsteps, Step_Pin, Dir_Pin);

WriteLine();

for (;;)
{
    Write("Steps? ");
    int steps = int.Parse(ReadLine());

    Write("Rate?  ");
    float rate = float.Parse(ReadLine());

    outp.Move(steps, rate);
}

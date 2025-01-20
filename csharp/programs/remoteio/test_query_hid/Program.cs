// Raw HID Remote I/O Device Information Query Test

// Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

WriteLine("\nRemote I/O Protocol Client\n");

// Create Remote I/O Protocol server object instance

var msg    = new IO.Objects.Message64.HID.Messenger();
var remdev = new IO.Objects.RemoteIO.Device(msg);

// Query the Remote I/O Protocol server

WriteLine(msg.Info);
WriteLine(remdev.Version);
WriteLine(remdev.Capabilities);
WriteLine();

// Display the available ADC inputs

Write("ADC inputs:  ");

foreach (int input in remdev.ADC_Available())
    Write(input.ToString() + " ");

WriteLine();

// Display the available DAC outputs

Write("DAC outputs: ");

foreach (int output in remdev.DAC_Available())
    Write(output.ToString() + " ");

WriteLine();

// Display the available GPIO pins

Write("GPIO Pins:   ");

foreach (int pin in remdev.GPIO_Available())
    Write(pin.ToString() + " ");

WriteLine();

// Display the available I2C buses

Write("I2C buses:   ");

foreach (int bus in remdev.I2C_Available())
    Write(bus.ToString() + " ");

WriteLine();

// Display the available PWM outputs

Write("PWM outputs: ");

foreach (int bus in remdev.PWM_Available())
    Write(bus.ToString() + " ");

WriteLine();

// Display the available SPI devices

Write("SPI devices: ");

foreach (int bus in remdev.SPI_Available())
    Write(bus.ToString() + " ");

WriteLine();

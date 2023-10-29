// MUNTS-0018 Raspberry Pi Tutorial I/O Board Button and LED Test using tasking

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

using System.Collections.Concurrent;
using System.Threading.Tasks;

using static IO.Objects.SimpleIO.GPIO.Edge;
#if OrangePiZero2W
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.OrangePiZero2W
#else
using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.RaspberryPiZero;
#endif
using static System.Console;
using static System.Threading.Thread;

// Create a message queue for the background task to send state transitions
// to the foreground task.

var mqueue = new BlockingCollection<bool>();

void ButtonHandler()
{
  // Create GPIO pin objects

  var Button = ButtonInputFactory(Both);
  var LED    = LEDOutputFactory(false);

  // button event loop

  for (;;)
  {
    LED.state = Button.state;
    mqueue.Add(LED.state);
  }
}

WriteLine("\nMUNTS-0018 Button and LED Test using tasking\n");

// Spawn background task

var ButtonHandlerTask = Task.Run(ButtonHandler);

// Main event loop

for (;;)
{
  if (mqueue.TryTake(out bool state, 1000))
    WriteLine(state ? "PRESSED" : "RELEASED");
  else
    WriteLine("Tick...");
}

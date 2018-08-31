// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// loopback test program

// Copyright (C)2015-2018, Philip Munts, President, Munts AM Corp.
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

using System;
using System.Diagnostics;

using SPIAgent;

namespace test_spiagent_loopback
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nSPIAgent Loopback Test\n");

      int iterations;
      Stopwatch timer = new Stopwatch();
      SPIAGENT_COMMAND_MSG_t cmd = new SPIAGENT_COMMAND_MSG_t();
      SPIAGENT_RESPONSE_MSG_t resp = new SPIAGENT_RESPONSE_MSG_t();

      if (args.Length != 1)
      {
        Console.WriteLine("Usage: test_spiagent_loopback <iterations>");
        Environment.Exit(1);
      }

      iterations = Int32.Parse(args[0]);

      IO.Remote.Device dev =
        new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

      IO.Interfaces.I2C.Bus bus =
        new IO.Remote.I2C(dev, 0);

      Transport_I2C spiagent = new Transport_I2C(bus);

      // Issue some SPI transactions

      Console.WriteLine("Issuing some SPI transactions...\n");

      // Build command message, with NOP command

      cmd.command = (int)Commands.SPIAGENT_CMD_NOP;
      cmd.pin = 0;
      cmd.data = 0;

      // Issue the command

      spiagent.Command(cmd, ref resp);

      // Display the response from the slave MCU

      Console.WriteLine("Response: command:" + resp.command.ToString().PadRight(4, ' ') + " " +
        "pin:" + resp.pin.ToString().PadRight(4, ' ') + " " +
        "data:" + resp.data.ToString().PadRight(5, ' ') + " " +
        "error" + resp.error.ToString().PadRight(4, ' '));

      // Build command message, with LOOPBACK command

      cmd.command = (int)Commands.SPIAGENT_CMD_LOOPBACK;
      cmd.pin = 2;
      cmd.data = 3;

      // Issue the command

      spiagent.Command(cmd, ref resp);

      // Display the response from the slave MCU

      Console.WriteLine("Response: command:" + resp.command.ToString().PadRight(4, ' ') + " " +
        "pin:" + resp.pin.ToString().PadRight(4, ' ') + " " +
        "data:" + resp.data.ToString().PadRight(5, ' ') + " " +
        "error" + resp.error.ToString().PadRight(4, ' '));

      // Build command message, with illegal pin number

      cmd.command = (int)Commands.SPIAGENT_CMD_GET_GPIO;
      cmd.pin = 99;
      cmd.data = 3;

      // Issue the command

      spiagent.Command(cmd, ref resp);

      // Display the response from the slave MCU

      Console.WriteLine("Response: command:" + resp.command.ToString().PadRight(4, ' ') + " " +
        "pin:" + resp.pin.ToString().PadRight(4, ' ') + " " +
        "data:" + resp.data.ToString().PadRight(5, ' ') + " " +
        "error" + resp.error.ToString().PadRight(4, ' '));

      // Build command message, with illegal command field

      cmd.command = 99;
      cmd.pin = 2;
      cmd.data = 3;

      // Issue the command

      spiagent.Command(cmd, ref resp);

      // Display the response from the slave MCU

      Console.WriteLine("Response: command:" + resp.command.ToString().PadRight(4, ' ') + " " +
        "pin:" + resp.pin.ToString().PadRight(4, ' ') + " " +
        "data:" + resp.data.ToString().PadRight(5, ' ') + " " +
        "error" + resp.error.ToString().PadRight(4, ' '));

      // Query the LPC1114 firmware version

      cmd.command = (int)Commands.SPIAGENT_CMD_NOP;
      cmd.pin = 0;
      cmd.data = 0;

      spiagent.Command(cmd, ref resp);

      if (resp.error != (int)errno.EOK)
      {
        Console.WriteLine("ERROR: The SPI Agent Firmware returned error=" + resp.error.ToString());
        Environment.Exit(1);
      }

      Console.WriteLine("\nThe LPC1114 firmware version is  " + resp.data.ToString());

      // Query the LPC1114 device ID

      cmd.command = (int)Commands.SPIAGENT_CMD_GET_SFR;
      cmd.pin = 0x400483F4;
      cmd.data = 0;

      spiagent.Command(cmd, ref resp);

      if (resp.error != (int)errno.EOK)
      {
        Console.WriteLine("ERROR: The SPI Agent Firmware returned error=" + resp.error.ToString());
        Environment.Exit(1);
      }

      Console.WriteLine("The LPC1114 device ID is         " + resp.data.ToString("X"));

      // Query the expansion board LED state

      cmd.command = (int)Commands.SPIAGENT_CMD_GET_GPIO;
      cmd.pin = Pins.LPC1114_LED;
      cmd.data = 0;

      spiagent.Command(cmd, ref resp);

      if (resp.error != (int)errno.EOK)
      {
        Console.WriteLine("ERROR: The SPI Agent Firmware returned error=" + resp.error.ToString());
        Environment.Exit(1);
      }

      Console.WriteLine("The expansion board LED is       " + ((resp.data == 0) ? "OFF" : "ON") + "\n");

      // Perform SPI loopback commands as fast as possible to stress test the SPI interface

      Console.WriteLine("Starting " + iterations.ToString() + " SPI agent loopback test transactions...\n");

      timer.Start();

      for (int i = 1; i < iterations; i++)
      {
        cmd.command = (int)Commands.SPIAGENT_CMD_LOOPBACK;
        cmd.pin = i * 17;
        cmd.data = i * 19;

        spiagent.Command(cmd, ref resp);

        if ((resp.command != cmd.command) ||
            (resp.pin != cmd.pin) ||
            (resp.data != cmd.data) ||
            (resp.error != (int)errno.EOK))
        {
          Console.WriteLine("Iteration: " + i.ToString().PadRight(6, ' ') + " Response: " +
              "command: " + resp.command.ToString() + " " +
              "pin: " + resp.pin.ToString() + " " +
              "data: " + resp.data.ToString() + " " +
              "error: " + resp.error.ToString());
        }
      }

      timer.Stop();

      // Display statistics

      double duration = timer.ElapsedMilliseconds / 1000.0;
      double rate = iterations / duration;
      double cycletime = duration / iterations * 1.0E6;

      Console.WriteLine("Performed " + iterations.ToString() + " loopback tests in " + duration.ToString("F2") + " seconds");
      Console.WriteLine("  " + rate.ToString("F2") + " iterations per second");
      Console.WriteLine("  " + cycletime.ToString("F2") + " microseconds per iteration\n");
    }
  }
}

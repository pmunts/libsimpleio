// Mikroelektronika Expand2 Click MIKROE-1838 (https://www.mikroe.com/expand-2-click) Services

// Copyright (C)2020-2023, Philip Munts.
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

namespace IO.Devices.ClickBoards.SimpleIO.Expand2
{
    /// <summary>
    /// Encapsulates the Mikroelektronika Expand 2 Click Board.
    /// </summary>
    public class Board
    {
        private readonly IO.Interfaces.GPIO.Pin myrst;
        private readonly IO.Devices.MCP23017.Device mydev;

        /// <summary>
        /// Default I<sup>2</sup>C slave address.
        /// </summary>
        public const int DefaultAddress = 0x20;

        /// <summary>
        /// Constructor for a single Expand 2 click.
        /// </summary>
        /// <param name="socknum">mikroBUS socket number.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Board(int socknum, int addr = DefaultAddress)
        {
            // Create a mikroBUS socket object

            IO.Objects.SimpleIO.mikroBUS.Socket S =
                new IO.Objects.SimpleIO.mikroBUS.Socket(socknum);

            // Configure hardware reset GPIO pin

            myrst = new IO.Objects.SimpleIO.GPIO.Pin(S.RST,
                IO.Interfaces.GPIO.Direction.Output, true);

            // Issue hardware reset

            Reset();

            // Configure I2C bus

            IO.Interfaces.I2C.Bus bus;

            bus = new IO.Objects.SimpleIO.I2C.Bus(S.I2CBus);

            // Configure the MCP23017

            mydev = new IO.Devices.MCP23017.Device(bus, addr);
        }

        /// <summary>
        /// Returns the underlying MCP23017 device object.
        /// </summary>
        public IO.Devices.MCP23017.Device device
        {
            get { return mydev; }
        }

        /// <summary>
        /// Issue hardware reset to the MCP23017.
        /// </summary>
        public void Reset()
        {
            myrst.state = false;
            System.Threading.Thread.Sleep(1);
            myrst.state = true;
        }

        /// <summary>
        /// Factory function for creating GPIO pins.
        /// </summary>
        /// <param name="channel">MCP23017 channel number (0 to 15).</param>
        /// <param name="dir">GPIO pin direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO(int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            return mydev.GPIO_Create(channel, dir, state);
        }
    }
}

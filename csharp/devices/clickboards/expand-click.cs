// Mikroelektronika Expand Click MIKROE-951 (https://www.mikroe.com/expand-click) Services

// Copyright (C)2020-2025, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.ClickBoards.Expand
{
    /// <summary>
    /// Encapsulates the Mikroelektronika Expand Click Board.
    /// </summary>
    public class Board
    {
        private readonly IO.Interfaces.GPIO.Pin RST;
        private readonly IO.Devices.MCP23S17.Device dev;

        /// <summary>
        /// Constructor for a single Expand click.
        /// </summary>
        /// <param name="socket">mikroBUS socket object instance.</param>
        public Board(IO.Interfaces.mikroBUS.Socket socket)
        {
            RST = socket.CreateResetOutput(true);

            // Issue hardware reset

            Reset();

            // Create MCP23S17 device object

            dev = new IO.Devices.MCP23S17.Device(socket.CreateSPIDevice(
                IO.Devices.MCP23S17.Device.SPI_Mode,
                IO.Devices.MCP23S17.Device.SPI_WordSize,
                IO.Devices.MCP23S17.Device.SPI_Frequency));
        }

        /// <summary>
        /// Returns the underlying MCP23S17 device object.
        /// </summary>
        public IO.Devices.MCP23S17.Device device
        {
            get { return dev; }
        }

        /// <summary>
        /// Issue hardware reset to the MCP23S17.
        /// </summary>
        public void Reset()
        {
            RST.state = false;
            System.Threading.Thread.Sleep(1);
            RST.state = true;
        }

        /// <summary>
        /// Factory function for creating GPIO pins.
        /// </summary>
        /// <param name="channel">MCP23S17 channel number (0 to 15).</param>
        /// <param name="dir">GPIO pin direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO(int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            return dev.GPIO_Create(channel, dir, state);
        }
    }
}

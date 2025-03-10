// Mikroelektronika ADAC Click MIKROE-2690 (https://www.mikroe.com/adac-click-click)
// Services

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

namespace IO.Devices.ClickBoards.ADAC
{
    /// <summary>
    /// Encapsulates the Mikroelektronika ADAC Click Board.
    /// <a href="https://www.mikroe.com/adac-click-click">MIKROE-2690</a>.
    /// </summary>
    public class Board
    {
        private readonly IO.Interfaces.GPIO.Pin    RST;
        private readonly IO.Devices.AD5593R.Device dev;

        /// <summary>
        /// Default I<sup>2</sup>C slave address.
        /// </summary>
        public const byte DefaultAddress = 0x10;

        /// <summary>
        /// Constructor for a single ADAC click.
        /// </summary>
        /// <param name="socket">mikroBUS socket object instance.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Board(IO.Interfaces.mikroBUS.Socket socket,
            int addr = DefaultAddress)
        {
            // Configure hardware reset GPIO pin

            RST = socket.CreateResetOutput(true);

            // Issue hardware reset

            Reset();

            // Configure AD5593R

            dev = new IO.Devices.AD5593R.Device(socket.CreateI2CBus(), addr);

            // The ADAC click is wired for 0-5.0V on both ADC and DAC

            dev.ADC_Reference = IO.Devices.AD5593R.ReferenceMode.Internalx2;
            dev.DAC_Reference = IO.Devices.AD5593R.ReferenceMode.Internalx2;
        }

        /// <summary>
        /// Returns the underlying AD5593R device object.
        /// </summary>
        public IO.Devices.AD5593R.Device device
        {
            get
            {
                return dev;
            }
        }

        /// <summary>
        /// Issue hardware reset to the AD5593R.
        /// </summary>
        public void Reset()
        {
            RST.state = false;
            System.Threading.Thread.Sleep(1);
            RST.state = true;
        }

        /// <summary>
        /// Factory function for creating ADC inputs.
        /// </summary>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
        /// <returns>ADC input object.</returns>
        public IO.Interfaces.ADC.Sample ADC(int channel)
        {
            return dev.ADC_Create(channel);
        }

        /// <summary>
        /// Factory function for creating DAC outputs.
        /// </summary>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
        /// <param name="sample">Initial DAC output sample.</param>
        /// <returns>DAC output object.</returns>
        public IO.Interfaces.DAC.Sample DAC(int channel, int sample = 0)
        {
            return dev.DAC_Create(channel, sample);
        }

        /// <summary>
        /// Factory function for creating GPIO pins.
        /// </summary>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
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

// Mikroelektronika PWM Click MIKROE-1898 (https://www.mikroe.com/pwm-click)
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

namespace IO.Devices.ClickBoards.PWM
{
    /// <summary>
    /// Encapsulates the Mikroelektronika PWM Click Board.
    /// <a href="https://www.mikroe.com/pwm-click">MIKROE-1898</a>.
    /// </summary>
    public class Board
    {
        private readonly IO.Devices.PCA9685.Device dev;

        /// <summary>
        /// Default I<sup>2</sup>C slave address.
        /// </summary>
        public const byte DefaultAddress = 0x40;

        /// <summary>
        /// Constructor for a single PWM click.
        /// </summary>
        /// <param name="socket">mikroBUS socket object instance.</param>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Board(IO.Interfaces.mikroBUS.Socket socket, int freq,
            int addr = DefaultAddress)
        {
            dev = new IO.Devices.PCA9685.Device(socket.CreateI2CBus(), addr, freq);
        }

        /// <summary>
        /// Returns the underlying PCA9685 device object.
        /// </summary>
        public IO.Devices.PCA9685.Device device
        {
            get
            {
                return dev;
            }
        }

        /// <summary>
        /// Factory function for creating GPIO output pins.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO output pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO(int channel, bool state = false)
        {
            return new IO.Devices.PCA9685.GPIO.Pin(dev, channel, state);
        }

        /// <summary>
        /// Factory function for creating PWM outputs.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="dutycycle">Initial PWM output duty cycle.</param>
        /// <returns>PWM output object.</returns>
        public IO.Interfaces.PWM.Output PWM(int channel,
            double dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum)
        {
            return new IO.Devices.PCA9685.PWM.Output(dev, channel, dutycycle);
        }

        /// <summary>
        /// Factory function for creating servo outputs.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="position">Initial servo position.></param>
        /// <returns>Servo output object.</returns>
        public IO.Interfaces.Servo.Output Servo(int channel,
            double position = IO.Interfaces.Servo.Positions.Neutral)
        {
            return new IO.Devices.PCA9685.Servo.Output(dev, channel, position);
        }
    }
}

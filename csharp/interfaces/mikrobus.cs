// Abstract interface for a mikroBUS socket

// Copyright (C)2025, Philip Munts dba Munts Technologies.
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

namespace IO.Interfaces.mikroBUS
{
    /// <summary>
    /// Enumeration of mikroBUS socket pin designators.
    /// </summary>
    /// <remarks>
    /// In principle, any of these pins may be used for GPIO.  In practice,
    /// many of them will be configured for special functions and unavailable
    /// for GPIO.
    /// </remarks>
    public enum SocketPins
    {
        /// <summary>
        /// Analog input.
        /// </summary>
        AN,
        /// <summary>
        /// Reset output.
        /// </summary>
        RST,
        /// <summary>
        /// SPI chip select (aka slave select) output.
        /// </summary>
        CS,
        /// <summary>
        /// SPI clock output.
        /// </summary>
        SCK,
        /// <summary>
        /// SPI MISO (Master In / Slave Out) data input.
        /// </summary>
        MISO,
        /// <summary>
        /// SPI MOSI (Master Out / Slave In) data output.
        /// </summary>
        MOSI,
        /// <summary>
        /// I<sup>2</sup>C bus bidirectional data signal.
        /// </summary>
        SDA,
        /// <summary>
        /// I<sup>2</sup>C bus bidirectional clock signal.
        /// </summary>
        SCL,
        /// <summary>
        /// Serial port transmit data output.
        /// </summary>
        TX,
        /// <summary>
        /// Serial port receive data input.
        /// </summary>
        RX,
        /// <summary>
        /// Interrupt input.
        /// </summary>
        INT,
        /// <summary>
        /// PWM (Pulse With Modulated) output.
        /// </summary>
        PWM
    }

    /// <summary>
    /// Abstract interface for mikroBUS sockets.
    /// </summary>
    public interface Socket
    {
        /// <summary>
        /// Create an analog input object instance for a given socket.
        /// </summary>
        /// <returns>Analog input object instance.</returns>
        IO.Interfaces.ADC.Sample CreateAnalogInput();

        /// <summary>
        /// Create a GPIO pin object instance for a given pin of a given socket.
        /// </summary>
        /// <param name="desg">mikroBUS socket pin designator.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <param name="drive">Output drive setting.</param>
        /// <param name="edge">Input edge setting.</param>
        /// <remarks>
        /// Seldom are all of the mikroBUS socket pins available for GPIO.
        /// Usually many of them are configured for other special functions,
        /// including SPI bus, I<sup>2</sup>C bus, PWM output, etc.
        /// </remarks>
        /// <returns>GPIO pin object instance.</returns>
        IO.Interfaces.GPIO.Pin CreateGPIOPin(SocketPins desg,
            IO.Interfaces.GPIO.Direction dir,
            bool state = false,
            IO.Interfaces.GPIO.Drive drive = IO.Interfaces.GPIO.Drive.PushPull,
            IO.Interfaces.GPIO.Edge edge = IO.Interfaces.GPIO.Edge.None);

        /// <summary>
        /// Create a GPIO output pin object instance for the RST pin of a
        /// given socket.
        /// </summary>
        /// <param name="state">Initial state for the reset output.</param>
        /// <param name="drive">Output drive setting.</param>
        /// <returns>GPIO output pin object instance.</returns>
        IO.Interfaces.GPIO.Pin CreateResetOutput(bool state = false,
            IO.Interfaces.GPIO.Drive drive = IO.Interfaces.GPIO.Drive.PushPull);

        /// <summary>
        /// Create a SPI slave device object instance for a given socket.
        /// </summary>
        /// <returns>SPI slave device object instance.</returns>
        /// <param name="mode">SPI transfer mode: 0 to 3.</param>
        /// <param name="wordsize">SPI transfer word size: 8, 16, or 32.</param>
        /// <param name="speed">SPI transfer speed in bits per second.</param>
        IO.Interfaces.SPI.Device CreateSPIDevice(int mode, int wordsize, int speed);

        /// <summary>
        /// Create an I<sup>2</sup>C bus object instance for a given socket.
        /// </summary>
        /// <param name="speed">I<sup>2</sup>C bus clock frequency in Hz.</param>
        /// <returns>I<sup>2</sup>C bus object instance.</returns>
        IO.Interfaces.I2C.Bus CreateI2CBus(int speed = IO.Interfaces.I2C.Speeds.StandardMode);

        /// <summary>
        /// Create a GPIO input pin instance for the INT (interrupt) pin of a
        /// given socket.
        /// </summary>
        /// <param name="edge">Interrupt edge setting.</param>
        /// <returns>GPIO pin instance.</returns>
        IO.Interfaces.GPIO.Pin CreateInterruptInput(
            IO.Interfaces.GPIO.Edge edge = IO.Interfaces.GPIO.Edge.None);

        /// <summary>
        /// Create a PWM (Pulse Width Modulated) output instance for a given
        /// socket.
        /// </summary>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <param name="duty">Initial PWM output duty cycle.</param>
        /// <returns>PWM output instance.</returns>
        IO.Interfaces.PWM.Output CreatePWMOutput(int freq, double duty = IO.Interfaces.PWM.DutyCycles.Minimum);
    }
}

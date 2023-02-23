// MUNTS-0018 Tutoral Board Definitions

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

using IO.Objects.SimpleIO.Device;
using static IO.Objects.SimpleIO.Platforms.RaspberryPi;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This class provides <c>Designator</c>s for I/O resources available on the
    /// <a href="http://tech.munts.com/manuals/MUNTS-0018.pdf">MUNTS-0018</a>
    /// Tutorial I/O Board.
    /// </summary>
    /// <remarks>
    /// The following device tree overlay commands must be added to
    /// <c>/boot/config.txt</c>:
    /// <code>
    /// dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000
    /// dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2
    /// </code>
    /// </remarks>
    public static class MUNTS_0018
    {
        // On board LED

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on-board LED <c>D1</c>.
        /// </summary>
        public static readonly Designator D1 = GPIO26;

        // On board pushbutton switch

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on-board momentary switch
        /// <c>SW1</c>.
        /// </summary>
        public static readonly Designator SW1 = GPIO6;

        // Grove GPIO Connectors

        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J4</c> pin <c>D0</c>.
        /// </summary>
        public static readonly Designator J4D0 = GPIO23;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J4</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J4D1 = GPIO24;

        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J5</c> pin <c>D0</c>.
        /// </summary>
        public static readonly Designator J5D0 = GPIO5;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J5</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J5D1 = GPIO4;

        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin is normally unusable because <c>GPIO12</c> is
        /// mapped to PWM output <c>PWM0</c>.
        /// </remarks>
        public static readonly Designator J6D0 = GPIO12;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J6D1 = GPIO13;

        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin is normally unusable because <c>GPIO19</c> is
        /// mapped to PWM output <c>PWM1</c>.
        /// </remarks>
        public static readonly Designator J7D0 = GPIO19;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J7D1 = GPIO18;

        // Servo headers

        /// <summary>
        /// PWM output <c>Designator</c> for Servo Header <c>J2</c>.
        /// </summary>
        public static readonly Designator J2PWM = PWM0_0;
        /// <summary>
        /// PWM output <c>Designator</c> for Servo Header <c>J3</c>.
        /// </summary>
        public static readonly Designator J3PWM = PWM0_1;

        // DC motor control outputs (PWM and direction)

        /// <summary>
        /// PWM output <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public static readonly Designator J6PWM = PWM0_0;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public static readonly Designator J6DIR = J6D1;

        /// <summary>
        /// PWM output <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public static readonly Designator J7PWM = PWM0_1;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public static readonly Designator J7DIR = J7D1;

        // I2C buses

        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/i2c3</c>
        /// on Digital I/O Grove Connector <c>J5</c>.
        /// </summary>
        /// <remarks>
        /// This optional I<sup>2</sup>C bus is only available on a Raspberry
        /// Pi 4, and only if the following is added to <c>/boot/config.txt</c>:
        /// <code>
        /// dtoverlay=i2c3
        /// </code>
        /// You may also need to install I<sup>2</sup>C bus 4.7K or 10K pull-up
        /// resistors on the MUNTS-0018 Tutorial I/O Board, at positions
        /// <c>R5</c> and <c>R6</c>.
        /// </remarks>
        public static readonly Designator J5I2C = I2C3;
        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/i2c-1</c>
        /// on I<sup>2</sup>C Grove Connector <c>J9</c>.
        /// </summary>
        public static readonly Designator J9I2C = I2C1;

        // Analog inputs (on board MCP3204)

        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J10</c> pin <c>A0</c> (MCP3204 input <c>CH2</c>.
        /// </summary>
        public static readonly Designator J10A0 = new Designator(0, 2);
        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J10</c> pin <c>A1</c> (MCP3204 input <c>CH3</c>.
        /// </summary>
        public static readonly Designator J10A1 = new Designator(0, 3);

        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J11</c> pin <c>A0</c> (MCP3204 input <c>CH0</c>.
        /// </summary>
        public static readonly Designator J11A0 = new Designator(0, 0);
        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J11</c> pin <c>A1</c> (MCP3204 input <c>CH1</c>.
        /// </summary>
        public static readonly Designator J11A1 = new Designator(0, 1);
    }
}

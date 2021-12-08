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

using IO.Objects.libsimpleio.Device;
using static IO.Objects.libsimpleio.Platforms.RaspberryPi;

namespace IO.Objects.libsimpleio.Platforms
{
    /// <summary>
    /// This class provides <c>Designator</c>s for I/O resources available on the
    /// <a href="http://tech.munts.com/manuals/MUNTS-0018.pdf">MUNTS-0018</a>
    /// Tutorial I/O Board.
    /// </summary>
    public static class MUNTS_0018
    {
        // On board LED

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on board LED.
        /// </summary>
        public static readonly Designator D1 = GPIO26;

        // On board pushbutton switch

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on-board push-button
        /// momentary switch.
        /// </summary>
        public static readonly Designator SW1 = GPIO6;

        // Grove GPIO Connectors

        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J4 D0.
        /// </summary>
        public static readonly Designator J4D0 = GPIO23;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J4 D1.
        /// </summary>
        public static readonly Designator J4D1 = GPIO24;

        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J5 D0.
        /// </summary>
        public static readonly Designator J5D0 = GPIO5;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J5 D1.
        /// </summary>
        public static readonly Designator J5D1 = GPIO4;

        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J6 D0.
        /// </summary>
        /// <remarks>
        /// This Raspberry Pi I/O pin is normally mapped to <c>PWM0</c>
        /// and cannot be used for GPIO.
        /// </remarks>
        public static readonly Designator J6D0 = GPIO12;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J6 D1.
        /// </summary>
        public static readonly Designator J6D1 = GPIO13;

        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J7 D0.
        /// </summary>
        /// <remarks>
        /// This Raspberry Pi I/O pin is normally mapped to <c>PWM1</c>
        /// and cannot be used for GPIO.
        /// </remarks>
        public static readonly Designator J7D0 = GPIO19;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Grove Connector J70 D1.
        /// </summary>
        public static readonly Designator J7D1 = GPIO18;

        // Servo headers

        /// <summary>
        /// PWM output <c>Designator</c> at servo header J2.
        /// </summary>
        public static readonly Designator J2PWM = PWM0_0;
        /// <summary>
        /// PWM output <c>Designator</c> at servo header J3.
        /// </summary>
        public static readonly Designator J3PWM = PWM0_1;

        // DC motor control outputs (PWM and direction)

        /// <summary>
        /// PWM output <c>Designator</c> at Grove Connector J6 D0.
        /// </summary>
        /// <remarks>
        /// This is the <b>speed</b> output for DC motor control.
        /// </remarks>
        public static readonly Designator J6PWM = J2PWM;
        /// <summary>
        /// GPIO <c>Designator</c> at Grove Connector J6 D1.
        /// </summary>
        /// <remarks>
        /// This is the <b>direction</b> output for DC motor control.
        /// </remarks>
        public static readonly Designator J6DIR = J6D1;

        /// <summary>
        /// PWM output <c>Designator</c> at Grove Connector J7 D0.
        /// </summary>
        /// <remarks>
        /// This is the <b>speed</b> output for DC motor control.
        /// </remarks>
        public static readonly Designator J7PWM = J3PWM;
        /// <summary>
        /// GPIO <c>Designator</c> at Grove Connector J7 D1.
        /// </summary>
        /// <remarks>
        /// This is the <b>direction</b> output for DC motor control.
        /// </remarks>
        public static readonly Designator J7DIR = J7D1;

        // I2C buses

        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/i2c3</c>
        /// on J5.
        /// </summary>
        /// <remarks>
        /// This optional I<sup>2</sup>C bus is only available on a Raspberry
        /// Pi 4, and only if the following is added to <c>config.txt</c>:
        /// <code>
        /// dtoverlay=i2c3
        /// </code>
        /// You may also need to install I<sup>2</sup>C bus pull-up resistors
        /// (4.7 K) at positions <c>R5</c> and <c>R6</c>.
        /// </remarks>
        public static readonly Designator J5I2C = I2C3;
        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/-i2c1</c>
        /// on J9.
        /// </summary>
        /// <remarks>
        /// This is the normal Raspberry Pi I<sup>2</sup>C bus.
        /// </remarks>
        public static readonly Designator J9I2C = I2C1;

        // Analog inputs (on board MCP3204)

        /// <summary>
        /// Analog input <c>Designator</c> for Grove Connector J10 A0
        /// (MCP3204 input <c>CH2</c>.
        /// </summary>
        public static readonly Designator J10A0 = new Designator(0, 2);
        /// <summary>
        /// Analog input <c>Designator</c> for Grove Connector J10 A1
        /// (MCP3204 input <c>CH3</c>.
        /// </summary>
        public static readonly Designator J10A1 = new Designator(0, 3);

        /// <summary>
        /// Analog input <c>Designator</c> for Grove Connector J11 A0
        /// (MCP3204 input <c>CH0</c>.
        /// </summary>
        public static readonly Designator J11A0 = new Designator(0, 0);
        /// <summary>
        /// Analog input <c>Designator</c> for Grove Connector J11 A1
        /// (MCP3204 input <c>CH1</c>.
        /// </summary>
        public static readonly Designator J11A1 = new Designator(0, 1);
    }
}

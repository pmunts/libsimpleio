// MUNTS-0018 Tutorial I/O Board I/O resource definitions

// Copyright (C)2021-2023, Philip Munts.
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

using static IO.Objects.RemoteIO.Platforms.RaspberryPi;

namespace IO.Objects.RemoteIO.Platforms
{
    /// <summary>
    /// I/O resources (channel numbers) available on a
    /// <a href="http://tech.munts.com/manuals/MUNTS-0018.pdf">
    /// MUNTS-0018 Tutorial I/O Board</a> Remote I/O Protocol Server.
    /// </summary>
    /// <remarks>
    /// The following device tree overlay commands must be added to
    /// <c>config.txt</c> on the Raspberry Pi hosting the MUNTS-0018 Tutorial
    /// I/O Board Remote I/O Protocol Server:
    /// <code>
    /// dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000
    /// dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2
    /// </code>
    /// </remarks>
    public static class MUNTS_0018
    {
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi user LED.
        /// </summary>
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        public const int USERLED = 0;

        /// <summary>
        /// GPIO channel number for the on-board LED <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        public const int D1 = GPIO26;

        /// <summary>
        /// GPIO channel number for the on-board momentary switch <c>SW1</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin cannot be configured as an output.
        /// </remarks>
        public const int SW1 = GPIO6;

        /// <summary>
        /// GPIO channel number for Digital I/O Grove Connector <c>J4</c> pin
        /// <c>D0</c>.
        /// </summary>
        public const int J4D0 = GPIO23;
        /// <summary>
        /// GPIO channel number for Digital I/O Grove Connector <c>J4</c> pin
        /// <c>D1</c>.
        /// </summary>
        public const int J4D1 = GPIO24;
        /// <summary>
        /// GPIO channel number for Digital I/O Grove Connector <c>J5</c> pin
        /// <c>D0</c>.
        /// </summary>
        public const int J5D0 = GPIO5;
        /// <summary>
        /// GPIO channel number for Digital I/O Grove Connector <c>J5</c> pin
        /// <c>D1</c>.
        /// </summary>
        public const int J5D1 = GPIO4;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J6</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO12</c> is
        /// mapped to PWM output <c>PWM0</c>.
        /// </remarks>
        public const int J6D0 = GPIO12;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J6</c>
        /// pin <c>D1</c>.
        /// </summary>
        public const int J6D1 = GPIO13;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J7</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO19</c> is
        /// mapped to PWM output <c>PWM1</c>.
        /// </remarks>
        public const int J7D0 = GPIO19;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J7</c>
        /// pin <c>D1</c>.
        /// </summary>
        public const int J7D1 = GPIO18;

        /// <summary>
        /// PWM channel number for Servo Header <c>J2</c>.
        /// </summary>
        public const int J2PWM = PWM0;
        /// <summary>
        /// PWM channel number for Servo Header <c>J3</c>.
        /// </summary>
        public const int J3PWM = PWM1;

        /// <summary>
        /// PWM channel number for DC Motor Driver Grove Connector <c>J6</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public const int J6PWM = PWM0;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J6</c>
        /// pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public const int J6DIR = GPIO13;
        /// <summary>
        /// PWM channel number for DC Motor Driver Grove Connector <c>J7</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public const int J7PWM = PWM1;
        /// <summary>
        /// GPIO channel number for DC Motor Driver Grove Connector <c>J6</c>
        /// pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public const int J7DIR = GPIO18;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for Grove Connector <c>J9</c>.
        /// </summary>
        public const int J9I2C = I2C1;

        /// <summary>
        /// Analog input channel number for Grove Connector <c>J10</c> pin
        /// <c>A0</c>.
        /// </summary>
        /// <remarks>
        /// MCP3204 input <c>CH2</c>.
        /// </remarks>
        public const int J10A0 = 2;
        /// <summary>
        /// Analog input channel number for Grove Connector <c>J10</c> pin
        /// <c>A1</c>.
        /// </summary>
        /// <remarks>
        /// MCP3204 input <c>CH3</c>.
        /// </remarks>
        public const int J10A1 = 3;
        /// <summary>
        /// Analog input channel number for Grove Connector <c>J11</c> pin
        /// <c>A0</c>.
        /// </summary>
        /// <remarks>
        /// MCP3204 input <c>CH0</c>.
        /// </remarks>
        public const int J11A0 = 0;
        /// <summary>
        /// Analog input channel number for Grove Connector <c>J11</c> pin
        /// <c>A1</c>.
        /// </summary>
        /// <remarks>
        /// MCP3204 input <c>CH1</c>.
        /// </remarks>
        public const int J11A1 = 1;
    }
}

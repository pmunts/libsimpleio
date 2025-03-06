// I/O Resources available from a BeaglePlay Remote I/O Server

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

namespace IO.Objects.RemoteIO.Platforms
{
    /// <summary>
    /// I/O resources (channel numbers) available on a BeaglePlay running
    /// <a href="https://github.com/pmunts/muntsos/blob/master/examples/ada/programs/remoteio_server.adb">Remote I/O Protocol Server</a>.
    /// </summary>
    public static class BeaglePlay
    {
        /// <summary>
        /// GPIO channel number for the BeaglePlay user LED.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// <para />
        /// <c>USERLED</c> and <c>LED_USER0</c> refer to the same LED.
        /// </remarks>
        /// </summary>
        public const int USERLED = 0;

        /// <summary>
        /// GPIO channel number for the BeaglePlay LED <c>USR0</c>.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// <para />
        /// <c>LED_USER0</c> and <c>USERLED</c> refer to the same LED.
        /// </remarks>
        /// </summary>
        public const int LED_USR0 = 0;

        /// <summary>
        /// GPIO channel number for the BeaglePlay LED <c>USR1</c>.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        /// </summary>
        public const int LED_USR1 = 1;

        /// <summary>
        /// GPIO channel number for the BeaglePlay LED <c>USR2</c>.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        /// </summary>
        public const int LED_USR2 = 2;

        /// <summary>
        /// GPIO channel number for the BeaglePlay LED <c>USR3</c>.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        /// </summary>
        public const int LED_USR3 = 3;

        /// <summary>
        /// GPIO channel number for the BeaglePlay LED <c>USR4</c>.
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        /// </summary>
        public const int LED_USR4 = 4;

        /// <summary>
        /// GPIO channel number for the BeaglePlay user button.
        /// <remarks>
        /// This GPIO pin cannot be configured as an output.
        /// </remarks>
        /// </summary>
        public const int USERBUTTON = 5;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>AN</c> pin.
        /// </summary>
        public const int AN = 6;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>RST</c> pin.
        /// </summary>
        public const int RST = 7;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>CS</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-spi-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int CS = 8;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>SCK</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-spi-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int SCK = 9;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>MISO</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-spi-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int MISO = 10;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>MOSI</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-spi-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int MOSI = 11;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>PWM</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-pwm-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int PWM = 12;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>INT</c> pin.
        /// </summary>
        public const int INT = 13;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>RX</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-uart-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int RX = 14;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>TX</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-uart-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int TX = 15;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>SCL</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-i2c-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int SCL = 16;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>SDA</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>mikrobus-gpio.dtbo</c> or the
        /// <c>mikrobus-i2c-gpio.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int SDA = 17;

        /// <summary>
        /// GPIO channel number for the BeaglePlay Grove socket
        /// <c>D0</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>grove-gpio.dtbo</c> or the
        /// <c>grove-motor3.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int D0 = 18;

        /// <summary>
        /// GPIO channel number for the BeaglePlay mikroBUS socket
        /// <c>D1</c> pin.
        /// <remarks>
        /// This GPIO pin cannot be configured unless the BeaglePlay
        /// has had either the <c>grove-gpio.dtbo</c> or the
        /// <c>grove-motor1.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int D1 = 19;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the Grove socket.
        /// </summary>
        public const int I2C_GROVE = 0;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the mikroBUS socket.
        /// </summary>
        public const int I2C_MIKROBUS = 1;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the QWIIC socket.
        /// </summary>
        public const int I2C_QWIIC = 2;

        /// <summary>
        /// PWM output channel number for the mikroBUS socket.
        /// </summary>
        public const int PWM_MIKROBUS = 0;

        /// <summary>
        /// PWM output channel number for the Grove socket pin <c>D0</c>.
        /// <remarks>
        /// This PWM output cannot be configured unless the BeaglePlay
        /// has had either the <c>grove-motor1.dtbo</c> or the
        /// <c>grove-motor2.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int PWM_GROVE_D0 = 1;

        /// <summary>
        /// PWM output channel number for the Grove socket pin <c>D1</c>.
        /// <remarks>
        /// This PWM output cannot be configured unless the BeaglePlay
        /// has had either the <c>grove-motor2.dtbo</c> or the
        /// <c>grove-motor3.dtbo</c> device tree overlay applied.
        /// </remarks>
        /// </summary>
        public const int PWM_GROVE_D1 = 2;

        /// <summary>
        /// SPI slave device channel number for the Grove socket.
        /// </summary>
        public const int SPI_MIKROBUS = 0;
    }
}

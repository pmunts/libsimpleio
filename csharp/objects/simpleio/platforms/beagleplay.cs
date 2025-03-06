// BeaglePlay I/O resource definitions

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

using IO.Objects.SimpleIO.Device;
using System.Data;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This class defines identifiers for the devices provided by the
    /// BeaglePlay hardware platform.
    /// </summary>
    public static class BeaglePlay
    {
        private static readonly string OSNAME = System.Environment.GetEnvironmentVariable("OSNAME");
        private static readonly bool MuntsOS = OSNAME is null ? false : OSNAME.Equals("MuntsOS");

        /// <summary>
        /// User LED device pathname.
        /// <remarks>
        /// <c>USER_LED</c> and <c>LED_USR0</c> refer to the same LED.
        /// </remarks>
        /// </summary>
        public const string USER_LED = "/dev/userled";

        /// <summary>
        /// User LED 0 device pathname.
        /// <remarks>
        /// <c>LED_USR0</c> and <c>USER_LED</c> refer to the same LED.
        /// </remarks>
        /// </summary>
        public const string LED_USR0 = "/dev/userled0";

        /// <summary>
        /// User LED 1 device pathname.
        /// </summary>
        public const string LED_USR1 = "/dev/userled1";

        /// <summary>
        /// User LED 2 device pathname.
        /// </summary>
        public const string LED_USR2 = "/dev/userled2";

        /// <summary>
        /// User LED 3 device node.
        /// </summary>
        public const string LED_USR3 = "/dev/userled3";

        /// <summary>
        /// User LED 4 device pathname.
        /// </summary>
        public const string LED_USR4 = "/dev/userled4";

        /// <summary>
        /// User button GPIO input.
        /// <remarks>
        /// The user button input is active low (pulled to ground when the
        /// button is pressed).
        /// </remarks>
        /// </summary>
        public static readonly Designator USER_BUTTON = new Designator(2, 18);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>AN</c> pin.
        /// </summary>
        public static readonly Designator AN = new Designator(3, 10);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>RST</c> pin.
        /// </summary>
        public static readonly Designator RST = new Designator(3, 12);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>CS</c> pin.
        /// <remarks>
        /// <c>CS</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-spi-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator CS = new Designator(3, 13);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>SCK</c> pin.
        /// <remarks>
        /// <c>SCK</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-spi-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator SCK = new Designator(3, 14);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>MISO</c> pin.
        /// <remarks>
        /// <c>MISO</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-spi-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator MISO = new Designator(3, 7);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>MOSI</c> pin.
        /// <remarks>
        /// <c>MOSI</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-spi-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator MOSI = new Designator(3, 8);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>PWM</c> pin.
        /// <remarks>
        /// <c>PWM</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-pwm-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator PWM = new Designator(3, 11);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>INT</c> pin.
        /// </summary>
        public static readonly Designator INT = new Designator(3, 9);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>RX</c> pin.
        /// <remarks>
        /// <c>RX</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-uart-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator RX = new Designator(3, 24);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>TX</c> pin.
        /// <remarks>
        /// <c>TX</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-uart-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator TX = new Designator(3, 25);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>SCL</c> pin.
        /// <remarks>
        /// <c>SCL</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-i2c-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator SCL = new Designator(3, 22);

        /// <summary>
        /// GPIO pin designator for mikroBUS socket <c>SDA</c> pin.
        /// <remarks>
        /// <c>SDA</c> can only be used for GPIO if either the
        /// <c>mikrobus-gpio.dtbo</c> or the <c>mikrobus-i2c-gpio.dtbo</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator SDA = new Designator(3, 23);

        // Grove GPIO pins

        /// <summary>
        /// GPIO pin designator for Grove socket pin 1 (<c>D0</c>).
        /// <remarks>
        /// <c>D0</c> can only be used for GPIO if the <c>grove-gpio.dtbio</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator D0 = new Designator(3, 28);

        /// <summary>
        /// GPIO pin designator for Grove socket pin 2 (<c>D1</c>).
        /// <remarks>
        /// <c>D1</c> can only be used for GPIO if the <c>grove-gpio.dtbio</c>
        /// device tree overlay has been applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator D1 = new Designator(3, 29);

        /// <summary>
        /// I<sup>2</sup>C bus designator for Grove socket I<sup>2</sup>C bus.
        /// </summary>
        public static readonly Designator I2C_GROVE = new Designator(0, 1);

        /// <summary>
        /// I<sup>2</sup>C bus designator for mikroBUS socket I<sup>2</sup>C bus.
        /// </summary>
        public static readonly Designator I2C_MIKROBUS = new Designator(0, 3);

        /// <summary>
        /// I<sup>2</sup>C bus designator for QWIIC socket I<sup>2</sup>C bus.
        /// </summary>
        public static readonly Designator I2C_QWIIC = new Designator(0, 5);

        // PWM outputs

        /// <summary>
        /// PWM output designator for Grove socket <c>D0</c> pin.
        /// <remarks>
        /// <c>D0</c> can only be used for PWM if either the
        /// <c>grove-motor1.dtbo</c> or the <c>grove-motor2.dtbo</c>
        /// device tree overlay is applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator PWM_GROVE_D0 = new Designator(1, 0);

        /// <summary>
        /// PWM output designator for Grove socket <c>D1</c> pin.
        /// <remarks>
        /// <c>D1</c> can only be used for PWM if either the
        /// <c>grove-motor2.dtbo</c> or the <c>grove-motor3.dtbo</c>
        /// device tree overlay is applied.
        /// </remarks>
        /// </summary>
        public static readonly Designator PWM_GROVE_D1 = new Designator(1, 1);

        /// <summary>
        /// PWM output designator for mikroBUS socket <c>PWM</c> pin.
        /// </summary>
        public static readonly Designator PWM_MIKROBUS = new Designator(0, 0);

        /// <summary>
        /// SPI slave device designator for mikroBUS socket SPI bus.
        /// </summary>
        public static readonly Designator SPI_MIKROBUS = new Designator(0, 0);

        /// <summary>
        /// Console serial port (header <c>J6</c>) device pathname.
        /// <remarks>
        /// The Debian Linux kernel enumerates serial ports differently
        /// than MuntsOS Embedded Linux.
        /// </remarks>
        /// </summary>
        public static readonly string UART_CONSOLE = MuntsOS ? "/dev/ttyS0" : "/dev/ttyS2";

        /// <summary>
        /// Grove socket serial port device pathname.
        /// <remarks>
        /// Switching the Grove socket from I<sup>2</sup>C to a serial port
        /// requires applying the <c>grove-serial.dtbo</c> device tree overlay.
        /// Debian Linux for the BeaglePlay does not allow this because its
        /// kernel reserves the <c>UART1</c> hardware subsystem for boot
        /// loader debugging.
        /// </remarks>
        /// </summary>
        public static readonly string UART_GROVE = MuntsOS ? "/dev/ttyS1" : "/dev/nonexistent";

        /// <summary>
        /// mikroBUS socket serial port device pathname.
        /// <remarks>
        /// The Debian Linux kernel enumerates serial ports differently
        /// than MuntsOS Embedded Linux.
        /// </remarks>
        /// </summary>
        public static readonly string UART_MIKROBUS = MuntsOS ? "/dev/ttyS5" : "/dev/ttyS0";

        /// <summary>
        /// CC1352 Wireless Microcontroller serial port device pathname.
        /// <remarks>
        /// The Debian Linux kernel enumerates serial ports differently
        /// than MuntsOS Embedded Linux.
        /// </remarks>
        /// </summary>
        public static readonly string UART_CC1352 = MuntsOS ? "/dev/ttyS6" : "/dev/ttyS1";
    }
}

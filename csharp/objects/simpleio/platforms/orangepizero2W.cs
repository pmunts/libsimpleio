// Orange Pi Zero 2 W Linux Microcomputer Board I/O resource definitions

// Copyright (C)2023-2025, Philip Munts dba Munts Technologies.
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

using IO.Objects.RemoteIO;
using IO.Objects.SimpleIO.Device;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This class provides designators for the
    /// devices available on the Orange Pi Zero 2 W Linux microcomputer board.
    /// </summary>
    public static class OrangePiZero2W
    {
        /// <summary>Analog input designator (0, 0).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN0 = new Designator(0, 0);

        /// <summary>Analog input designator (0, 1).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN1 = new Designator(0, 1);

        /// <summary>Analog input designator (0, 2).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN2 = new Designator(0, 2);

        /// <summary>Analog input designator (0, 3).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN3 = new Designator(0, 3);

        /// <summary>Analog input designator (0, 4).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN4 = new Designator(0, 4);

        /// <summary>Analog input designator (0, 5).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN5 = new Designator(0, 5);

        /// <summary>Analog input designator (0, 6).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN6 = new Designator(0, 6);

        /// <summary>Analog input designator (0, 7).</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN7 = new Designator(0, 7);

        /// <summary>
        /// GPIO pin designator for expansion header pin 3.
        /// Conflicts with <c>I2C1 SDA</c>.
        /// </summary>
        public static readonly Designator GPIO264 = new Designator(0, 264);

        /// <summary>
        /// GPIO pin designator for expansion header pin 5.
        /// Conflicts with <c>I2C1 SCL</c>.
        /// </summary>
        public static readonly Designator GPIO263 = new Designator(0, 263);

        /// <summary>
        /// GPIO pin designator for expansion header pin 7.
        /// Conflicts with <c>PWM3</c> and <c>UART4 TXD</c>.
        /// </summary>
        public static readonly Designator GPIO269 = new Designator(0, 269);

        /// <summary>
        /// GPIO pin designator for expansion header pin 11.
        /// Conflicts with <c>UART5 TXD</c>.
        /// </summary>
        public static readonly Designator GPIO226 = new Designator(0, 226);

        /// <summary>
        /// GPIO pin designator for expansion header pin 13.
        /// Conflicts with <c>UART5 RXD</c>.
        /// </summary>
        public static readonly Designator GPIO227 = new Designator(0, 227);

        /// <summary>
        /// GPIO pin designator for expansion header pin 15.
        /// Conflicts with <c>I2C0 SCL</c> and <c>UART2 TXD</c>.
        /// </summary>
        public static readonly Designator GPIO261 = new Designator(0, 261);

        /// <summary>
        /// GPIO pin designator for expansion header pin 19.
        /// Conflicts with <c>SPI1 MOSI</c>.
        /// </summary>
        public static readonly Designator GPIO231 = new Designator(0, 231);

        /// <summary>
        /// GPIO pin designator for expansion header pin 21.
        /// Conflicts with <c>SPI1 MISO</c>.
        /// </summary>
        public static readonly Designator GPIO232 = new Designator(0, 232);

        /// <summary>
        /// GPIO pin designator for expansion header pin 23.
        /// Conflicts with <c>SPI1 SCLK</c>.
        /// </summary>
        public static readonly Designator GPIO230 = new Designator(0, 230);

        /// <summary>
        /// GPIO pin designator for expansion header pin 27.
        /// Conflicts with <c>I2C2 SDA</c> and <c>UART3 TXD</c>.
        /// </summary>
        public static readonly Designator GPIO266 = new Designator(0, 266);

        /// <summary>
        /// GPIO pin designator for expansion header pin 29.
        /// </summary>
        public static readonly Designator GPIO256 = new Designator(0, 256);

        /// <summary>
        /// GPIO pin designator for expansion header pin 31.
        /// </summary>
        public static readonly Designator GPIO271 = new Designator(0, 271);

        /// <summary>
        /// GPIO pin designator for expansion header pin 33.
        /// Conflicts with <c>PWM2</c>.
        /// </summary>
        public static readonly Designator GPIO268 = new Designator(0, 268);

        /// <summary>
        /// GPIO pin designator for expansion header pin 35.
        /// </summary>
        public static readonly Designator GPIO258 = new Designator(0, 258);

        /// <summary>
        /// GPIO pin designator for expansion header pin 37.
        /// </summary>
        public static readonly Designator GPIO272 = new Designator(0, 272);

        /// <summary>
        /// GPIO pin designator for expansion header pin 8.
        /// Conflicts with <c>UART0 TXD</c>.
        /// </summary>
        public static readonly Designator GPIO224 = new Designator(0, 224);

        /// <summary>
        /// GPIO pin designator for expansion header pin 10.
        /// Conflicts with <c>UART0 RXD</c>.
        /// </summary>
        public static readonly Designator GPIO225 = new Designator(0, 225);

        /// <summary>
        /// GPIO pin designator for expansion header pin 12.
        /// </summary>
        public static readonly Designator GPIO257 = new Designator(0, 257);

        /// <summary>
        /// GPIO pin designator for expansion header pin 16.
        /// Conflicts with <c>PWM4</c> and <c>UART4 RXD</c>.
        /// </summary>
        public static readonly Designator GPIO270 = new Designator(0, 270);

        /// <summary>
        /// GPIO pin designator for expansion header pin 18.
        /// </summary>
        public static readonly Designator GPIO228 = new Designator(0, 228);

        /// <summary>
        /// GPIO pin designator for expansion header pin 22.
        /// Conflicts with <c>I2C0 SDA</c> and <c>UART2 RXD</c>.
        /// </summary>
        public static readonly Designator GPIO262 = new Designator(0, 262);

        /// <summary>
        /// GPIO pin designator for expansion header pin 24.
        /// Conflicts with <c>SPI1 CS0</c>.
        /// </summary>
        public static readonly Designator GPIO229 = new Designator(0, 229);

        /// <summary>
        /// GPIO pin designator for expansion header pin 26.
        /// Conflicts with <c>SPI1 CS1</c>.
        /// </summary>
        public static readonly Designator GPIO233 = new Designator(0, 233);

        /// <summary>
        /// GPIO pin designator for expansion header pin 28.
        /// Conflicts with <c>I2C2 SCL</c> and <c>UART3 RXD</c>.
        /// </summary>
        public static readonly Designator GPIO265 = new Designator(0, 265);

        /// <summary>
        /// GPIO pin designator for expansion header pin 32.
        /// Conflicts with <c>PWM1</c>.
        /// </summary>
        public static readonly Designator GPIO267 = new Designator(0, 267);

        /// <summary>
        /// GPIO pin designator for expansion header pin 36.
        /// </summary>
        public static readonly Designator GPIO76 = new Designator(0, 76);

        /// <summary>
        /// GPIO pin designator for expansion header pin 38.
        /// </summary>
        public static readonly Designator GPIO260 = new Designator(0, 260);

        /// <summary>
        /// GPIO pin designator for expansion header pin 40.
        /// </summary>
        public static readonly Designator GPIO259 = new Designator(0, 259);

        // On the Orange Pi Zero 2 W, the three I2C buses brought out to the
        // 40-pin expansion bus are not allocated fixed and predictable
        // device nodes.  We have to search sysfs for a matching base address
        // to find the correct device node for each bus.

        private static Designator FindI2CNode(string address)
        {
            // If you have more than 64 I2C buses, my condolences.

            for (uint i = 0; i < 64; i++)
            {
                string path = "/sys/devices/platform/soc/" + address + ".i2c/i2c-" + i.ToString();
                if (System.IO.Directory.Exists(path)) return new Designator(0, i);
            }

            return Designator.Unavailable;
        }

        /// <summary>
        /// I<sup>2</sup>C bus designator for expansion header pins 15 and 22.
        /// Conflicts with <c>GPIO261</c>, <c>GPIO262</c>, <c>UART2 TXD> and
        /// </c>and <c>UART2 RXD</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-i2c0</c> device tree overlay is required to enable
        /// this I<sup>2</sup>C bus.
        /// </remarks>
        public static readonly Designator I2C0 = FindI2CNode("5002000");

        /// <summary>
        /// I<sup>2</sup>C bus designator for expansion header pins 3 and 5.
        /// Conflicts with <c>GPIO263</c> and <c>GPIO264</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-i2c1</c> device tree overlay is required to enable
        /// this I<sup>2</sup>C bus.
        /// </remarks>
        public static readonly Designator I2C1 = FindI2CNode("5002400");

        /// <summary>
        /// I<sup>2</sup>C bus designator for expansion header pins 27 and 28.
        /// Conflicts with <c>GPIO265</c>, <c>GPIO266</c>, <c>UART3 RXD</c> and
        /// <c>UART3 TXD</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-i2c2</c> device tree overlay is required to enable
        /// this I<sup>2</sup>C bus.  It is reserved for Raspberry Pi expansion
        /// board identification and configuration.
        /// </remarks>
        public static readonly Designator I2C2 = FindI2CNode("5002800");

        /// <summary>
        /// PWM output designator for expansion header pin 32.
        /// Conflicts with <c>GPIO267</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-pwm1</c> device tree overlay is required to enable
        /// this PWM output.
        /// </remarks>
        public static readonly Designator PWM1 = new Designator(0, 1);

        /// <summary>
        /// PWM output designator for expansion header pin 33.
        /// Conflicts with <c>GPIO268</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-pwm2</c> device tree overlay is required to enable
        /// this PWM output.
        /// </remarks>
        public static readonly Designator PWM2 = new Designator(0, 2);

        /// <summary>
        /// PWM output designator for expansion header pin 7.
        /// Conflicts with <c>GPIO269</c> and <c>UART4 TXD</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-pwm3</c> device tree overlay is required to enable
        /// this PWM output.
        /// </remarks>
        public static readonly Designator PWM3 = new Designator(0, 3);

        /// <summary>
        /// PWM output designator for expansion header pin 16.
        /// Conflicts with <c>GPIO270</c> and <c>UART4 RXD</c>.
        /// </summary>
        /// <remarks>
        /// The <c>pi-pwm4</c> device tree overlay is required to enable
        /// this PWM output.
        /// </remarks>
        public static readonly Designator PWM4 = new Designator(0, 4);

        /// <summary>
        /// SPI slave select designator for expansion header pin 24.
        /// Conflicts with <c>GPIO229</c>.
        /// </summary>
        /// <remarks>
        /// Expansion header pin 24 is <c>SPI0_0</c> on a Raspberry Pi.
        /// </remarks>
        public static readonly Designator SPI1_0 = new Designator(1, 0);

        /// <summary>
        /// SPI slave select designator for expansion header pin 26.
        /// Conflicts with <c>GPIO233</c>.
        /// </summary>
        /// <remarks>
        /// Expansion pin header 26 is <c>SPI0_1</c> on a Raspberry Pi.
        /// </remarks>
        public static readonly Designator SPI1_1 = new Designator(1, 1);
    }

    /// <summary>
    /// This class provides Raspberry Pi compatible designator aliases for the
    /// devices available on the Orange Pi Zero 2 W Linux microcomputer board.
    /// </summary>
    public static class OrangePiZero2W_RaspberryPi
    {
        /// <summary>Raspberry Pi compatible alias for <c>AIN0</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN0 = OrangePiZero2W.AIN0;

        /// <summary>Raspberry Pi compatible alias for <c>AIN1</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN1 = OrangePiZero2W.AIN1;

        /// <summary>Raspberry Pi compatible alias for <c>AIN2</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN2 = OrangePiZero2W.AIN2;

        /// <summary>Raspberry Pi compatible alias for <c>AIN3</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN3 = OrangePiZero2W.AIN3;

        /// <summary>Raspberry Pi compatible alias for <c>AIN4</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN4 = OrangePiZero2W.AIN4;

        /// <summary>Raspberry Pi compatible alias for <c>AIN5</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN5 = OrangePiZero2W.AIN5;

        /// <summary>Raspberry Pi compatible alias for <c>AIN6</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN6 = OrangePiZero2W.AIN6;

        /// <summary>Raspberry Pi compatible alias for <c>AIN7</c>.</summary>
        /// <remarks>The Orange Pi Zero 2W doesn't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN7 = OrangePiZero2W.AIN7;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO264</c>.
        /// </summary>
        public static readonly Designator GPIO2 = OrangePiZero2W.GPIO264;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO263</c>.
        /// </summary>
        public static readonly Designator GPIO3 = OrangePiZero2W.GPIO263;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO269</c>.
        /// </summary>
        public static readonly Designator GPIO4 = OrangePiZero2W.GPIO269;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO226</c>.
        /// </summary>
        public static readonly Designator GPIO17 = OrangePiZero2W.GPIO226;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO227</c>.
        /// </summary>
        public static readonly Designator GPIO27 = OrangePiZero2W.GPIO227;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO261</c>.
        /// </summary>
        public static readonly Designator GPIO22 = OrangePiZero2W.GPIO261;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO231</c>.
        /// </summary>
        public static readonly Designator GPIO10 = OrangePiZero2W.GPIO231;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO232</c>.
        /// </summary>
        public static readonly Designator GPIO9 = OrangePiZero2W.GPIO232;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO230</c>.
        /// </summary>
        public static readonly Designator GPIO11 = OrangePiZero2W.GPIO230;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO256</c>.
        /// </summary>
        public static readonly Designator GPIO5 = OrangePiZero2W.GPIO256;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO271</c>.
        /// </summary>
        public static readonly Designator GPIO6 = OrangePiZero2W.GPIO271;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO268</c>.
        /// </summary>
        public static readonly Designator GPIO13 = OrangePiZero2W.GPIO268;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO258</c>.
        /// </summary>
        public static readonly Designator GPIO19 = OrangePiZero2W.GPIO258;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO272</c>.
        /// </summary>
        public static readonly Designator GPIO26 = OrangePiZero2W.GPIO272;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO224</c>.
        /// </summary>
        public static readonly Designator GPIO14 = OrangePiZero2W.GPIO224;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO225</c>.
        /// </summary>
        public static readonly Designator GPIO15 = OrangePiZero2W.GPIO225;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO257</c>.
        /// </summary>
        public static readonly Designator GPIO18 = OrangePiZero2W.GPIO257;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO270</c>.
        /// </summary>
        public static readonly Designator GPIO23 = OrangePiZero2W.GPIO270;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO228</c>.
        /// </summary>
        public static readonly Designator GPIO24 = OrangePiZero2W.GPIO228;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO262</c>.
        /// </summary>
        public static readonly Designator GPIO25 = OrangePiZero2W.GPIO262;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO229</c>.
        /// </summary>
        public static readonly Designator GPIO8 = OrangePiZero2W.GPIO229;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO233</c>.
        /// </summary>
        public static readonly Designator GPIO7 = OrangePiZero2W.GPIO233;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO267</c>.
        /// </summary>
        public static readonly Designator GPIO12 = OrangePiZero2W.GPIO267;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO76</c>.
        /// </summary>
        public static readonly Designator GPIO16 = OrangePiZero2W.GPIO76;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO260</c>.
        /// </summary>
        public static readonly Designator GPIO20 = OrangePiZero2W.GPIO260;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>GPIO259</c>.
        /// </summary>
        public static readonly Designator GPIO21 = OrangePiZero2W.GPIO259;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>I2C1</c>.
        /// </summary>
        public static readonly Designator I2C1 = OrangePiZero2W.I2C1;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>PWM1</c>.
        /// </summary>
        public static readonly Designator PWM0 = OrangePiZero2W.PWM1;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>PWM2</c>.
        /// </summary>
        public static readonly Designator PWM1 = OrangePiZero2W.PWM2;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>SPI1_0</c>.
        /// </summary>
        public static readonly Designator SPI0_0 = OrangePiZero2W.SPI1_0;

        /// <summary>
        /// Raspberry Pi compatible alias for <c>SPI1_1</c>.
        /// </summary>
        public static readonly Designator SPI0_1 = OrangePiZero2W.SPI1_1;
    }
}

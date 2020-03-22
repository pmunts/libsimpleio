// Mikroelektronika mikroBUS (https://www.mikroe.com/mikrobus)
// Shield and Socket Services

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.libsimpleio.mikroBUS
{
    /// <summary>
    /// Encapsulates mikroBUS shields (add-on boards providing
    /// <a href="https://www.mikroe.com/mikrobus">mikroBUS</a> sockets).
    /// </summary>
    public static class Shield
    {
        /// <summary>
        /// Supported target board mikroBUS shields.
        /// </summary>
        public enum Kinds
        {
            /// <summary>
            /// No known mikroBUS shield installed.
            /// </summary>
            None,
            /// <summary>
            /// Mikroelektronika BeagleBone Click Shield
            /// <a href="https://www.mikroe.com/beaglebone">MIKROE-1596</a>,
            /// with two mikroBUS sockets.  (Obsolete, but still useful.)
            /// </summary>
            BeagleBoneClick2,
            /// <summary>
            /// Mikroelektronika mikroBUS Cape
            /// <a href="https://www.mikroe.com/beaglebone-mikrobus-cape">
            /// MIKROE-1857</a> with four mikroBUS sockets.
            /// </summary>
            BeagleBoneClick4,
            /// <summary>
            /// Mikroelektronika Pi Click Shield
            /// <a href="https://www.mikroe.com/pi-click-shield-connectors-soldered">
            /// MIKROE-1512/1513</a> for 26-pin expansion header, with one
            /// mikroBUS socket (Obsolete.)
            /// </summary>
            PiClick1,
            /// <summary>
            /// Mikroelektronika Pi 2 Click Shield
            /// <a href="https://www.mikroe.com/pi-2-click-shield">MIKROE-1879</a>
            /// for 40-pin expansion header, with two mikroBUS sockets.
            /// </summary>
            PiClick2,
            /// <summary>
            /// Mikroelektronika Pi 3 Click Shield
            /// <a href="https://www.mikroe.com/pi-3-click-shield">MIKROE-2756</a>
            /// for 40-pin expansion header, with selectable on-board A/D
            /// converter and two mikroBUS sockets.
            /// </summary>
            PiClick3,
            /// <summary>
            /// <a href="http://beagleboard.org/pocket">PocketBeagle</a> with
            /// female headers on top, with two mikroBUS sockets.
            /// </summary>
            PocketBeagle,
        }

        /// <summary>
        /// Returns the kind of mikroBUS shield that is installed on the 
        /// target board, as obtained from the <c>SHIELDNAME</c> environment
        /// variable or guessed from the <c>BOARDNAME</c> environment
        /// variable.  The guessed value for BeagleBone family target boards
        /// (<c>BOARDNAME</c> == "BeagleBone*") is <c>BeagleBoneClick4</c>.
        /// The guessed value for Raspberry Pi family target boards
        /// (<c>BOARDNAME</c> == "RaspberryPi*") is <c>PiClick3</c>.
        /// </summary>
        public static Kinds kind
        {
            get
            {
                // Try the SHIELDNAME environment variable first

                if (System.Enum.TryParse<Kinds>(System.Environment.GetEnvironmentVariable("SHIELDNAME"),
                    true, out Kinds shield))
                {
                    return shield;
                }

                // Now get the contents for the BOARDNAME environment variable

                string board = System.Environment.GetEnvironmentVariable("BOARDNAME");

                if (board == null)
                    return Kinds.None;

                if (board.Equals("pocketbeagle", System.StringComparison.InvariantCultureIgnoreCase))
                    return Kinds.PocketBeagle;

                if (board.StartsWith("beaglebone", System.StringComparison.InvariantCultureIgnoreCase))
                    return Kinds.BeagleBoneClick4;

                if (board.StartsWith("raspberrypi", System.StringComparison.InvariantCultureIgnoreCase))
                    return Kinds.PiClick2;

                return Kinds.None;
            }
        }
    }

    /// <summary>
    /// Encapsulates mikroBUS sockets.
    /// </summary>
    public class Socket
    {
        private readonly int index;
        private struct SocketEntry
        {
            public readonly Shield.Kinds shield;
            public readonly int num;
            public readonly IO.Objects.libsimpleio.Device.Designator AN;
            public readonly IO.Objects.libsimpleio.Device.Designator RST;
            public readonly IO.Objects.libsimpleio.Device.Designator CS;
            public readonly IO.Objects.libsimpleio.Device.Designator SCK;
            public readonly IO.Objects.libsimpleio.Device.Designator MISO;
            public readonly IO.Objects.libsimpleio.Device.Designator MOSI;
            public readonly IO.Objects.libsimpleio.Device.Designator SDA;
            public readonly IO.Objects.libsimpleio.Device.Designator SCL;
            public readonly IO.Objects.libsimpleio.Device.Designator TX;
            public readonly IO.Objects.libsimpleio.Device.Designator RX;
            public readonly IO.Objects.libsimpleio.Device.Designator INT;
            public readonly IO.Objects.libsimpleio.Device.Designator PWM;
            public readonly IO.Objects.libsimpleio.Device.Designator AIN;
            public readonly IO.Objects.libsimpleio.Device.Designator I2C;
            public readonly IO.Objects.libsimpleio.Device.Designator SPI;
            public readonly string UART;

            public SocketEntry(
                Shield.Kinds shield,
                int num,
                IO.Objects.libsimpleio.Device.Designator AN,
                IO.Objects.libsimpleio.Device.Designator RST,
                IO.Objects.libsimpleio.Device.Designator CS,
                IO.Objects.libsimpleio.Device.Designator SCK,
                IO.Objects.libsimpleio.Device.Designator MISO,
                IO.Objects.libsimpleio.Device.Designator MOSI,
                IO.Objects.libsimpleio.Device.Designator SDA,
                IO.Objects.libsimpleio.Device.Designator SCL,
                IO.Objects.libsimpleio.Device.Designator TX,
                IO.Objects.libsimpleio.Device.Designator RX,
                IO.Objects.libsimpleio.Device.Designator INT,
                IO.Objects.libsimpleio.Device.Designator PWM,
                IO.Objects.libsimpleio.Device.Designator AIN,
                IO.Objects.libsimpleio.Device.Designator I2C,
                IO.Objects.libsimpleio.Device.Designator SPI,
                string UART)
            {
                this.shield = shield;
                this.num = num;
                this.AN = AN;
                this.RST = RST;
                this.CS = CS;
                this.SCK = SCK;
                this.MISO = MISO;
                this.MOSI = MOSI;
                this.SDA = SDA;
                this.SCL = SCL;
                this.TX = TX;
                this.RX = RX;
                this.INT = INT;
                this.PWM = PWM;
                this.I2C = I2C;
                this.AIN = AIN;
                this.SPI = SPI;
                this.UART = UART;
            }
        }

        private static readonly SocketEntry[] SocketTable =
        {
            new SocketEntry(Shield.Kinds.BeagleBoneClick2, 1,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO45,      // RST
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO44,      // CS (software SPI slave select)
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO27,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO50,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN0,        // 0-1.8V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Platforms.BeagleBone.SPI2_0,
                "/dev/ttyS1"),

            new SocketEntry(Shield.Kinds.BeagleBoneClick2, 2,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO47,      // RST
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO46,      // CS (software SPI slave select)
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO65,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO22,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN1,        // 0-1.8V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Platforms.BeagleBone.SPI2_1,
                "/dev/ttyS2"),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 1,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO60,      // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO48,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO50,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN3,        // 0-3.6V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Platforms.BeagleBone.SPI2_0,
                "/dev/ttyS2"),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 2,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO49,      // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO20,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO51,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN2,        // 0-3.6V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Platforms.BeagleBone.SPI2_1,
                "/dev/ttyS1"),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 3,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO26,      // RST
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO5,       // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO65,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO22,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN1,        // 0-3.6V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,
                "/dev/ttyS1"),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 4,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // AN
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO46,      // RST
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO68,      // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO27,      // INT
                IO.Objects.libsimpleio.Platforms.BeagleBone.GPIO23,      // PWM
                IO.Objects.libsimpleio.Platforms.BeagleBone.AIN0,        // 0-3.6V
                IO.Objects.libsimpleio.Platforms.BeagleBone.I2C2,
                IO.Objects.libsimpleio.Device.Designator.Unavailable,
                "/dev/ttyS4"),

            new SocketEntry(Shield.Kinds.PocketBeagle, 1,                // Over the micro USB socket
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO87,    // AN
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO89,    // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO23,    // INT
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO50,    // PWM
                IO.Objects.libsimpleio.Platforms.PocketBeagle.AIN6,      // 0-3.6V
                IO.Objects.libsimpleio.Platforms.PocketBeagle.I2C1,
                IO.Objects.libsimpleio.Platforms.PocketBeagle.SPI1_0,
                "/dev/ttyS4"),

            new SocketEntry(Shield.Kinds.PocketBeagle, 2,                // Over the micro SDHC socket
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO86,    // AN
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO45,    // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO26,    // INT
                IO.Objects.libsimpleio.Platforms.PocketBeagle.GPIO110,   // PWM
                IO.Objects.libsimpleio.Platforms.PocketBeagle.AIN5,      // 0-3.6V
                IO.Objects.libsimpleio.Platforms.PocketBeagle.I2C2,
                IO.Objects.libsimpleio.Platforms.PocketBeagle.SPI2_1,
                "/dev/ttyS0"),

            new SocketEntry(Shield.Kinds.PiClick1, 1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO22,     // AN
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO4,      // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO17,     // INT
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO18,     // PWM
                IO.Objects.libsimpleio.Device.Designator.Unavailable,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.I2C1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.SPI0_0,
                "/dev/ttyAMA0"),

            new SocketEntry(Shield.Kinds.PiClick2, 1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO4,      // AN
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO5,      // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO6,      // INT
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO18,     // PWM
                IO.Objects.libsimpleio.Device.Designator.Unavailable,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.I2C1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.SPI0_0,
                "/dev/ttyAMA0"),

            new SocketEntry(Shield.Kinds.PiClick2, 2,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO13,     // AN
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO19,     // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO26,     // INT
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO17,     // PWM
                IO.Objects.libsimpleio.Device.Designator.Unavailable,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.I2C1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.SPI0_1,
                "/dev/ttyAMA0"),

            new SocketEntry(Shield.Kinds.PiClick3, 1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO4,      // AN
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO5,      // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO6,      // INT
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO18,     // PWM
                IO.Objects.libsimpleio.Platforms.RaspberryPi.AIN0,       // 0-4.096V
                IO.Objects.libsimpleio.Platforms.RaspberryPi.I2C1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.SPI0_0,
                "/dev/ttyAMA0"),

            new SocketEntry(Shield.Kinds.PiClick3, 2,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO13,     // AN
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO12,     // RST
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // CS
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCK
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MISO
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // MOSI
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SDA
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // SCL
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // TX
                IO.Objects.libsimpleio.Device.Designator.Unavailable,    // RX
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO26,     // INT
                IO.Objects.libsimpleio.Platforms.RaspberryPi.GPIO17,     // PWM
                IO.Objects.libsimpleio.Platforms.RaspberryPi.AIN1,       // 0-4.096V
                IO.Objects.libsimpleio.Platforms.RaspberryPi.I2C1,
                IO.Objects.libsimpleio.Platforms.RaspberryPi.SPI0_1,
                "/dev/ttyAMA0"),
        };

        private int LookupSocket(Shield.Kinds shield, int num)
        {
            if (shield == Shield.Kinds.None) shield = Shield.kind;

            // Validate parameters

            if (shield < Shield.Kinds.BeagleBoneClick2)
                throw new System.Exception("Invalid shield kind.");

            if (shield > Shield.Kinds.PiClick3)
                throw new System.Exception("Invalid shield kind.");

            if (num < 1)
                throw new System.Exception("Invalid socket number.");

            for (int i = 0; i < SocketTable.Length; i++)
                if ((SocketTable[i].shield == shield) &&
                    (SocketTable[i].num == num))
                    return i;

            throw new System.Exception("Unable to find matching shield and socket number.");
        }

        /// <summary>
        /// Constructor for a single mikroBUS socket.
        /// </summary>
        /// <param name="num">Socket number.</param>
        /// <param name="shield">mikroBUS shield kind.  Zero
        /// indicates automatic detection using the <c>Shield.kind</c>
        /// property.</param>
        public Socket(int num, Shield.Kinds shield = 0)
        {
            this.index = LookupSocket(shield, num);
        }

        /// <summary>
        /// Returns the GPIO pin designator for AN.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator AN
        {
            get { return SocketTable[this.index].AN; }
        }


        /// <summary>
        /// Returns the GPIO pin designator for RST.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator RST
        {
            get { return SocketTable[this.index].RST; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for CS.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator CS
        {
            get { return SocketTable[this.index].CS; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SCK.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator SCK
        {
            get { return SocketTable[this.index].SCK; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for MISO.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator MISO
        {
            get { return SocketTable[this.index].MISO; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for MOSI.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator MOSI
        {
            get { return SocketTable[this.index].MOSI; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SDA.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator SDA
        {
            get { return SocketTable[this.index].SDA; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SCL.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator SCL
        {
            get { return SocketTable[this.index].SCL; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for TX.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator TX
        {
            get { return SocketTable[this.index].TX; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for RX.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator RX
        {
            get { return SocketTable[this.index].RX; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for INT.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator INT
        {
            get { return SocketTable[this.index].INT; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for PWM.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator PWM
        {
            get { return SocketTable[this.index].PWM; }
        }

        /// <summary>
        /// Returns the ADC input designator for AN.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator AIN
        {
            get { return SocketTable[this.index].AIN; }
        }

        /// <summary>
        /// Returns the I<sup>2</sup>C bus designator for this socket.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator I2C
        {
            get { return SocketTable[this.index].I2C; }
        }

        /// <summary>
        /// Returns the SPI device designator for this socket.
        /// </summary>
        public IO.Objects.libsimpleio.Device.Designator SPI
        {
            get { return SocketTable[this.index].SPI; }
        }

        /// <summary>
        /// Returns the UART device name for this socket.
        /// </summary>
        public string UART
        {
            get { return SocketTable[this.index].UART; }
        }
    }
}

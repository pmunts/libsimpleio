// Mikroelektronika mikroBUS (https://www.mikroe.com/mikrobus)
// Remote I/O Server and Socket Services

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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
using IO.Objects.RemoteIO.Platforms;

namespace IO.Objects.RemoteIO.mikroBUS
{
    /// <summary>
    /// Encapsulates mikroBUS shields on Remote I/O Protocol servers providing
    /// <a href="https://www.mikroe.com/mikrobus">mikroBUS</a> sockets).
    /// </summary>
    public static class Shield
    {
        /// <summary>
        /// Supported mikroBUS shields.
        /// </summary>
        public enum Kinds
        {
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
            /// Raspberry Pi with Mikroelektronika Pi Click Shield
            /// <a href="https://www.mikroe.com/pi-click-shield-connectors-soldered">
            /// MIKROE-1512/1513</a> for 26-pin expansion header, with one
            /// mikroBUS socket (Obsolete.)
            /// </summary>
            PiClick1,
            /// <summary>
            /// Raspberry Pi with Mikroelektronika Pi 2 Click Shield
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
            /// <remarks>
            /// Refer to <a href="http://git.munts.com/muntsos/doc/PocketBeaglePinout.pdf">
            /// http://git.munts.com/muntsos/doc/PocketBeaglePinout.pdf</a>
            /// </remarks>
            PocketBeagle,
            /// <summary>
            /// No known mikroBUS shield installed.
            /// </summary>
            Unknown = int.MaxValue
        }

        /// <summary>
        /// Returns the kind of mikroBUS shield that is installed on the Remote
        /// I/O Protocol server, as obtained from the <c>SHIELDNAME</c>
        /// environment variable.
        /// </summary>
        public static Kinds kind
        {
            get
            {
                if (System.Enum.TryParse<Kinds>(System.Environment.GetEnvironmentVariable("SHIELDNAME"),
                    true, out Kinds shield))
                    return shield;
                else
                    return Kinds.Unknown;
            }
        }

        /// <summary>
        /// Shared I<sup>2</sup>C bus that is common to all sockets on this
        /// shield.
        /// </summary>
        public static IO.Interfaces.I2C.Bus I2CBus = null;
    }

    /// <summary>
    /// Encapsulates mikroBUS sockets.
    /// </summary>
    public class Socket
    {
        private readonly struct SocketEntry
        {
            public readonly Shield.Kinds shield;
            public readonly int num;
            // mikroBUS GPIO pins
            public readonly int AN;
            public readonly int RST;
            public readonly int CS;
            public readonly int SCK;
            public readonly int MISO;
            public readonly int MOSI;
            public readonly int SDA;
            public readonly int SCL;
            public readonly int TX;
            public readonly int RX;
            public readonly int INT;
            public readonly int PWM;
            // mikroBUS devices
            public readonly int AIN;
            public readonly int I2CBus;
            public readonly int PWMOut;
            public readonly int SPIDev;

            public SocketEntry(
                Shield.Kinds shield,
                int num,
                // mikroBUS GPIO pins
                int AN,
                int RST,
                int CS,
                int SCK,
                int MISO,
                int MOSI,
                int SDA,
                int SCL,
                int TX,
                int RX,
                int INT,
                int PWM,
                // mikroBUS devices
                int AIN,
                int I2CBus,
                int PWMOut,
                int SPIDev)
            {
                this.shield = shield;
                this.num = num;
                // mikroBUS GPIO pins
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
                // mikroBUS devices
                this.AIN = AIN;
                this.I2CBus = I2CBus;
                this.PWMOut = PWMOut;
                this.SPIDev = SPIDev;
            }
        }

        private static readonly SocketEntry[] SocketTable =
        {
            new SocketEntry(Shield.Kinds.BeagleBoneClick2, 1,
                // mikroBUS GPIO pins
                AN:     Device.Unavailable,
                RST:    BeagleBone.GPIO45,
                CS:     BeagleBone.GPIO44,
                SCK:    BeagleBone.GPIO110,   // Conflicts with SPI1
                MISO:   BeagleBone.GPIO111,   // Conflicts with SPI1
                MOSI:   BeagleBone.GPIO112,   // Conflicts with SPI1
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO15,    // Conflicts with UART1
                RX:     BeagleBone.GPIO14,    // Conflicts with UART1
                INT:    BeagleBone.GPIO27,
                PWM:    BeagleBone.GPIO50,    // Conflicts with EHRPWM1A
                // mikroBUS devices
                AIN:    BeagleBone.AIN0,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM1A,
                SPIDev: BeagleBone.SPI1_0),

            new SocketEntry(Shield.Kinds.BeagleBoneClick2, 2,
                // mikroBUS GPIO pins
                AN:     Device.Unavailable,
                RST:    BeagleBone.GPIO47,
                CS:     BeagleBone.GPIO46,
                SCK:    BeagleBone.GPIO110,   // Conflicts with SPI1
                MISO:   BeagleBone.GPIO111,   // Conflicts with SPI1
                MOSI:   BeagleBone.GPIO112,   // Conflicts with SPI1
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO3,     // Conflicts with UART2
                RX:     BeagleBone.GPIO2,     // Conflicts with UART2
                INT:    BeagleBone.GPIO65,
                PWM:    BeagleBone.GPIO22,    // Conflicts with EHRPWM2A
                // mikroBUS devices
                AIN:    BeagleBone.AIN1,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM2A,
                SPIDev: BeagleBone.SPI1_1),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 1,
                // mikroBUS GPIO pins
                AN:     BeagleBone.GPIO61,    // Conflicts with AIN3
                RST:    BeagleBone.GPIO60,
                CS:     BeagleBone.GPIO113,   // Conflicts with SPI1
                SCK:    BeagleBone.GPIO110,   // Conflicts with SPI1
                MISO:   BeagleBone.GPIO111,   // Conflicts with SPI1
                MOSI:   BeagleBone.GPIO112,   // Conflicts with SPI1
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO3,     // Conflicts with SPI0, UART2
                RX:     BeagleBone.GPIO2,     // Conflicts with SPI0, UART2
                INT:    BeagleBone.GPIO48,
                PWM:    BeagleBone.GPIO50,    // Conflicts with EHRPWM1A
                // mikroBUS devices
                AIN:    BeagleBone.AIN3,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM1A,
                SPIDev: BeagleBone.SPI1_0),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 2,
                // mikroBUS GPIO pins
                AN:     BeagleBone.GPIO47,    // Conflicts with AIN2
                RST:    BeagleBone.GPIO49,
                CS:     BeagleBone.GPIO7,     // Conflicts with SPI1
                SCK:    BeagleBone.GPIO110,   // Conflicts with SPI1
                MISO:   BeagleBone.GPIO111,   // Conflicts with SPI1
                MOSI:   BeagleBone.GPIO112,   // Conflicts with SPI1
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO15,    // Conflicts with UART1
                RX:     BeagleBone.GPIO14,    // Conflicts with UART1
                INT:    BeagleBone.GPIO20,
                PWM:    BeagleBone.GPIO51,    // Conflicts with EHRPWM1B
                // mikroBUS devices
                AIN:    BeagleBone.AIN2,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM1B,
                SPIDev: BeagleBone.SPI1_1),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 3,
                // mikroBUS GPIO pins
                AN:     BeagleBone.GPIO44,    // Conflicts with AIN1
                RST:    BeagleBone.GPIO26,
                CS:     BeagleBone.GPIO5,     // Conflicts with SPI0
                SCK:    BeagleBone.GPIO2,     // Conflicts with SPI0, UART2
                MISO:   BeagleBone.GPIO3,     // Conflicts with SPI0, UART2
                MOSI:   BeagleBone.GPIO4,     // Conflicts with SPI0
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO15,    // Conflicts with UART1
                RX:     BeagleBone.GPIO14,    // Conflicts with UART1
                INT:    BeagleBone.GPIO65,
                PWM:    BeagleBone.GPIO22,    // Conflicts with EHRPWM2A
                // mikroBUS devices
                AIN:    BeagleBone.AIN1,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM2A,
                SPIDev: BeagleBone.SPI0_0),

            new SocketEntry(Shield.Kinds.BeagleBoneClick4, 4,
                // mikroBUS GPIO pins
                AN:     BeagleBone.GPIO45,    // Conflicts with AIN0
                RST:    BeagleBone.GPIO46,
                CS:     BeagleBone.GPIO68,
                SCK:    BeagleBone.GPIO110,   // Conflicts with SPI1
                MISO:   BeagleBone.GPIO111,   // Conflicts with SPI1
                MOSI:   BeagleBone.GPIO112,   // Conflicts with SPI1
                SDA:    BeagleBone.GPIO12,    // Conflicts with I2C2
                SCL:    BeagleBone.GPIO13,    // Conflicts with I2C2
                TX:     BeagleBone.GPIO31,    // Conflicts with UART4
                RX:     BeagleBone.GPIO30,    // Conflicts with UART4
                INT:    BeagleBone.GPIO27,
                PWM:    BeagleBone.GPIO23,    // Conflicts with EHRPWM2B
                // mikroBUS devices
                AIN:    BeagleBone.AIN0,
                I2CBus: BeagleBone.I2C2,
                PWMOut: BeagleBone.EHRPWM2B,
                SPIDev: Device.Unavailable),

            new SocketEntry(Shield.Kinds.PocketBeagle, 1, // Over the micro USB socket
                // mikroBUS GPIO pins
                AN:     PocketBeagle.GPIO87,  // Conflicts with AIN6
                RST:    PocketBeagle.GPIO89,
                CS:     PocketBeagle.GPIO5,   // Conflicts with SPI0
                SCK:    PocketBeagle.GPIO2,   // Conflicts with SPI0
                MISO:   PocketBeagle.GPIO3,   // Conflicts with SPI0
                MOSI:   PocketBeagle.GPIO4,   // Conflicts with SPI0
                SDA:    PocketBeagle.GPIO14,  // Conflicts with I2C1
                SCL:    PocketBeagle.GPIO15,  // Conflicts with I2C1
                TX:     PocketBeagle.GPIO31,  // Conflicts with UART4
                RX:     PocketBeagle.GPIO30,  // Conflicts with UART4
                INT:    PocketBeagle.GPIO23,
                PWM:    PocketBeagle.GPIO50,  // Conflicts wtih PWM2:0
                // mikroBUS devices
                AIN:    PocketBeagle.AIN6,
                I2CBus: PocketBeagle.I2C1,
                PWMOut: PocketBeagle.PWM2_0,
                SPIDev: PocketBeagle.SPI0_0),

            new SocketEntry(Shield.Kinds.PocketBeagle, 2, // Over the micro SDHC socket
                // mikroBUS GPIO pins
                AN:     PocketBeagle.GPIO86,  // Conflicts with AIN5
                RST:    PocketBeagle.GPIO45,
                CS:     PocketBeagle.GPIO19,  // Conflicts with SPI1
                SCK:    PocketBeagle.GPIO7,   // Conflicts with SPI1
                MISO:   PocketBeagle.GPIO40,  // Conflicts with SPI1
                MOSI:   PocketBeagle.GPIO41,  // Conflicts with SPI1
                SDA:    PocketBeagle.GPIO12,  // Conflicts with I2C2
                SCL:    PocketBeagle.GPIO13,  // Conflicts with I2C2
                TX:     PocketBeagle.GPIO43,  // Conflicts with UART0
                RX:     PocketBeagle.GPIO42,  // Conflicts with UART0
                INT:    PocketBeagle.GPIO26,
                PWM:    PocketBeagle.GPIO110, // Conflicts with PWM0:0
                // mikroBUS devices
                AIN:    PocketBeagle.AIN5,
                I2CBus: PocketBeagle.I2C2,
                PWMOut: PocketBeagle.PWM0_0,
                SPIDev: PocketBeagle.SPI1_1),

            new SocketEntry(Shield.Kinds.PiClick1, 1,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO22,
                RST:    RaspberryPi.GPIO4,
                CS:     RaspberryPi.GPIO8,    // Conflicts with SPI0
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO17,
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM0
                // mikroBUS devices
                AIN:    Device.Unavailable,
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM0,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(Shield.Kinds.PiClick2, 1,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO4,
                RST:    RaspberryPi.GPIO5,
                CS:     RaspberryPi.GPIO8,    // Conflicts with SPI0
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO6,
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM0
                // mikroBUS devices
                AIN:    Device.Unavailable,
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM0,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(Shield.Kinds.PiClick2, 2,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO13,
                RST:    RaspberryPi.GPIO19,
                CS:     RaspberryPi.GPIO7,    // Conflicts with SPI0
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO26,
                PWM:    RaspberryPi.GPIO17,
                // mikroBUS devices
                AIN:    Device.Unavailable,
                I2CBus: RaspberryPi.I2C1,
                PWMOut: Device.Unavailable,
                SPIDev: RaspberryPi.SPI0_1),

            new SocketEntry(Shield.Kinds.PiClick3, 1,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO4,    // Switch AN1 must be in the RIGHT position
                RST:    RaspberryPi.GPIO5,
                CS:     RaspberryPi.GPIO8,    // Conflicts with SPI0
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO6,
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM0
                // mikroBUS devices
                AIN:    RaspberryPi.AIN0,     // Switch AN1 must be in the LEFT position
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM0,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(Shield.Kinds.PiClick3, 2,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO13,   // Switch AN2 must be in the RIGHT position
                RST:    RaspberryPi.GPIO12,
                CS:     RaspberryPi.GPIO7,    // Conflicts with SPI0
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO26,
                PWM:    RaspberryPi.GPIO17,
                // mikroBUS devices
                AIN:    RaspberryPi.AIN1,     // Switch AN2 must be in the LEFT position
                I2CBus: RaspberryPi.I2C1,
                PWMOut: Device.Unavailable,
                SPIDev: RaspberryPi.SPI0_1),
        };

        private readonly SocketEntry myInfo;

        /// <summary>
        /// Constructor for a single mikroBUS socket.
        /// </summary>
        /// <param name="num">Socket number.</param>
        /// <param name="shield">mikroBUS shield kind.  Zero
        /// indicates automatic detection using the <c>Shield.kind</c>
        /// property.</param>
        public Socket(int num, Shield.Kinds shield = Shield.Kinds.Unknown)
        {
            if (shield == Shield.Kinds.Unknown) shield = Shield.kind;

            // Search for matching shield and socket number

            for (int i = 0; i < SocketTable.Length; i++)
                if ((SocketTable[i].shield == shield) &&
                    (SocketTable[i].num == num))
                {
                    myInfo = SocketTable[i];
                    return;
                }

            throw new System.Exception("Unable to find matching shield and socket number.");
        }

        /// <summary>
        /// Returns the GPIO pin designator for AN.
        /// </summary>
        public int AN
        {
            get { return myInfo.AN; }
        }


        /// <summary>
        /// Returns the GPIO pin designator for RST.
        /// </summary>
        public int RST
        {
            get { return myInfo.RST; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for CS.
        /// </summary>
        public int CS
        {
            get { return myInfo.CS; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SCK.
        /// </summary>
        public int SCK
        {
            get { return myInfo.SCK; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for MISO.
        /// </summary>
        public int MISO
        {
            get { return myInfo.MISO; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for MOSI.
        /// </summary>
        public int MOSI
        {
            get { return myInfo.MOSI; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SDA.
        /// </summary>
        public int SDA
        {
            get { return myInfo.SDA; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for SCL.
        /// </summary>
        public int SCL
        {
            get { return myInfo.SCL; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for TX.
        /// </summary>
        public int TX
        {
            get { return myInfo.TX; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for RX.
        /// </summary>
        public int RX
        {
            get { return myInfo.RX; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for INT.
        /// </summary>
        public int INT
        {
            get { return myInfo.INT; }
        }

        /// <summary>
        /// Returns the GPIO pin designator for PWM.
        /// </summary>
        public int PWM
        {
            get { return myInfo.PWM; }
        }

        /// <summary>
        /// Returns the ADC input designator for AN.
        /// </summary>
        public int AIN
        {
            get { return myInfo.AIN; }
        }

        /// <summary>
        /// Returns the PWM output designator for PWM.
        /// </summary>
        public int PWMOut
        {
            get { return myInfo.PWMOut; }
        }

        /// <summary>
        /// Returns the I<sup>2</sup>C bus designator for this socket.
        /// </summary>
        public int I2CBus
        {
            get { return myInfo.I2CBus; }
        }

        /// <summary>
        /// Returns the SPI device designator for this socket.
        /// </summary>
        public int SPIDev
        {
            get { return myInfo.SPIDev; }
        }
    }
}

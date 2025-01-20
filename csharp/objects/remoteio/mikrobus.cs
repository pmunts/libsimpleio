// Mikroelektronika mikroBUS (https://www.mikroe.com/mikrobus)
// Remote I/O Server and Socket Services

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

using IO.Objects.RemoteIO.Platforms;

using static System.Console;

namespace IO.Objects.RemoteIO.mikroBUS
{
    /// <summary>
    /// Encapsulates mikroBUS sockets.
    /// </summary>
    public class Socket : IO.Interfaces.mikroBUS.Socket
    {
        private enum ShieldKinds
        {
            BeagleBoneClick2,
            BeagleBoneClick4,
            PiClick1,
            PiClick2,
            PiClick3,
            PiClick4,
            PocketBeagle,
            Unknown = int.MaxValue
        }

        private readonly struct SocketEntry
        {
            public readonly ShieldKinds shield;
            public readonly int num;
            // mikroBUS GPIO pins
            public readonly int[] GPIOs;
            // mikroBUS devices
            public readonly int AIN;
            public readonly int I2CBus;
            public readonly int PWMOut;
            public readonly int SPIDev;

            public SocketEntry(
                ShieldKinds shield,
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
                this.num    = num;
                this.GPIOs  = new int[] { AN, RST, CS, SCK, MISO, MOSI, SDA, SCL, TX, RX, INT, PWM };
                this.AIN    = AIN;
                this.I2CBus = I2CBus;
                this.PWMOut = PWMOut;
                this.SPIDev = SPIDev;
            }

            public void Dump()
            {
                WriteLine("**** Socket Info ****");
                WriteLine("Shield: " + this.shield.ToString());
                WriteLine("Number: " + this.num.ToString());

                foreach (IO.Interfaces.mikroBUS.SocketPins P in System.Enum.GetValues(typeof(IO.Interfaces.mikroBUS.SocketPins)))
                    WriteLine(P.ToString() + ":   " + this.GPIOs[(int) P].ToString().PadRight(4));

                WriteLine("AIN:    " + this.AIN.ToString());
                WriteLine("I2CBus: " + this.I2CBus.ToString());
                WriteLine("PWMOut: " + this.PWMOut.ToString());
                WriteLine("SPIDev: " + this.SPIDev.ToString());
            }
        }

        private static readonly SocketEntry[] SocketTable =
        {
            new SocketEntry(ShieldKinds.BeagleBoneClick2, 1,
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

            new SocketEntry(ShieldKinds.BeagleBoneClick2, 2,
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

            new SocketEntry(ShieldKinds.BeagleBoneClick4, 1,
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

            new SocketEntry(ShieldKinds.BeagleBoneClick4, 2,
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

            new SocketEntry(ShieldKinds.BeagleBoneClick4, 3,
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

            new SocketEntry(ShieldKinds.BeagleBoneClick4, 4,
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

            new SocketEntry(ShieldKinds.PocketBeagle, 1, // Over the micro USB socket
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

            new SocketEntry(ShieldKinds.PocketBeagle, 2, // Over the micro SDHC socket
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

            new SocketEntry(ShieldKinds.PiClick1, 1,
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
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM2
                // mikroBUS devices
                AIN:    Device.Unavailable,
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM2,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(ShieldKinds.PiClick2, 1,
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
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM2
                // mikroBUS devices
                AIN:    Device.Unavailable,
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM2,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(ShieldKinds.PiClick2, 2,
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

            new SocketEntry(ShieldKinds.PiClick3, 1,
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
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM2
                // mikroBUS devices
                AIN:    RaspberryPi.AIN0,     // Switch AN1 must be in the LEFT position
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM2,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(ShieldKinds.PiClick3, 2,
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

            new SocketEntry(ShieldKinds.PiClick4, 1,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO4,    // Jumper JP1 aka AN1 must be in the RIGHT position
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
                PWM:    RaspberryPi.GPIO18,   // Conflicts with PWM2
                // mikroBUS devices
                AIN:    RaspberryPi.AIN0,     // Jumper JP1 aka AN1 must be in the LEFT position (default)
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM2,
                SPIDev: RaspberryPi.SPI0_0),

            new SocketEntry(ShieldKinds.PiClick4, 2,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO17,   // Jumper JP2 aka AN2 must be in the RIGHT position
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
                PWM:    RaspberryPi.GPIO13,   // Conflicts with PWM1
                // mikroBUS devices
                AIN:    RaspberryPi.AIN1,     // Jumper JP2 aka AN2 must be in the LEFT position (default)
                I2CBus: RaspberryPi.I2C1,
                PWMOut: RaspberryPi.PWM1,
                SPIDev: RaspberryPi.SPI0_1),

            new SocketEntry(ShieldKinds.PiClick4, 3,
                // mikroBUS GPIO pins
                AN:     RaspberryPi.GPIO24,   // Jumper JP3 aka AN3 must be in the RIGHT position
                RST:    RaspberryPi.GPIO22,
                CS:     RaspberryPi.GPIO23,
                SCK:    RaspberryPi.GPIO11,   // Conflicts with SPI0
                MISO:   RaspberryPi.GPIO9,    // Conflicts with SPI0
                MOSI:   RaspberryPi.GPIO10,   // Conflicts with SPI0
                SDA:    RaspberryPi.GPIO2,    // Conflicts with I2C1
                SCL:    RaspberryPi.GPIO3,    // Conflicts with I2C1
                TX:     RaspberryPi.GPIO14,   // Conflicts with UART0
                RX:     RaspberryPi.GPIO15,   // Conflicts with UART0
                INT:    RaspberryPi.GPIO27,
                PWM:    RaspberryPi.GPIO16,
                // mikroBUS devices
                AIN:    RaspberryPi.AIN2,     // Jumper JP3 aka AN3 must be in the LEFT position (default)
                I2CBus: RaspberryPi.I2C1,
                PWMOut: Device.Unavailable,
                SPIDev: Device.Unavailable),
        };

        private readonly IO.Objects.RemoteIO.Device dev;
        private readonly SocketEntry sockinfo;

        /// <summary>
        /// Constructor for a single mikroBUS socket.
        /// </summary>
        /// <param name="dev">Remote I/O Protocol Server device handle.</param>
        /// <param name="num">Socket number.</param>
        public Socket(IO.Objects.RemoteIO.Device dev, int num)
        {
            this.dev = dev;

            ShieldKinds shield = (ShieldKinds) int.MaxValue;

            // Retrieve shield kind from the capabilities string

            foreach (ShieldKinds s in System.Enum.GetValues(typeof(ShieldKinds)))
                if (dev.Capabilities.Contains(s.ToString().ToUpper()))
                {
                    shield = s;
                    break;
                }

            // Search for matching shield and socket number

            foreach (SocketEntry E in SocketTable)
                if ((E.shield == shield) && (E.num == num))
                {
                    this.sockinfo = E;
                    return;
                }

            throw new System.Exception("Unable to find matching shield and socket number.");
        }

        /// <summary>
        /// Create an analog input object instance for a given socket.
        /// </summary>
        /// <returns>Analog input object instance.</returns>
        public IO.Interfaces.ADC.Sample CreateAnalogInput()
        {
            return this.dev.ADC_Create(this.sockinfo.AIN);
        }

        /// <summary>
        /// Create a GPIO pin object instance for a given pin of a given socket.
        /// </summary>
        /// <param name="desg">mikroBUS socket pin designator.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial state for the reset output.</param>
        /// <param name="drive">Output drive setting.
        /// Ignored for remote GPIO pins.</param>
        /// <param name="edge">Input edge trigger setting.
        /// Ignored for remote GPIO pins.</param>
        /// <remarks>
        /// Seldom are all of the mikroBUS socket pins available for GPIO.
        /// Usually many of them are configured for other special functions,
        /// including SPI bus, I<sup>2</sup>C bus, PWM output, etc.
        /// </remarks>
        /// <returns>GPIO pin object instance.</returns>
        public IO.Interfaces.GPIO.Pin CreateGPIOPin(IO.Interfaces.mikroBUS.SocketPins desg,
            IO.Interfaces.GPIO.Direction dir, bool state = false,
            IO.Interfaces.GPIO.Drive drive = IO.Interfaces.GPIO.Drive.PushPull,
            IO.Interfaces.GPIO.Edge edge = IO.Interfaces.GPIO.Edge.None)
        {
            return this.dev.GPIO_Create((int) desg, dir, state);
        }

        /// <summary>
        /// Create a GPIO output pin object instance for the RST pin of a
        /// given socket.
        /// </summary>
        /// <param name="state">Initial state for the reset output.</param>
        /// <param name="drive">Output drive setting.
        /// Ignored for remote GPIO pins.</param>
        /// <returns>GPIO output pin object instance.</returns>
        public IO.Interfaces.GPIO.Pin CreateResetOutput(bool state = false,
            IO.Interfaces.GPIO.Drive drive = IO.Interfaces.GPIO.Drive.PushPull)
        {
            return this.dev.GPIO_Create(this.sockinfo.GPIOs[(int)IO.Interfaces.mikroBUS.SocketPins.RST],
                IO.Interfaces.GPIO.Direction.Output, state);
        }

        /// <summary>
        /// Create a SPI slave device object instance for a given socket.
        /// </summary>
        /// <returns>SPI slave device object instance.</returns>
        /// <param name="mode">SPI transfer mode: 0 to 3.</param>
        /// <param name="wordsize">SPI transfer word size: 8, 16, or 32.</param>
        /// <param name="speed">SPI transfer speed in bits per second.</param>
        public IO.Interfaces.SPI.Device CreateSPIDevice(int mode, int wordsize, int speed)
        {
            return dev.SPI_Create(this.sockinfo.SPIDev, mode, wordsize, speed);
        }

        /// <summary>
        /// Create an I<sup>2</sup>C bus object instance for a given socket.
        /// </summary>
        /// <param name="speed">I<sup>2</sup>C bus clock frequency in Hz.</param>
        /// <returns>I<sup>2</sup>C bus object instance.</returns>
        public IO.Interfaces.I2C.Bus CreateI2CBus(int speed = IO.Interfaces.I2C.Speeds.StandardMode)
        {
            return dev.I2C_Create(this.sockinfo.I2CBus, speed);
        }

        /// <summary>
        /// Create a GPIO input pin instance for the INT (interrupt) pin of a 
        /// given socket.
        /// </summary>
        /// <param name="edge">Interrupt edge setting.
        /// Ignored for remote GPIO pins.</param>
        /// <returns>GPIO pin instance.</returns>
        public IO.Interfaces.GPIO.Pin CreateInterruptInput(
            IO.Interfaces.GPIO.Edge edge = IO.Interfaces.GPIO.Edge.None)
        {
            return this.dev.GPIO_Create(this.sockinfo.GPIOs[(int)IO.Interfaces.mikroBUS.SocketPins.INT],
                IO.Interfaces.GPIO.Direction.Input);
        }

        /// <summary>
        /// Create a PWM (Pulse Width Modulated) output instance for a given
        /// socket.
        /// </summary>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <param name="duty">Initial PWM output duty cycle.</param>
        /// <returns>PWM output instance.</returns>
        public IO.Interfaces.PWM.Output CreatePWMOutput(int freq, double duty = IO.Interfaces.PWM.DutyCycles.Minimum)
        {
            return this.dev.PWM_Create(this.sockinfo.PWMOut, freq, duty);
        }
    }
}

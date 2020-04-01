// Mikroelektronika mikroBUS (https://www.mikroe.com/mikrobus)
// Remote I/O Server and Socket Services

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

namespace IO.Remote.mikroBUS
{
    /// <summary>
    /// Encapsulates Remote I/O Protocol servers providing
    /// <a href="https://www.mikroe.com/mikrobus">mikroBUS</a> sockets).
    /// </summary>
    public static class Server
    {
        /// <summary>
        /// Supported Remote I/O Protocol servers.
        /// </summary>
        public enum Kinds
        {
            /// <summary>
            /// <a href="https://www.mikroe.com/clicker-stm32f4">
            /// Mikroelektronika STM32F4 Clicker</a> with MUNTS-0011 Remote I/O
            /// Server firmware, with one mikroBUS socket.
            /// </summary>
            Clicker,
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
            /// Unknown Remote I/O Protocol server.
            /// </summary>
            Unknown = int.MaxValue,
        }

        /// <summary>
        /// Returns the kind of Remote I/O Protocol server, as obtained from
        /// the <c>SERVERKIND</c> environment
        /// variable.
        /// </summary>
        public static Kinds kind
        {
            get
            {
                if (System.Enum.TryParse<Kinds>(System.Environment.GetEnvironmentVariable("SERVERKIND"),
                    true, out Kinds server))
                    return server;
                else
                    return Kinds.Unknown;
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
            public readonly Server.Kinds server;
            // mikroBUS GPIO pins
            public readonly int num;
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
                Server.Kinds server,
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
                this.server = server;
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
            new SocketEntry(Server.Kinds.Clicker, 1,
                // mikroBUS GPIO pins
                AN:     12,
                RST:    13,
                CS:     14,
                SCK:    15,
                MISO:   16,
                MOSI:   17,
                SDA:    23,
                SCL:    22,
                TX:     21,
                RX:     20,
                INT:    19,
                PWM:    18,
                // mikroBUS devices
                AIN:    0,
                I2CBus: 0,
                PWMOut: 0,
                SPIDev: 0),

            new SocketEntry(Server.Kinds.PocketBeagle, 1, // Over the micro USB socket
                // mikroBUS GPIO pins
                AN:     87,
                RST:    89,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    23,
                PWM:    50,
                // mikroBUS devices
                AIN:    6,
                I2CBus: 0,
                PWMOut: 1,
                SPIDev: 0),

            new SocketEntry(Server.Kinds.PocketBeagle, 2, // Over the micro SDHC socket
                // mikroBUS GPIO pins
                AN:     86,
                RST:    45,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    26,
                PWM:    110,
                // mikroBUS devices
                AIN:    5,
                I2CBus: 1,
                PWMOut: 0,
                SPIDev: 1),

            new SocketEntry(Server.Kinds.PiClick1, 1,
                // mikroBUS GPIO pins
                AN:     22,
                RST:    4,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    17,
                PWM:    18,
                // mikroBUS devices
                AIN:    IO.Remote.Device.Unavailable,
                I2CBus: 0,
                PWMOut: 0,
                SPIDev: 0),

            new SocketEntry(Server.Kinds.PiClick2, 1,
                // mikroBUS GPIO pins
                AN:     4,
                RST:    5,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    6,
                PWM:    18,
                // mikroBUS devices
                AIN:    IO.Remote.Device.Unavailable,
                I2CBus: 0,
                PWMOut: 0,
                SPIDev: 0),

            new SocketEntry(Server.Kinds.PiClick2, 2,
                // mikroBUS GPIO pins
                AN:     13,
                RST:    19,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    26,
                PWM:    17,
                // mikroBUS devices
                AIN:    IO.Remote.Device.Unavailable,
                I2CBus: 0,
                PWMOut: IO.Remote.Device.Unavailable,
                SPIDev: 1),

            new SocketEntry(Server.Kinds.PiClick3, 1,
                // mikroBUS GPIO pins
                AN:     4,
                RST:    5,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    6,
                PWM:    18,
                // mikroBUS devices
                AIN:    0,
                I2CBus: 0,
                PWMOut: 0,
                SPIDev: 0),

            new SocketEntry(Server.Kinds.PiClick3, 2,
                // mikroBUS GPIO pins
                AN:     13,
                RST:    12,
                CS:     IO.Remote.Device.Unavailable,
                SCK:    IO.Remote.Device.Unavailable,
                MISO:   IO.Remote.Device.Unavailable,
                MOSI:   IO.Remote.Device.Unavailable,
                SDA:    IO.Remote.Device.Unavailable,
                SCL:    IO.Remote.Device.Unavailable,
                TX:     IO.Remote.Device.Unavailable,
                RX:     IO.Remote.Device.Unavailable,
                INT:    26,
                PWM:    17,
                // mikroBUS devices
                AIN:    1,
                I2CBus: 0,
                PWMOut: IO.Remote.Device.Unavailable,
                SPIDev: 1),
        };

    private int LookupSocket(Server.Kinds server, int num)
    {
        if (server == Server.Kinds.Unknown) server = Server.kind;

        // Validate parameters

        if (num < 1)
            throw new System.Exception("Invalid socket number.");

        for (int i = 0; i < SocketTable.Length; i++)
            if ((SocketTable[i].server == server) &&
                (SocketTable[i].num == num))
                return i;

        throw new System.Exception("Unable to find matching server and socket number.");
    }

    /// <summary>
    /// Constructor for a single mikroBUS socket.
    /// </summary>
    /// <param name="num">Socket number.</param>
    /// <param name="server">mikroBUS server kind.  Zero
    /// indicates automatic detection using the <c>Server.kind</c>
    /// property.</param>
    public Socket(int num, Server.Kinds server = 0)
    {
        this.index = LookupSocket(server, num);
    }

    /// <summary>
    /// Returns the GPIO pin designator for AN.
    /// </summary>
    public int AN
    {
        get { return SocketTable[this.index].AN; }
    }


    /// <summary>
    /// Returns the GPIO pin designator for RST.
    /// </summary>
    public int RST
    {
        get { return SocketTable[this.index].RST; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for CS.
    /// </summary>
    public int CS
    {
        get { return SocketTable[this.index].CS; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for SCK.
    /// </summary>
    public int SCK
    {
        get { return SocketTable[this.index].SCK; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for MISO.
    /// </summary>
    public int MISO
    {
        get { return SocketTable[this.index].MISO; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for MOSI.
    /// </summary>
    public int MOSI
    {
        get { return SocketTable[this.index].MOSI; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for SDA.
    /// </summary>
    public int SDA
    {
        get { return SocketTable[this.index].SDA; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for SCL.
    /// </summary>
    public int SCL
    {
        get { return SocketTable[this.index].SCL; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for TX.
    /// </summary>
    public int TX
    {
        get { return SocketTable[this.index].TX; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for RX.
    /// </summary>
    public int RX
    {
        get { return SocketTable[this.index].RX; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for INT.
    /// </summary>
    public int INT
    {
        get { return SocketTable[this.index].INT; }
    }

    /// <summary>
    /// Returns the GPIO pin designator for PWM.
    /// </summary>
    public int PWM
    {
        get { return SocketTable[this.index].PWM; }
    }

    /// <summary>
    /// Returns the ADC input designator for AN.
    /// </summary>
    public int AIN
    {
        get { return SocketTable[this.index].AIN; }
    }

    /// <summary>
    /// Returns the PWM output designator for PWM.
    /// </summary>
    public int PWMOut
    {
        get { return SocketTable[this.index].PWMOut; }
    }

    /// <summary>
    /// Returns the I<sup>2</sup>C bus designator for this socket.
    /// </summary>
    public int I2C
    {
        get { return SocketTable[this.index].I2CBus; }
    }

    /// <summary>
    /// Returns the SPI device designator for this socket.
    /// </summary>
    public int SPI
    {
        get { return SocketTable[this.index].SPIDev; }
    }
}
}
// MCP23017 I2C GPIO Expander Services.

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

namespace IO.Devices.MCP23017
{
    /// <summary>
    /// Encapsulates the MCP23017 I<sup>2</sup>C I/O GPIO Expander.
    /// </summary>
    public class Device
    {
        private const byte IODIRA = 0x00;
        private const byte IODIRB = 0x01;
        private const byte IPOLA = 0x02;
        private const byte IPOLB = 0x03;
        private const byte GPINTENA = 0x04;
        private const byte GPINTENB = 0x05;
        private const byte DEFVALA = 0x06;
        private const byte DEFVALB = 0x07;
        private const byte INTCONA = 0x08;
        private const byte INTCONB = 0x09;
        private const byte IOCONA = 0x0A;
        private const byte IOCONB = 0x0B;
        private const byte GPPUA = 0x0C;
        private const byte GPPUB = 0x0D;
        private const byte INTFA = 0x0E;
        private const byte INTFB = 0x0F;
        private const byte INTCAPA = 0x10;
        private const byte INTCAPB = 0x11;
        private const byte GPIOA = 0x12;
        private const byte GPIOB = 0x13;
        private const byte OLATA = 0x14;
        private const byte OLATB = 0x15;

        private const byte IOCON = IOCONA;
        private const byte IODIR = IODIRA;
        private const byte IPOL = IPOLA;
        private const byte GPINTEN = GPINTENA;
        private const byte DEFVAL = DEFVALA;
        private const byte INTCON = INTCONA;
        private const byte GPPU = GPPUA;
        private const byte INTF = INTFA;
        private const byte INTCAP = INTCAPA;
        private const byte GPIODAT = GPIOA;
        private const byte GPIOLAT = OLATA;

        private IO.Interfaces.I2C.Device dev;

        // Preallocate I2C transaction buffers
        private byte[] outbuf = { 0, 0, 0 };
        private byte[] inbuf = { 0, 0 };

        private byte ReadRegister8(byte reg)
        {
            outbuf[0] = reg;
            dev.Transaction(outbuf, 1, inbuf, 1);
            return inbuf[0];
        }

        private void WriteRegister8(byte reg, byte data)
        {
            outbuf[0] = reg;
            outbuf[1] = data;
            dev.Write(outbuf, 2);
        }

        private uint ReadRegister16(byte reg)
        {
            outbuf[0] = reg;
            dev.Transaction(outbuf, 1, inbuf, 2);
            return (uint)(inbuf[0] + (inbuf[1] << 8));
        }

        private void WriteRegister16(byte reg, uint data)
        {
            data &= 0xFFFF;

            outbuf[0] = reg;
            outbuf[1] = (byte)(data & 0xFF);
            outbuf[2] = (byte)(data >> 8);
            dev.Write(outbuf, 3);
        }

        /// <summary>
        /// Minimum I/O channel number.
        /// </summary>
        public const int MinChannel = 0;

        /// <summary>
        /// Maximum I/O channel number.
        /// </summary>
        public const int MaxChannel = 15;

        /// <summary>
        /// Constructor for a single MCP23017 device.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller object.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Device(IO.Interfaces.I2C.Bus bus, int addr)
        {
            // Create an I2C device object

            dev = new IO.Interfaces.I2C.Device(bus, addr);

            // Configure the MCP23017

            WriteRegister8(IOCON, 0x00);
            WriteRegister16(IODIR, 0xFFFF);
            WriteRegister16(IPOL, 0x0000);
            WriteRegister16(GPINTEN, 0x0000);
            WriteRegister16(DEFVAL, 0x0000);
            WriteRegister16(INTCON, 0x0000);
        }

        /// <summary>
        /// Data Direction Property (16 bits).
        /// Bits 0 to 7 correspond to PORT A and bits 8 to 15 correspond to PORT B.
        /// For each bit, 0=input and 1=output.
        /// </summary>
        /// <remarks>
        /// This property follows the industry standard convention for data
        /// direction bit polarity (1=output) rather than the MCP23017
        /// <c>IODIR</c> register polarity (0=output).
        /// </remarks>
        public uint Direction
        {
            get { return ~ReadRegister16(IODIR) & 0xFFFF; }

            set { WriteRegister16(IODIR, ~value); }
        }

        /// <summary>
        /// Data Polarity Property (16 bits).
        /// Bits 0 to 7 correspond to PORT A and bits 8 to 15 correspond to PORT B.
        /// For each bit, 0=input and 1=output.
        /// </summary>
        public uint Polarity
        {
            get { return ReadRegister16(IPOL); }

            set { WriteRegister16(IPOL, value); }
        }

        /// <summary>
        /// Input Pullup Property (16 bits).
        /// Bits 0 to 7 correspond to PORT A and bits 8 to 15 correspond to PORT B.
        /// For each bit, 0=high impedance and 1=100k pullup.
        /// </summary>
        public uint Pullups
        {
            get { return ReadRegister16(GPPU); }

            set { WriteRegister16(GPPU, value); }
        }

        /// <summary>
        /// Port Data Property (16 bites).
        /// Bits 0 to 7 correspond to PORT A and bits 8 to 15 correspond to PORT B.
        /// </summary>
        public uint Port
        {
            get { return ReadRegister16(GPIODAT); }

            set { WriteRegister16(GPIODAT, value); }
        }

        /// <summary>
        /// Port A Data Direction Property (8 bits).
        /// For each bit, 0=input and 1=output.
        /// </summary>
        /// <remarks>
        /// This property follows the industry standard convention for data
        /// direction bit polarity (1=output) rather than the MCP23017
        /// <c>IODIRA</c> register polarity (0=output).
        /// </remarks>
        public byte DirectionA
        {
            get { return (byte) ~ReadRegister8(IODIRA); }

            set { WriteRegister8(IODIRA, (byte) ~value); }
        }

        /// <summary>
        /// Port A Data Polarity Property (8 bits).
        /// For each bit, 0=input and 1=output.
        /// </summary>
        public byte PolarityA
        {
            get { return ReadRegister8(IPOLA); }

            set { WriteRegister8(IPOLA, value); }
        }

        /// <summary>
        /// Port A Input Pullup Property (16 bits).
        /// For each bit, 0=high impedance and 1=100k pullup.
        /// </summary>
        public byte PullupsA
        {
            get { return ReadRegister8(GPPUA); }

            set { WriteRegister8(GPPUA, value); }
        }

        /// <summary>
        /// Port A Data Property (8 bits).
        /// </summary>
        public byte PortA
        {
            get { return ReadRegister8(GPIOA); }

            set { WriteRegister8(OLATA, value); }
        }

        /// <summary>
        /// Port B Data Direction Property (8 bits).
        /// For each bit, 0=input and 1=output.
        /// </summary>
        /// <remarks>
        /// This property follows the industry standard convention for data
        /// direction bit polarity (1=output) rather than the MCP23017
        /// <c>IODIRA</c> register polarity (0=output).
        /// </remarks>
        public byte DirectionB
        {
            get { return (byte)~ReadRegister8(IODIRB); }

            set { WriteRegister8(IODIRB, (byte)~value); }
        }

        /// <summary>
        /// Port B Data Polarity Property (8 bits).
        /// For each bit, 0=input and 1=output.
        /// </summary>
        public byte PolarityB
        {
            get { return ReadRegister8(IPOLB); }

            set { WriteRegister8(IPOLB, value); }
        }

        /// <summary>
        /// Port B Input Pullup Property (16 bits).
        /// For each bit, 0=high impedance and 1=100k pullup.
        /// </summary>
        public byte PullupsB
        {
            get { return ReadRegister8(GPPUB); }

            set { WriteRegister8(GPPUB, value); }
        }

        /// <summary>
        /// Port B Data Property (8 bits).
        /// </summary>
        public byte PortB
        {
            get { return ReadRegister8(GPIOB); }

            set { WriteRegister8(OLATB, value); }
        }

        /// <summary>
        /// Create an MCP23017 GPIO pin object.
        /// </summary>
        /// <param name="channel">MCP23017 channel number (0 to 15).</param>
        /// <param name="dir">GPIO pin data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO_Create(int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            return new IO.Devices.MCP23017.GPIO.Pin(this, channel, dir, state);
        }
    }
}

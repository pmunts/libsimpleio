// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// command and response message definitions

// Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

namespace SPIAgent
{
    /// <exclude/>
    public static class MessageConversions
    {
        public static byte Split32(int n, int b)
        {
            if ((b < 0) || (b > 3))
                throw new System.Exception("Invalid byte number");

            return System.Convert.ToByte((n >> (b * 8)) & 0xFF);
        }

        public static int Build32(byte b0, byte b1, byte b2, byte b3)
        {
            return (b3 << 24) | (b2 << 16) | (b1 << 8) | b0;
        }
    }

    /// <summary>
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
    /// command message object.
    /// </summary>
    public class SPIAGENT_COMMAND_MSG_t
    {
        /// <summary>
        /// Command code to SPI Agent Firmware
        /// </summary>
        public int command;

        /// <summary>
        /// Pin number to SPI Agent Firmware
        /// </summary>
        public int pin;

        /// <summary>
        /// Data item to SPI Agent Firmware
        /// </summary>
        public int data;

        /// <summary>
        /// Convert a command message object to a byte array.
        /// </summary>
        /// <param name="buf">Destination byte array.  Must be at least
        /// 12 bytes long.</param>
        public void ToBytes(ref byte[] buf)
        {
            if (buf.Length < 12)
                throw new System.Exception("Byte buffer is too small");

            buf[0] = MessageConversions.Split32(this.command, 0);
            buf[1] = MessageConversions.Split32(this.command, 1);
            buf[2] = MessageConversions.Split32(this.command, 2);
            buf[3] = MessageConversions.Split32(this.command, 3);

            buf[4] = MessageConversions.Split32(this.pin, 0);
            buf[5] = MessageConversions.Split32(this.pin, 1);
            buf[6] = MessageConversions.Split32(this.pin, 2);
            buf[7] = MessageConversions.Split32(this.pin, 3);

            buf[8] = MessageConversions.Split32(this.data, 0);
            buf[9] = MessageConversions.Split32(this.data, 1);
            buf[10] = MessageConversions.Split32(this.data, 2);
            buf[11] = MessageConversions.Split32(this.data, 3);
        }

        /// <summary>
        /// Convert a command message object from a byte array.
        /// </summary>
        /// <param name="buf">Source byte array.  Must be at least
        /// 12 bytes long.</param>
        public void FromBytes(ref byte[] buf)
        {
            if (buf.Length < 12)
                throw new System.Exception("Byte buffer is too small");

            this.command =
                MessageConversions.Build32(buf[0], buf[1], buf[2], buf[3]);

            this.pin =
                MessageConversions.Build32(buf[4], buf[5], buf[6], buf[7]);

            this.data =
                MessageConversions.Build32(buf[8], buf[9],buf[10], buf[11]);
        }
    }

    /// <summary>
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
    /// response message object.
    /// </summary>
    public class SPIAGENT_RESPONSE_MSG_t
    {
        /// <summary>
        /// Command code from SPI Agent Firmware (echoed from command message)
        /// </summary>
        public int command;

        /// <summary>
        /// Pin number from SPI Agent Firmware (echoed from command message)
        /// </summary>
        public int pin;

        /// <summary>
        /// Data item from SPI Agent Firmware
        /// </summary>
        public int data;

        /// <summary>
        /// Error code (errno value) from SPI Agent Firmware
        /// </summary>
        public int error;

        /// <summary>
        /// Convert a response message object to a byte array.
        /// </summary>
        /// <param name="buf">Destination byte array.  Must be at least
        /// 16 bytes long.</param>
        public void ToBytes(ref byte[] buf)
        {
            if (buf.Length < 16)
                throw new System.Exception("Byte buffer is too small");

            buf[0] = MessageConversions.Split32(this.command, 0);
            buf[1] = MessageConversions.Split32(this.command, 1);
            buf[2] = MessageConversions.Split32(this.command, 2);
            buf[3] = MessageConversions.Split32(this.command, 3);

            buf[4] = MessageConversions.Split32(this.pin, 0);
            buf[5] = MessageConversions.Split32(this.pin, 1);
            buf[6] = MessageConversions.Split32(this.pin, 2);
            buf[7] = MessageConversions.Split32(this.pin, 3);

            buf[8] = MessageConversions.Split32(this.data, 0);
            buf[9] = MessageConversions.Split32(this.data, 1);
            buf[10] = MessageConversions.Split32(this.data, 2);
            buf[11] = MessageConversions.Split32(this.data, 3);

            buf[12] = MessageConversions.Split32(this.error, 0);
            buf[13] = MessageConversions.Split32(this.error, 1);
            buf[14] = MessageConversions.Split32(this.error, 2);
            buf[15] = MessageConversions.Split32(this.error, 3);
        }

        /// <summary>
        /// Convert a response message object from a byte array.
        /// </summary>
        /// <param name="buf">Source byte array.  Must be at least
        /// 12 bytes long.</param>
        public void FromBytes(ref byte[] buf)
        {
            if (buf.Length < 12)
                throw new System.Exception("Byte buffer is too small");

            this.command =
                MessageConversions.Build32(buf[0], buf[1], buf[2], buf[3]);

            this.pin =
                MessageConversions.Build32(buf[4], buf[5], buf[6], buf[7]);

            this.data =
                MessageConversions.Build32(buf[8], buf[9], buf[10], buf[11]);

            this.error =
                MessageConversions.Build32(buf[12], buf[13], buf[14], buf[15]);
        }
    }
}

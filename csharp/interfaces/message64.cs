// Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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

namespace IO.Interfaces.Message64
{
    /// <summary>
    /// Encapsulates 64-byte messages.
    /// </summary>
    public class Message
    {
        /// <summary>
        /// Message payload size.
        /// </summary>
        public const int Size = 64;

        /// <summary>
        /// Message payload.
        /// </summary>
        public byte[] payload;

        /// <summary>
        /// Create a message object without initializing the payload.
        /// </summary>
        public Message()
        {
            payload = new byte[Size];
        }

        /// <summary>
        /// Create a message object with an initialized payload.
        /// </summary>
        /// <param name="fill">Value to initialize the payload with.</param>
        public Message(byte fill)
        {
            payload = new byte[Size];

            for (int i = 0; i < Size; i++)
                payload[i] = fill;
        }

        /// <summary>
        /// Dump payload in hexadecimal format
        /// </summary>
        public void Dump()
        {
            for (int i = 0; i < this.payload.Length; i++)
                System.Console.Write(string.Format("{0:X2}", this.payload[i]));

            System.Console.WriteLine();
        }

        /// <summary>
        /// Fill payload with a specified byte value.
        /// </summary>
        /// <param name="fill">Value to initialize the payload with.</param>
        public void Fill(byte fill)
        {
            for (int i = 0; i < Size; i++)
                this.payload[i] = fill;
        }
    }

    /// <summary>
    /// Abstract interface for sending and receiving 64-byte messages.
    /// </summary>
    public interface Messenger
    {
        /// <summary>
        /// Send a 64-byte message.
        /// </summary>
        /// <param name="cmd">Message to be sent.</param>
        void Send(Message cmd);

        /// <summary>
        /// Receive a 64-byte message.
        /// </summary>
        /// <param name="resp">Message received.</param>
        void Receive(Message resp);

        /// <summary>
        /// Send a 64-byte command and receive a 64-byte response.
        /// </summary>
        /// <param name="cmd">Command to be sent.</param>
        /// <param name="resp">Response to be received.</param>
        void Transaction(Message cmd, Message resp);
    }
}

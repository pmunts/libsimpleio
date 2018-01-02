// Abstract interface for an SPI slave device

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

namespace IO.Interfaces.SPI
{
    /// <summary>
    /// Abstract interface for SPI slave devices.
    /// </summary>
    public interface Device
    {
        /// <summary>
        /// Read bytes from an SPI slave device.
        /// </summary>
        /// <param name="resp">Response buffer.</param>
        void Read(byte[] resp);

        /// <summary>
        /// Write bytes to an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        void Write(byte[] cmd);

        /// <summary>
        /// Write bytes to and read bytes from an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="delayus">Delay in us between write and read operations.</param>
        /// <param name="resp">Response buffer.</param>
        void Transaction(byte[] cmd, int delayus, byte[]resp);
    }
}

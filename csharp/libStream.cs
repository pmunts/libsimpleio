﻿// C# binding for Stream Framing Protocol services in libsimpleio.so

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

using System.Runtime.InteropServices;

namespace libsimpleio
{
    /// <summary>
    /// Wrapper for libsimpleio Stream Framing Protocol services.
    /// </summary>
    public class libStream
    {
        [DllImport("simpleio")]
        public static extern void STREAM_encode_frame(byte[] src, int srclen,
            byte[] dst, int dstsize, out int dstlen, out int error);

        [DllImport("simpleio")]
        public static extern void STREAM_decode_frame(byte[] src, int srclen,
            byte[] dst, int dstsize, out int dstlen, out int error);

        [DllImport("simpleio")]
        public static extern void STREAM_receive_frame(int fd, byte[] buf,
            int bufsize, out int count, out int error);

        [DllImport("simpleio")]
        public static extern void STREAM_send_frame(int fd, byte[] buf,
            int bufsize, out int count, out int error);
    }
}

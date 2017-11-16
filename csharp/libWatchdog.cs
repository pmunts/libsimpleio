// C# binding for watchdog timer services in libsimpleio.so

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

namespace EmbeddedLinux.libsimpleio
{
    public class libWatchdog
    {
        [DllImport("simpleio")]
        public static extern void WATCHDOG_open(string devname, out int fd,
            out int error);

        [DllImport("simpleio")]
        public static extern void WATCHDOG_close(int fd, out int error);

        [DllImport("simpleio")]
        public static extern void WATCHDOG_get_timeout(int fd, out int timeout,
            out int error);

        [DllImport("simpleio")]
        public static extern void WATCHDOG_set_timeout(int fd, int newtimeout,
            out int timeout, out int error);

        [DllImport("simpleio")]
        public static extern void WATCHDOG_kick(int fd, out int error);
    }
}
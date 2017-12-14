// C# binding for epoll event services in libsimpleio.so

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
    /// Wrapper for libsimpleio epoll services.
    /// </summary>
    public class libEvent
    {
        // epoll events, extracted from /usr/include/sys/epoll.h

        private const int EPOLLIN      = 0x00000001;
        private const int EPOLLPRI     = 0x00000002;
        private const int EPOLLOUT     = 0x00000004;
        private const int EPOLLRDNORM  = 0x00000040;
        private const int EPOLLRDBAND  = 0x00000080;
        private const int EPOLLWRNORM  = 0x00000100;
        private const int EPOLLWRBAND  = 0x00000200;
        private const int EPOLLMSG     = 0x00000400;
        private const int EPOLLERR     = 0x00000008;
        private const int EPOLLHUP     = 0x00000010;
        private const int EPOLLRDHUP   = 0x00002000;
        private const int EPOLLWAKEUP  = 0x20000000;
        private const int EPOLLONESHOT = 0x40000000;
        private const int EPOLLET      = -2147483648;

        [DllImport("simpleio")]
        public static extern void EVENT_open(out int epfd, out int error);

        [DllImport("simpleio")]
        public static extern void EVENT_register_fd(int epfd, int fd,
            int events, int handle, out int error);

        [DllImport("simpleio")]
        public static extern void EVENT_modify_fd(int epfd, int fd,
            int events, int handle, out int error);

        [DllImport("simpleio")]
        public static extern void EVENT_unregister_fd(int epfd, int fd,
            out int error);

        [DllImport("simpleio")]
        public static extern void EVENT_wait(int epfd, out int fd,
            out int events, out int handle, int timeoutms, out int error);

        [DllImport("simpleio")]
        public static extern void EVENT_close(int epfd, out int error);
    }
}

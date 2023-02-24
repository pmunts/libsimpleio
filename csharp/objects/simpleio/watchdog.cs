// Watchdog timer services using IO.Objects.SimpleIO

// Copyright (C)2017-2023, Philip Munts.
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

using System;

namespace IO.Objects.SimpleIO.Watchdog
{
    /// <summary>
    /// Encapsulates Linux watchdog timers using <c>libsimpleio</c>.
    /// </summary>
    public class Timer: IO.Interfaces.Watchdog.Timer
    {
        /// <summary>
        /// Default watchdog timer device name.
        ///</summary>
        public const string DefaultDevice = "/dev/watchdog";

        /// <summary>
        /// Default watchdog timer timeout value (disabled).
        /// </summary>
        public const int DefaultTimeout = 0;

        private readonly int myfd;

        /// <summary>
        /// Constructor for a single watchdog timer.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="timeout">Watchdog timeout setting in seconds, or
        /// <c>DefaultTimeout</c>.</param>
        public Timer(string devname = DefaultDevice, int timeout = DefaultTimeout)
        {
            if (timeout < 0)
            {
                throw new Exception("Invalid timeout");
            }

            IO.Bindings.libsimpleio.WATCHDOG_open(devname,
                out this.myfd, out int error);

            if (error != 0)
            {
                throw new Exception("WATCHDOG_open() failed, " +
                  errno.strerror(error));
            }

            if (timeout != DefaultTimeout)
            {
                IO.Bindings.libsimpleio.WATCHDOG_set_timeout(this.myfd,
                    timeout, out int newtimeout, out error);

                if (error != 0)
                {
                    throw new Exception("WATCHDOG_set_timeout() failed, " +
                      errno.strerror(error));
                }
            }
        }

        /// <summary>
        /// Reset the watchdog timer.
        /// </summary>
        public void Kick()
        {
            IO.Bindings.libsimpleio.WATCHDOG_kick(this.myfd,
                out int error);

            if (error != 0)
            {
                throw new Exception("WATCHDOG_kick() failed, " +
                  errno.strerror(error));
            }
        }

        /// <summary>
        /// Get or set the watchdog timeout.  Not all platforms may support
        /// this.  Even if supported, there may be constraints.  For example,
        /// some platforms allow shortening the timeout but not lengthening it.
        /// </summary>
        public int timeout
        {
            get
            {
                IO.Bindings.libsimpleio.WATCHDOG_get_timeout(this.myfd,
                    out int value, out int error);

                if (error != 0)
                {
                    throw new Exception("WATCHDOG_get_timeout() failed, " +
                      errno.strerror(error));
                }

                return value;
            }

            set
            {
                if (timeout < 0)
                {
                    throw new Exception("Invalid timeout");
                }

                IO.Bindings.libsimpleio.WATCHDOG_set_timeout(this.myfd,
                    value, out int newtimeout, out int error);

                if (error != 0)
                {
                    throw new Exception("WATCHDOG_set_timeout() failed, " +
                      errno.strerror(error));
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// watchdog timer.
        /// </summary>
        public int fd
        {
            get
            {
                return this.myfd;
            }
        }
    }
}

// C# binding for system call wrappers in libsimpleio.so

// Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

namespace IO.Bindings
{
    public static partial class libsimpleio
    {
        /// <summary>
        /// Use the program name for the identity string.
        /// </summary>
        public const string LOG_PROGNAME = "";

        // Facilities -- Extracted from syslog.h

        /// <summary>
        /// Kernel messages.
        /// </summary>
        public const int LOG_KERN = (0 << 3);
        /// <summary>
        /// Random user-level messages.
        /// </summary>
        public const int LOG_USER = (1 << 3);
        /// <summary>
        /// Mail system.
        /// </summary>
        public const int LOG_MAIL = (2 << 3);
        /// <summary>
        /// System daemons.
        /// </summary>
        public const int LOG_DAEMON = (3 << 3);
        /// <summary>
        /// Security/authorization messages.
        /// </summary>
        public const int LOG_AUTH = (4 << 3);
        /// <summary>
        /// Messages generated internally by syslogd
        /// </summary>
        public const int LOG_SYSLOG = (5 << 3);
        /// <summary>
        /// Line printer subsystem
        /// </summary>
        public const int LOG_LPR = (6 << 3);
        /// <summary>
        /// Network news subsystem
        /// </summary>
        public const int LOG_NEWS = (7 << 3);
        /// <summary>
        /// UUCP subsystem
        /// </summary>
        public const int LOG_UUCP = (8 << 3);
        /// <summary>
        /// <c>cron</c> daemon messages.
        /// </summary>
        public const int LOG_CRON = (9 << 3);
        /// <summary>
        /// Securit/authorization messages.
        /// </summary>
        public const int LOG_AUTHPRIV = (10 << 3);
        /// <summary>
        /// <c>FTP</c> daemon messages.
        /// </summary>
        public const int LOG_FTP = (11 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL0 = (16 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL1 = (17 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL2 = (18 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL3 = (19 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL4 = (20 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL5 = (21 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL6 = (22 << 3);
        /// <summary>
        /// Reserved for local use.
        /// </summary>
        public const int LOG_LOCAL7 = (23 << 3);

        // Options -- Extracted from syslog.h

        /// <summary>
        /// Write directly to the system console if there is an error while
        /// sending to the system logger.
        /// </summary>
        public const int LOG_CONS = 0x02;
        /// <summary>
        /// Open the connection immediately.  Do not wait until <c>syslog()</c>
        /// is called for the first time.
        /// </summary>
        public const int LOG_NDELAY = 0x08;
        /// <summary>
        /// Don't  wait for child processes that may have been created while 
        /// logging the message.  (Not applicable to <c>glibc</c>.)
        /// </summary>
        public const int LOG_NOWAIT = 0x10;
        /// <summary>
        /// Do not open the connection immediately.  Wait until <c>syslog()</c>
        /// is called for the first time.
        /// </summary>
        public const int LOG_ODELAY = 0x04;
        /// <summary>
        /// Also log the message to <c>stderr</c>.
        /// </summary>
        public const int LOG_PERROR = 0x20;
        /// <summary>
        /// Include the caller's PID (process ID) with each message.
        /// </summary>
        public const int LOG_PID = 0x01;

        // Priorities -- Extracted from syslog.h

        /// <summary>
        /// System is unusable.
        /// </summary>
        public const int LOG_EMERG = 0;
        /// <summary>
        /// Action must be taken immediately.
        /// </summary>
        public const int LOG_ALERT = 1;
        /// <summary>
        /// Critical condition.
        /// </summary>
        public const int LOG_CRIT = 2;
        /// <summary>
        /// Error condition.
        /// </summary>
        public const int LOG_ERR = 3;
        /// <summary>
        /// Warning condition.
        /// </summary>
        public const int LOG_WARNING = 4;
        /// <summary>
        /// Normal but significant condition.
        /// </summary>
        public const int LOG_NOTICE = 5;
        /// <summary>
        /// Informational message.
        /// </summary>
        public const int LOG_INFO = 6;
        /// <summary>
        /// Debug message.
        /// </summary>
        public const int LOG_DEBUG = 7;

        /// <summary>
        /// Detach the process and run it in the background.
        /// </summary>
        /// <param name="error">Error code.  Zero upon success or an
        /// <c>errno</c> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_detach(out int error);

        /// <summary>
        /// Drop process privileges to those of the specified user.
        /// <remarks>Only a process running at superuser privilege is allowed
        /// to drop privileges.</remarks>
        /// </summary>
        /// <param name="username">User privileges to assume.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <c>errno</c> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_drop_privileges(string username,
            out int error);

        /// <summary>
        /// Open a connection to the <c>syslog</c> service.
        /// </summary>
        /// <param name="id">Program identifier.</param>
        /// <param name="options">Logging options.</param>
        /// <param name="facility">Logging facility identifier.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <c>errno</c> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_openlog(string id, int options,
            int facility, out int error);

        /// <summary>
        /// Send a message to the <c>syslog</c> service.
        /// </summary>
        /// <param name="priority">Message priority</param>
        /// <param name="msg">Message to send.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <c>errno</c> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_syslog(int priority, string msg,
            out int error);

        /// <summary>
        /// Fetch the value of <c>errno</c>.
        /// </summary>
        /// <returns>Current value of <c>errno</c>.</returns>
        [DllImport("simpleio")]
        public static extern int LINUX_errno();

        /// <summary>
        /// Retrieve the error message for a particular <c>errno</c>
        /// error code.
        /// </summary>
        /// <param name="error">Error code.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_strerror(int error,
            System.Text.StringBuilder buf, int bufsize);

        /// <summary>
        /// There is data to read.
        /// </summary>
        public const int POLLIN = 0x01;
        /// <summary>
        /// There is urgent data to read.
        /// </summary>
        public const int POLLPRI = 0x02;
        /// <summary>
        /// Writing is now possible.
        /// </summary>
        public const int POLLOUT = 0x04;
        /// <summary>
        /// An error occurred.
        /// </summary>
        public const int POLLERR = 0x08;
        /// <summary>
        /// Peer closed connection.
        /// </summary>
        public const int POLLHUP = 0x10;
        /// <summary>
        /// File descriptor is invalid.
        /// </summary>
        public const int POLLNVAL = 0x20;

        /// <summary>
        /// Wait for an event on one or more files.
        /// </summary>
        /// <param name="numfiles">Number elements in each of the
        /// following arrays.</param>
        /// <param name="files">File descriptors.</param>
        /// <param name="events">Events to wait for on each file
        /// descriptor.</param>
        /// <param name="results">Events that occurred on each file
        /// descriptor.</param>
        /// <param name="timeoutms">Milliseconds to wait for an event
        /// to occur.  A value of -1 means wait forever and a value
        /// of 0 means do not wait at all.</param>
        /// <param name="error">Error code.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_poll(int numfiles, int[] files,
            int[] events, int[] results, int timeoutms, out int error);

        /// <summary>
        /// Sleep for the specified number of microseconds.
        /// </summary>
        /// <param name="microsecs">Number of microseconds to sleep.</param>
        /// <param name="error">Error code.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_usleep(int microsecs, out int error);

        /// <summary>
        /// Execute a shell command string.
        /// </summary>
        /// <param name="cmd">Command string.</param>
        /// <param name="error">Error code.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_command(string cmd, out int error);
    }
}

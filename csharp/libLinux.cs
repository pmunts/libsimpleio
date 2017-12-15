// C# binding for system call wrappers in libsimpleio.so

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
    /// Wrapper for libsimpleio Linux system call services.
    /// </summary>
    public class libLinux
    {
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
        /// <code>cron</code> daemon messages.
        /// </summary>
        public const int LOG_CRON = (9 << 3);
        /// <summary>
        /// Securit/authorization messages.
        /// </summary>
        public const int LOG_AUTHPRIV = (10 << 3);
        /// <summary>
        /// <code>FTP</code> daemon messages.
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
        /// <code>errno</code> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_detach(out int error);

        /// <summary>
        /// Drop process privileges to those of the specified user.
        /// <remarks>Only a process running at superuser privilege is allowed
        /// to drop privileges.</remarks>
        /// </summary>
        /// <param name="username">User privileges to assume.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <code>errno</code> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_drop_privileges(string username,
            out int error);

        /// <summary>
        /// Open a connection to the <code>syslog</code> service.
        /// </summary>
        /// <param name="id">Program identifier.</param>
        /// <param name="options">Logging options.</param>
        /// <param name="facility">Logging facility identifier.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <code>errno</code> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_openlog(string id, int options,
            int facility, out int error);

        /// <summary>
        /// Send a message to the <code>syslog</code> service.
        /// </summary>
        /// <param name="priority">Message priority</param>
        /// <param name="msg">Message to send.</param>
        /// <param name="error">Error code.  Zero upon success or an
        /// <code>errno</code> value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_syslog(int priority, string msg,
            out int error);

        /// <summary>
        /// Retrieve the error message for a particular <code>errno</code>
        /// error code.
        /// </summary>
        /// <param name="error">Error code.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        [DllImport("simpleio")]
        public static extern void LINUX_strerror(int error,
            System.Text.StringBuilder buf, int bufsize);
    }
}
'
'
'

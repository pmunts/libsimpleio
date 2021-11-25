// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.libsimpleio.syslog
{
    /// <summary>
    /// Encapsulates system logging services using <c>libsimpleio</c>.
    /// </summary>
    public class Logger : IO.Interfaces.Log.Logger
    {
        // <c>syslog</c> options (can be added together):

        /// <summary>
        /// Open the connection to the <c>syslog</c> subsystem immediately.
        /// Recommended.
        /// </summary>
        public const int LOG_NDELAY = IO.Bindings.libsimpleio.LOG_NDELAY;
        /// <summary>
        /// Do not open the connection to the <c>syslog</c> subsystem before
        /// logging the first message.  Not recommended.
        /// </summary>
        public const int LOG_ODELAY = IO.Bindings.libsimpleio.LOG_NDELAY;
        /// <summary>
        /// Write message to both <c>syslog</c> subsystem AND <c>stderr</c>.
        /// </summary>
        public const int LOG_PERROR = IO.Bindings.libsimpleio.LOG_PERROR;
        /// <summary>
        /// Prepend the caller's process ID to the message.
        /// </summary>
        public const int LOG_PID = IO.Bindings.libsimpleio.LOG_PID;

        // <c>syslog</c> facilities:

        /// <summary>
        /// Authentication facility.
        /// </summary>
        public const int LOG_AUTH = IO.Bindings.libsimpleio.LOG_AUTH;
        /// <summary>
        /// System daemon/background process facility.
        /// </summary>
        public const int LOG_DAEMON = IO.Bindings.libsimpleio.LOG_DAEMON;
        /// <summary>
        /// Mail subsystem facility.
        /// </summary>
        public const int LOG_MAIL = IO.Bindings.libsimpleio.LOG_MAIL;
        /// <summary>
        /// User program facility.  Use <c>LOG_LOCALx</c> instead.
        /// </summary>
        public const int LOG_USER = IO.Bindings.libsimpleio.LOG_USER;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL0 = IO.Bindings.libsimpleio.LOG_LOCAL0;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL1 = IO.Bindings.libsimpleio.LOG_LOCAL1;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL2 = IO.Bindings.libsimpleio.LOG_LOCAL2;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL3 = IO.Bindings.libsimpleio.LOG_LOCAL3;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL4 = IO.Bindings.libsimpleio.LOG_LOCAL4;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL5 = IO.Bindings.libsimpleio.LOG_LOCAL5;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL6 = IO.Bindings.libsimpleio.LOG_LOCAL6;
        /// <summary>
        /// Locally defined facility.
        /// </summary>
        public const int LOG_LOCAL7 = IO.Bindings.libsimpleio.LOG_LOCAL7;

        /// <summary>
        /// Constructor for a logging object that uses the Linux
        /// <c>syslog</c> subsystem.
        /// </summary>
        /// <param name="id">Program identifier string.</param>
        /// <param name="options"><c>syslog</c> options.</param>
        /// <param name="facility"><c>syslog</c> facility.</param>
        public Logger(string id, int facility,
            int options = LOG_PERROR + LOG_PID)
        {
            int error;

            IO.Bindings.libsimpleio.LINUX_openlog(id, options, facility, out error);
        }

        /// <summary>
        /// Log an error message.
        /// </summary>
        /// <param name="message">Error message.</param>
        public void Error(string message)
        {
            int error;

            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_ERR,
                message,
                out error);
        }

        /// <summary>
        /// Log an error message, including an <c>errno</c> error string.
        /// </summary>
        /// <param name="message">Error Message.</param>
        /// <param name="errnum"><c>errno</c> error number.</param>
        public void Error(string message, int errnum)
        {
            int error;

            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_ERR,
                message,
                out error);
        }

        /// <summary>
        /// Log a warning message.
        /// </summary>
        /// <param name="message">Warning message.</param>
        public void Warning(string message)
        {
            int error;

            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_WARNING,
                message,
                out error);
        }

        /// <summary>
        /// 
        /// Log a notification message.
        /// </summary>
        /// <param name="message">Notification message.</param>
        public void Note(string message)
        {
            int error;

            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_NOTICE,
                message,
                out error);
        }
    }
}
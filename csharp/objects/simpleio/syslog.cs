// Copyright (C)2021-2023, Philip Munts.
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

namespace IO.Objects.SimpleIO.syslog
{
    /// <summary>
    /// Encapsulates system logging services using <c>libsimpleio</c>.
    /// </summary>
    /// <remarks>An instance of this class can be used either standalone or
    /// as a <c>System.Diagnostics.TraceListener</c>.  The static methods
    /// <c>Systems.Diagnostics.Trace.Write()</c> and
    /// <c>Systems.Diagnostics.Trace.WriteIf()</c> most naturally fit the
    /// Linux <c>syslog</c> facility.</remarks>
    /// <example>
    /// <code>
    /// using static System.Diagnostics.Trace;
    ///
    /// Listeners.RemoveAt(0);
    /// Listeners.Add(new IO.Objects.SimpleIO.syslog.Logger("HelloWorld"));
    ///
    /// Write("Hello, World!");
    /// </code>
    /// </example>
    public class Logger : System.Diagnostics.TraceListener
    {
        private readonly int severity;

        // <c>syslog</c> options (can be added together):

        /// <summary>
        /// Open the connection to the <c>syslog</c> service immediately.
        /// Recommended.
        /// </summary>
        public const int LOG_NDELAY = IO.Bindings.libsimpleio.LOG_NDELAY;
        /// <summary>
        /// Do not open the connection to the <c>syslog</c> service before
        /// logging the first message.  Not recommended.
        /// </summary>
        public const int LOG_ODELAY = IO.Bindings.libsimpleio.LOG_NDELAY;
        /// <summary>
        /// Write message to both <c>syslog</c> service AND <c>stderr</c>.
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

        // <c>syslog</c> severity levels

        /// <summary>
        /// Emergency condition message.
        /// </summary>
        public const int LOG_EMERG = IO.Bindings.libsimpleio.LOG_EMERG;
        /// <summary>
        /// Alert condition message.
        /// </summary>
        public const int LOG_ALERT = IO.Bindings.libsimpleio.LOG_ALERT;
        /// <summary>
        /// Critical condition message.
        /// </summary>
        public const int LOG_CRIT = IO.Bindings.libsimpleio.LOG_CRIT;
        /// <summary>
        /// Error message.
        /// </summary>
        public const int LOG_ERR = IO.Bindings.libsimpleio.LOG_ERR;
        /// <summary>
        /// Warning message.
        /// </summary>
        public const int LOG_WARNING = IO.Bindings.libsimpleio.LOG_WARNING;
        /// <summary>
        /// Normal condition message.
        /// </summary>
        public const int LOG_NOTICE = IO.Bindings.libsimpleio.LOG_NOTICE;
        /// <summary>
        /// Informational message.
        /// </summary>
        public const int LOG_INFO = IO.Bindings.libsimpleio.LOG_INFO;
        /// <summary>
        /// Debug message.
        /// </summary>
        public const int LOG_DEBUG = IO.Bindings.libsimpleio.LOG_DEBUG;

        /// <summary>
        /// Constructor for a logging object that uses the Linux
        /// <c>syslog</c> service.
        /// </summary>
        /// <param name="id">Program identifier string.</param>
        /// <param name="facility"><c>syslog</c> facility.</param>
        /// <param name="options"><c>syslog</c> options.</param>
        /// <param name="severity"><c>syslog</c> severity level.</param>
        public Logger(string id = "@@APPNAME@@", int facility = LOG_LOCAL0,
            int options = LOG_PERROR, int severity = LOG_INFO)
        {
            if (id == "@@APPNAME@@")
            {
                id = System.AppDomain.CurrentDomain.FriendlyName;
            }

            IO.Bindings.libsimpleio.LINUX_openlog(id, options, facility,
                out int error);
            this.severity = severity;
        }

        /// <summary>
        /// Log an error message.
        /// </summary>
        /// <param name="message">Error message.</param>
        public void Error(string message)
        {
            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_ERR,
                message,
                out int error);
        }

        /// <summary>
        /// Log an error message, including an <c>errno</c> error string.
        /// </summary>
        /// <param name="message">Error Message.</param>
        /// <param name="errnum"><c>errno</c> error number.</param>
        public void Error(string message, int errnum)
        {
            System.Text.StringBuilder errmsg = new System.Text.StringBuilder(256);

            IO.Bindings.libsimpleio.LINUX_strerror(errnum, errmsg,
                errmsg.Capacity);

            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_ERR,
                message + ", " + errmsg,
                out int error);
        }

        /// <summary>
        /// Log a warning message.
        /// </summary>
        /// <param name="message">Warning message.</param>
        public void Warning(string message)
        {
            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_WARNING,
                message,
                out int error);
        }

        /// <summary>
        /// Log a notification message.
        /// </summary>
        /// <param name="message">Notification message.</param>
        public void Note(string message)
        {
            IO.Bindings.libsimpleio.LINUX_syslog
                (IO.Bindings.libsimpleio.LOG_NOTICE,
                message,
                out int error);
        }

        /// <summary>
        /// Trace interface method for posting a message.
        /// This method implementation is identical to <c>WriteLine()</c>,
        /// because <c>syslog</c> is not a stream oriented service.
        /// </summary>
        /// <param name="message">Trace message.</param>
        public override void Write(string message)
        {
            IO.Bindings.libsimpleio.LINUX_syslog(this.severity, message,
                out int error);
        }

        /// <summary>
        /// Trace interface method for posting a message.
        /// </summary>
        /// <param name="message">Trace message.</param>
        public override void WriteLine(string message)
        {
            IO.Bindings.libsimpleio.LINUX_syslog(this.severity, message,
                out int error);
        }

        /// <summary>
        /// <c>TraceListener</c> registration options.
        /// </summary>
        public enum Registration
        {
            /// <summary>
            /// Add to the <c>TraceListener</c> list.
            /// </summary>
            Append,
            /// <summary>
            /// Replace all <c>TraceListener</c> list items.
            /// </summary>
            Replace
        }

        /// <summary>
        /// Register a new <c>Logger</c> instance as a <c>TraceListener</c>.
        /// </summary>
        /// <param name="id">Program identifier string.</param>
        /// <param name="facility"><c>syslog</c> facility.</param>
        /// <param name="options"><c>syslog</c> options.</param>
        /// <param name="severity"><c>syslog</c> severity level.</param>
        /// <param name="reghow">How to register the <c>TraceListener</c>
        /// instance.</param>
        /// <example>
        /// <code>
        /// using static System.Diagnostics.Trace;
        ///
        /// IO.Objects.SimpleIO.syslog.Logger.Register("HelloWorld");
        ///
        /// Write("Hello, World!");
        /// </code>
        /// </example>
        public static void Register(string id = "@@APPNAME@@", int facility = LOG_LOCAL0,
            int options = LOG_PERROR, int severity = LOG_INFO,
            Registration reghow = Registration.Replace)
        {
            if (id == "@@APPNAME@@")
            {
                id = System.AppDomain.CurrentDomain.FriendlyName;
            }

            while ((reghow == Registration.Replace) &&
                (System.Diagnostics.Trace.Listeners.Count > 0))
                System.Diagnostics.Trace.Listeners.RemoveAt(0);

            System.Diagnostics.Trace.Listeners.Add(new Logger(id, facility,
                options, severity));
        }
    }
}

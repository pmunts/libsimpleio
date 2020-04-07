// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.libsimpleio.Exceptions
{
    /// <summary>
    /// Encapsulates exceptions that may include an optional
    /// <c>errno</c> value.
    /// </summary>
    public class Exception: System.Exception
    {
        /// <summary>
        /// Constructor for an exception that writes an error message to
        /// standard output.
        /// </summary>
        /// <param name="message">Error message.</param>
        public Exception(string message)
        {
            System.Console.WriteLine(message);
        }

        /// <summary>
        /// Constructor for an exception that writes an error message
        /// including an <c>errno</c> value.
        /// </summary>
        /// <param name="message">Error message.</param>
        /// <param name="error">Error code.</param>
        public Exception(string message, int error)
        {
            System.Text.StringBuilder buf = new System.Text.StringBuilder(256);
            IO.Bindings.libsimpleio.libLinux.LINUX_strerror(error, buf,
                buf.Capacity);
            System.Console.WriteLine(message + ", " + buf.ToString());
        }
    }
}

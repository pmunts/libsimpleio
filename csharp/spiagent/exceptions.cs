// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// exception definitions

// Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

namespace SPIAgent
{
    /// <summary>
    /// This exception is raised upon detection of a Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware transport failure.
    /// </summary>
    public class SPIAgent_Transport_Exception : System.Exception
    {
        /// <summary>
        /// Default parameterless constructor
        /// </summary>
        public SPIAgent_Transport_Exception() : base()
        {
        }

        /// <summary>
        /// Constructor including an error message string
        /// </summary>
        /// <param name="message">Error message</param>
        public SPIAgent_Transport_Exception(string message) : base(message)
        {
        }

        /// <summary>
        /// Constructor including an error message string and an inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
        public SPIAgent_Transport_Exception(string message, System.Exception inner) : base(message, inner)
        {
        }
    }

    /// <summary>
    /// This exception is raised upon detection of a Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware error.
    /// </summary>
    public class SPIAgent_Exception : System.Exception
    {
        /// <summary>
        /// Default parameterless constructor
        /// </summary>
        public SPIAgent_Exception() : base()
        {
        }

        /// <summary>
        /// Constructor including an error message string
        /// </summary>
        /// <param name="message">Error message</param>
        public SPIAgent_Exception(string message) : base(message)
        {
        }

        /// <summary>
        /// Constructor including an error message string and an inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
        public SPIAgent_Exception(string message, System.Exception inner) : base(message, inner)
        {
        }
    }
}

// Send an email message via /usr/bin/mail

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.Email.Mail
{
    /// <summary>
    /// This class implements the <c>IO.Interfaces.Messaging.Text.Relay</c>
    /// interface, for sending an email message via the Unix program
    /// <c>/usr/bin/mail</c>.
    /// </summary>
    public class Relay : IO.Interfaces.Message.Text.Relay
    {
        private static string Quote(string s)
        {
            return "\"" + s + "\"";
        }

        /// <summary>
        /// Constructor for a single mail relay.
        /// </summary>
        public Relay()
        {
            if (!System.IO.File.Exists("/usr/bin/mail"))
                throw new Exception("Cannot find /usr/bin/mail.");
        }

        /// <summary>
        /// Method for sending an email message.
        /// </summary>
        /// <param name="recipient">Originator email address.</param>
        /// <param name="subject">Recipient email address.</param>
        /// <param name="message">Email message body.</param>
        public void Send(string recipient, string subject, string message)
        {
            Send("", recipient, subject, message, "");
        }

        /// <summary>
        /// Method for sending an email message.
        /// </summary>
        /// <param name="sender">Originator email address.</param>
        /// <param name="recipient">Recipient email address.</param>
        /// <param name="subject">Subject of the email message.</param>
        /// <param name="message">Email message body.</param>
        public void Send(string sender, string recipient, string subject, string message)
        {
            Send(sender, recipient, subject, message, "");
        }

        /// <summary>
        /// Method for sending an email message with an attachment.
        /// </summary>
        /// <param name="sender">Originator email address.</param>
        /// <param name="recipient">Recipient email address.</param>
        /// <param name="subject">Subject of the email message.</param>
        /// <param name="message">Email message body.</param>
        /// <param name="attachment">Attachment file name.</param>
        public void Send(string sender, string recipient, string subject,
            string message, string attachment)
        {
            using (var mail = new System.Diagnostics.Process())
            {
                // Validate parameters

                if (sender.IndexOf("\"") != -1)
                    throw new Exception(" sender argument contains a double quote character.");

                if ((sender.Length > 0) && (sender.Length < 6))
                    throw new Exception("sender argument is too short.");

                if (recipient.IndexOf("\"") != -1)
                    throw new Exception("recipient argument contains a double quote character.");

                if (recipient.Length < 6)
                    throw new Exception("recipient argument is too short.");

                if (subject.IndexOf("\"") != -1)
                    throw new Exception("subject argument contains a double quote character.");

                if (attachment.IndexOf("\"") != -1)
                    throw new Exception("attachment argument contains a double quote character.");

                if ((attachment.Length > 0) && !System.IO.File.Exists(attachment))
                    throw new Exception("attachment file cannot be read.");

                // Assemble command line arguments

                string args = "";
                if (sender != "") args += "-r " + Quote(sender) + " ";
                if (subject != "") args += "-s " + Quote(subject) + " ";
                if (attachment != "") args += "-A " + Quote(attachment) + " ";
                args += recipient;

                // Set the rest of the process start settings

                mail.StartInfo.FileName = "/usr/bin/mail";
                mail.StartInfo.Arguments = args;
                mail.StartInfo.CreateNoWindow = true;
                mail.StartInfo.UseShellExecute = false;
                mail.StartInfo.RedirectStandardInput = true;
                mail.StartInfo.RedirectStandardOutput = false;
                mail.StartInfo.RedirectStandardError = false;

                // Dispatch the message

                mail.Start();
                mail.StandardInput.WriteLine(message);
                mail.StandardInput.Close();
                mail.WaitForExit(5000);
            }
        }
    }
}

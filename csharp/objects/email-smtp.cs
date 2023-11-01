// Send an email message via SMTP

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

namespace IO.Objects.Email.SMTP
{
    /// <summary>
    /// This class implements the <c>IO.Interfaces.Messaging.Text.Relay</c>
    /// interface, for sending an email message via SMTP (Simple Mail Transfer
    /// Protocol).
    /// </summary>
    public class Relay : IO.Interfaces.Message.Text.Relay
    {
        private readonly System.Net.Mail.SmtpClient mailer;

        /// <summary>
        /// Constructor for a single SMTP mail relay.
        /// </summary>
        /// <param name="server">SMTP server domain name or IP addaress.</param>
        /// <param name="port">SMTP server TCP port number.</param>
        public Relay(string server = "localhost", int port = 25)
        {
            mailer = new System.Net.Mail.SmtpClient(server, port);
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

                if ((sender.Length > 0) && (sender.Length < 6))
                    throw new Exception("sender argument is too short.");

                if (sender.Length == 0)
                    sender = System.Environment.UserName + "@" + System.Net.Dns.GetHostName();

                if (recipient.Length < 6)
                    throw new Exception("recipient argument is too short.");

                if ((attachment.Length > 0) && !System.IO.File.Exists(attachment))
                    throw new Exception("attachment file cannot be read.");

                // Build the message

                var msg = new System.Net.Mail.MailMessage();

                msg.From = new System.Net.Mail.MailAddress(sender);
                msg.To.Add(new System.Net.Mail.MailAddress(recipient));
                msg.Subject = subject;
                msg.Body = message;

                if (attachment.Length > 0)
                    msg.Attachments.Add(new System.Net.Mail.Attachment(attachment));

                // Dispatch the message

                this.mailer.Send(msg);
            }
        }
    }
}

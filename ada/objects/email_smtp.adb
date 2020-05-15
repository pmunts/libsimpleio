-- SMTP object definitions

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH AWS.SMTP.Client;

PACKAGE BODY Email_SMTP IS

  -- SMTP mail relay object constructor

  FUNCTION Create(servername : String := "localhost")
    RETURN Messaging.Text.Relay IS

  BEGIN
    RETURN NEW RelaySubclass'(mailrelay =>
      Standard.AWS.SMTP.Client.Initialize(servername));
  END Create;

  -- Send an email

  PROCEDURE Send
   (self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String := "") IS

    result : Standard.AWS.SMTP.Status;

  BEGIN
    Standard.AWS.SMTP.Client.Send
     (Server  => self.mailrelay,
      From    => Standard.AWS.SMTP.E_Mail("", sender),
      To      => Standard.AWS.SMTP.E_Mail("", recipient),
      Subject => subject,
      Message => message,
      Status  => result);

    IF NOT Standard.AWS.SMTP.Is_OK(result) THEN
      RAISE Messaging.Text.RelayError WITH
        Standard.AWS.SMTP.Status_Message(result);
    END IF;
  END Send;

END Email_SMTP;
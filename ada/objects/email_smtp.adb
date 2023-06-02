-- Send email via SMTP to localhost:25

-- Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

WITH AWS.SMTP.Authentication.Plain;

PACKAGE BODY Email_SMTP IS

  -- Mail relay object constructor

  FUNCTION Create
   (server   : String  := "localhost";
    port     : Natural := 25;
    secure   : Boolean := False;
    username : String  := "";
    password : String  := "") RETURN Messaging.Text.Relay IS

    Self : RelaySubclass := Destroyed;

  BEGIN
    Self.Initialize(server, port, secure, username, password);
    RETURN NEW RelaySubclass'(Self);
  END Create;

  -- Mail relay object initializer

  PROCEDURE Initialize
   (Self     : IN OUT RelaySubclass;
    server   : String  := "localhost";
    port     : Natural := 25;
    secure   : Boolean := False;
    username : String  := "";
    password : String  := "") IS

    creds : ACCESS AWS.SMTP.Authentication.Plain.Credential := NULL;

  BEGIN
    Self.Destroy;

    -- Validate parameters

    IF username = "" AND password /= "" THEN
      RAISE Messaging.Text.RelayError WITH "Username required.";
    END IF;

    IF username /= "" AND password = "" THEN
      RAISE Messaging.Text.RelayError WITH "Password required.";
    END IF;

    -- Build credentials

    PRAGMA Warnings(Off, "use of an anonymous access type allocator");

    IF username /= "" AND password /= "" THEN
      creds := NEW AWS.SMTP.Authentication.Plain.Credential'(AWS.SMTP.Authentication.Plain.Initialize(username, password));
    END IF;

    Self.mailrelay := AWS.SMTP.Client.Initialize(server, port, secure,
      Credential => creds);
  END Initialize;

  -- Mail relay object destroyer

  PROCEDURE Destroy(Self : IN OUT RelaySubclass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- Check whether Mail relay object has been destroyed

  PROCEDURE CheckDestroyed(Self : RelaySubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Messaging.Text.RelayError WITH "Mail relay object has been destroyed";
    END IF;
  END CheckDestroyed;

  -- Send an email

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String) IS

    result : AWS.SMTP.Status;

  BEGIN
    Self.CheckDestroyed;

    AWS.SMTP.Client.Send
     (Server  => Self.mailrelay,
      From    => AWS.SMTP.E_Mail("", sender),
      To      => AWS.SMTP.E_Mail("", recipient),
      Subject => subject,
      Message => message,
      Status  => result);

    IF NOT AWS.SMTP.Is_OK(result) THEN
      RAISE Messaging.Text.RelayError WITH
        AWS.SMTP.Status_Message(result);
    END IF;
  END Send;

END Email_SMTP;

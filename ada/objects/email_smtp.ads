-- Send email via SMTP to localhost:25

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

WITH Messaging.Text;

PRIVATE WITH AWS.SMTP.Client;

PACKAGE Email_SMTP IS

  -- Mail relay object type

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH PRIVATE;

  Destroyed : CONSTANT RelaySubclass;

  -- Mail relay object constructor

  FUNCTION Create
   (server   : String  := "localhost";
    port     : Natural := 25;
    secure   : Boolean := False;
    username : String  := "";
    password : String  := "") RETURN Messaging.Text.Relay;

  -- Mail relay object initializer

  PROCEDURE Initialize
   (Self     : IN OUT RelaySubclass;
    server   : String  := "localhost";
    port     : Natural := 25;
    secure   : Boolean := False;
    username : String  := "";
    password : String  := "");

  -- Mail relay object destroyer

  PROCEDURE Destroy(Self : IN OUT RelaySubclass);

  -- Send an email

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String);

PRIVATE

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH RECORD
    mailrelay : Standard.AWS.SMTP.Receiver;
  END RECORD;

  Destroyed : CONSTANT RelaySubclass :=
    RelaySubclass'(mailrelay => AWS.SMTP.Client.Initialize("foo.invalid"));
END Email_SMTP;

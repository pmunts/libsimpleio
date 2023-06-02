-- Send email via https://mailrelay.munts.net

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

PRIVATE WITH Ada.Strings.Unbounded;

PACKAGE Email_HTTP IS

  -- Mail relay object type

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH PRIVATE;

  Destroyed : CONSTANT RelaySubclass;

  DefaultServer : CONSTANT String := "https://mailrelay.munts.net/mailrelay.cgi";

  -- Mail relay object constructor

  FUNCTION Create
   (Server   : String := DefaultServer;
    Username : String := "";
    Password : String := "") RETURN Messaging.Text.Relay;

  -- Mail relay object initializer

  PROCEDURE Initialize
   (Self     : IN OUT RelaySubclass;
    Server   : String := DefaultServer;
    Username : String := "";
    Password : String := "");

  -- Mail relay object destroyer

  PROCEDURE Destroy(Self : IN OUT RelaySubclass);

  -- Check whether Mail relay object has been destroyed

  PROCEDURE CheckDestroyed(Self : RelaySubclass);

  -- Send an email

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String);

PRIVATE

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH RECORD
    server   : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    username : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    password : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
  END RECORD;

  Destroyed : CONSTANT RelaySubclass :=
    RelaySubclass'(Ada.Strings.Unbounded.Null_Unbounded_String,
      Ada.Strings.Unbounded.Null_Unbounded_String,
      Ada.Strings.Unbounded.Null_Unbounded_String);

END Email_HTTP;

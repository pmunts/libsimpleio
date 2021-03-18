-- Send email via https://mailrelay.munts.net

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;

WITH AWS.Client;
WITH AWS.Response;
WITH AWS.URL;

PACKAGE BODY Email_HTTP IS

  -- Mail relay object constructor

  FUNCTION Create
   (URL      : String := "https://mailrelay.munts.net/mailrelay.cgi";
    Username : String;
    Password : String) RETURN Messaging.Text.Relay IS

    relay : RelaySubclass;

  BEGIN
    relay.Initialize(URL, Username, Password);
    RETURN NEW RelaySubclass'(relay);
  END Create;

  -- Mail relay object initializer

  PROCEDURE Initialize
   (Self : IN OUT RelaySubclass;
    URL      : String := "https://mailrelay.munts.net/mailrelay.cgi";
    Username : String;
    Password : String) IS

  BEGIN
    Self.Destroy;
    Self.URL  := Ada.Strings.Unbounded.To_Unbounded_String(URL);
    Self.User := Ada.Strings.Unbounded.To_Unbounded_String(Username);
    Self.Pass := Ada.Strings.Unbounded.To_Unbounded_String(Password);
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

    resp : AWS.Response.Data;

  BEGIN
    Self.CheckDestroyed;

    resp := AWS.Client.Post(Ada.Strings.Unbounded.To_String(Self.URL),
      Content_Type => "application/x-www-form-urlencoded",
      User         => Ada.Strings.Unbounded.To_String(Self.User),
      Pwd          => Ada.Strings.Unbounded.To_String(Self.Pass),
      Data         =>
        "SENDER="    & AWS.URL.Encode(SENDER)    & "&" &
        "RECIPIENT=" & AWS.URL.Encode(RECIPIENT) & "&" &
        "SUBJECT="   & AWS.URL.Encode(SUBJECT)   & "&" &
        "MESSAGE="   & AWS.URL.Encode(MESSAGE));
  END Send;

END Email_HTTP;
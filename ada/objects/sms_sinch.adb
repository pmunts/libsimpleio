-- SMS messaging services using Sinch (https://www.sinch.com)

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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Environment_Variables;
WITH Ada.Strings.Unbounded;

WITH AWS.Client;
WITH AWS.Response;
WITH AWS.URL;

USE ALL TYPE Ada.Strings.Unbounded.Unbounded_String;

PACKAGE BODY SMS_Sinch IS

  -- SMS relay object constructor

  FUNCTION Create
   (server   : String := SMS1;
    username : String := "";
    password : String := "") RETURN Messaging.Text.Relay IS

    relay : RelaySubclass;

  BEGIN
    relay.Initialize(server, username, password);
    RETURN NEW RelaySubclass'(relay);
  END Create;

  -- SMS relay object initializer

  PROCEDURE Initialize
   (Self : IN OUT RelaySubclass;
    Server   : String := SMS1;
    Username : String := "";
    Password : String := "") IS

  BEGIN
    Self.Destroy;

    Self.server := To_Unbounded_String(Server);

    IF username = "" THEN
      Self.username := To_Unbounded_String(Ada.Environment_Variables.Value("SMSUSER"));
    ELSE
      Self.username := To_Unbounded_String(username);
    END IF;

    IF password = "" THEN
      Self.password := To_Unbounded_String(Ada.Environment_Variables.Value("SMSPASS"));
    ELSE
      Self.password := To_Unbounded_String(password);
    END IF;
  END Initialize;

  -- SMS relay object destroyer

  PROCEDURE Destroy(Self : IN OUT RelaySubclass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- Check whether SMS relay object has been destroyed

  PROCEDURE CheckDestroyed(Self : RelaySubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Messaging.Text.RelayError WITH "Mail relay object has been destroyed";
    END IF;
  END CheckDestroyed;

  -- Method for sending an SMS

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String := "") IS

    URL       : Ada.Strings.Unbounded.Unbounded_String;
    response  : Ada.Strings.Unbounded.Unbounded_String;

  BEGIN
    Self.CheckDestroyed;

    -- Build the SMS relay request URL

    URL := Self.server & "/sendsms?" &
      "username=" & AWS.URL.Encode(To_String(Self.username)) &
      "&password=" & AWS.URL.Encode(To_String(Self.password)) &
      "&from="     & AWS.URL.Encode(sender) &
      "&to="       & AWS.URL.Encode(recipient) &
      "&text="     & (IF subject = "" THEN AWS.URL.Encode(message) ELSE AWS.URL.Encode(subject) & "%0D%0A" & AWS.URL.Encode(message));
Put_Line("DEBUG: URL => " & To_String(URL));

    -- Dispatch the SMS request URL

    response := To_Unbounded_String(AWS.Response.Message_Body(AWS.Client.Get(To_String(URL))));
Put_Line("DEBUG: Response => " & To_String(response));

    -- Check the HTTP response message

    IF Slice(response, 1, 3) = "OK " THEN
      NULL;
    ELSIF response = "ERR -5" THEN
      RAISE Messaging.Text.RelayError WITH "Insufficient credit";
    ELSIF response = "ERR -10" THEN
      RAISE Messaging.Text.RelayError WITH "Invalid username or password";
    ELSIF response = "ERR -15" THEN
      RAISE Messaging.Text.RelayError WITH "Invalid destination";
    ELSIF response = "ERR -20" THEN
      RAISE Messaging.Text.RelayError WITH "System error, please retry";
    ELSIF response = "ERR -25" THEN
      RAISE Messaging.Text.RelayError WITH "Bad request; check parameters";
    ELSIF response = "ERR -30" THEN
      RAISE Messaging.Text.RelayError WITH "Throughput exceeded";
    ELSE
      RAISE Messaging.Text.RelayError WITH To_String(response);
    END IF;
  END Send;

END SMS_Sinch;

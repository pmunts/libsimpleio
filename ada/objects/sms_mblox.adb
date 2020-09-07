-- MBlox SMS messaging service (https://www.mblox.com)

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

WITH Ada.Environment_Variables;
WITH Ada.Strings.Unbounded;

WITH AWS.Client;
WITH AWS.Response;
WITH AWS.URL;

USE ALL TYPE Ada.Strings.Unbounded.Unbounded_String;

PACKAGE BODY SMS_MBlox IS

  -- SMS relay object constructor

  FUNCTION Create
   (server    : String := SMS1SSL;
    username  : String := "";
    password  : String := "") RETURN Messaging.Text.Relay IS

    s : Ada.Strings.Unbounded.Unbounded_String;
    u : Ada.Strings.Unbounded.Unbounded_String;
    p : Ada.Strings.Unbounded.Unbounded_String;

  BEGIN
    s := To_Unbounded_String(server);

    IF username = "" THEN
      u := To_Unbounded_String(Ada.Environment_Variables.Value("MBLOXUSER"));
    ELSE
      u := To_Unbounded_String(username);
    END IF;

    IF password = "" THEN
      p := To_Unbounded_String(Ada.Environment_Variables.Value("MBLOXPASS"));
    ELSE
      p := To_Unbounded_String(password);
    END IF;

    RETURN NEW RelaySubclass'(server => s, username => u, password => p);
  END Create;

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

    -- Build the SMS request URL

    URL := Self.server & "/HTTPSMS?S=H" &
      "&UN=" & AWS.URL.Encode(To_String(Self.username)) &
      "&P="  & AWS.URL.Encode(To_String(Self.password)) &
      "&SA=" & AWS.URL.Encode(sender) &
      "&DA=" & AWS.URL.Encode(recipient) &
      "&M="  & (IF subject = "" THEN AWS.URL.Encode(message) ELSE AWS.URL.Encode(subject) & "%0D%0A" & AWS.URL.Encode(message));

    -- Dispatch the SMS request URL

    response := To_Unbounded_String(AWS.Response.Message_Body(AWS.Client.Get(To_String(URL))));

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

END SMS_MBlox;

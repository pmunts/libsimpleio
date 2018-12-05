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

WITH Messaging.Text;

PRIVATE WITH Ada.Strings.Unbounded;

PACKAGE SMS_MBlox IS

  -- SMS relay object type

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH PRIVATE;

  -- MBlox SMS servers

  SMS1    : CONSTANT String := "http://sms1.mblox.com:9001";
  SMS2    : CONSTANT String := "http://sms2.mblox.com:9001";
  SMS3    : CONSTANT String := "http://sms3.mblox.com:9001";
  SMS5    : CONSTANT String := "http://sms5.mblox.com:9001";
  SMS1SSL : CONSTANT String := "https://sms1.mblox.com:9444";
  SMS2SSL : CONSTANT String := "https://sms2.mblox.com:9444";
  SMS3SSL : CONSTANT String := "https://sms3.mblox.com:9444";
  SMS5SSL : CONSTANT String := "https://sms5.mblox.com:9444";

  -- SMS relay object constructor

  FUNCTION Create
   (server    : String := SMS1SSL;
    username  : String := "";
    password  : String := "") RETURN Messaging.Text.Relay;

  -- Method for sending an SMS

  PROCEDURE Send
   (self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String := "");

PRIVATE

  TYPE RelaySubclass IS NEW Messaging.Text.RelayInterface WITH RECORD
    server    : Ada.Strings.UnBounded.Unbounded_String;
    username  : Ada.Strings.UnBounded.Unbounded_String;
    password  : Ada.Strings.UnBounded.Unbounded_String;
  END RECORD;

END SMS_MBlox;

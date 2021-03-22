-- Ada email test client using https://mailrelay.munts.net

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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Messaging.Text;
WITH Email_HTTP;

PROCEDURE test_email_http IS

  relay : Messaging.Text.Relay;

BEGIN

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 4 THEN
    New_Line;
    Put_Line("Usage: test_email_smtp <sender> <recipient> <subject> <message>");
    New_Line;
    RETURN;
  END IF;

  -- Create a mail relay object

  relay := Email_HTTP.Create;

  -- Send the email message

  relay.Send
   (sender    => Ada.Command_Line.Argument(1),
    recipient => Ada.Command_Line.Argument(2),
    subject   => Ada.Command_Line.Argument(3),
    message   => Ada.Command_Line.Argument(4));
END test_email_http;

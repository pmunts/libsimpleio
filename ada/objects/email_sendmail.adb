-- Send email via /usr/sbin/sendmail

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO;
WITH Ada.Text_IO.C_Streams;
WITH System;

WITH errno;
WITH libLinux;
WITH Messaging.Text;

PACKAGE BODY Email_Sendmail IS

  -- SMTP mail relay object constructor

  FUNCTION Create RETURN Messaging.Text.Relay IS

  BEGIN
    RETURN NEW RelaySubclass'(NULL RECORD);
  END Create;

  -- Method for sending a message via a message relay

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String := "") IS

    stream : System.Address;
    error  : Integer;
    file   : Ada.Text_IO.File_Type;
    relay  : Messaging.Text.Relay;

  BEGIN
    -- Validate parameters

    IF recipient = "" THEN
      RAISE Messaging.Text.RelayError WITH "Recipient cannot be empty string";
    END IF;

    IF message = "" THEN
      RAISE Messaging.Text.RelayError WITH "Message cannot be empty string";
    END IF;

    -- Open pipe to /usr/sbin/sendmail

    IF sender /= "" THEN
      libLinux.POpenWrite("/usr/sbin/sendmail -t -f " & ASCII.QUOTATION &
        sender & ASCII.QUOTATION & ASCII.NUL, stream, error);
    ELSE
      libLinux.POpenWrite("/usr/sbin/sendmail -t" & ASCII.NUL, stream, error);
    END IF;

    IF error /= 0 THEN
      RAISE Messaging.Text.RelayError WITH "libLinux.POpen() failed, " &
        errno.strerror(error);
    END IF;

    BEGIN
      Ada.Text_IO.C_Streams.Open(file, Ada.Text_IO.Out_File, stream);

    -- Send headers

      IF sender /= "" THEN
        Ada.Text_IO.Put_Line(file, "From: " & sender);
      END IF;

      Ada.Text_IO.Put_Line(file, "To: " & recipient);

      IF subject /= "" THEN
        Ada.Text_IO.Put_Line(file, "Subject: " & subject);
      END IF;

      Ada.Text_IO.New_Line(file);

      -- Send payload

      Ada.Text_IO.Put_Line(file, message);

      -- This works even though we are *supposed* to call pclose().

      Ada.Text_IO.Close(file);
    EXCEPTION
      WHEN OTHERS =>
        -- If something failed in Ada.Text_IO, we need to close the pipe...
        libLinux.PClose(stream, error);

        -- ...and then re-raise the exception.
        RAISE;
    END;
  END Send;

END Email_Sendmail;

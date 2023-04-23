-- Send email via /usr/bin/mail

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

WITH Ada.Directories;
WITH Ada.Text_IO;
WITH Ada.Text_IO.C_Streams;
WITH System;

WITH errno;
WITH libLinux;

PACKAGE BODY Email_Mail IS

  MailProg : CONSTANT String := "/usr/bin/mail";

  -- Mail relay object constructor

  FUNCTION Create RETURN Messaging.Text.Relay IS

  BEGIN
    RETURN NEW RelaySubclass'(initialized => True);
  END Create;

  -- Mail relay object initializer

  PROCEDURE Initialize(Self : IN OUT RelaySubclass) IS

  BEGIN
    Self.initialized := True;
  END Initialize;

  -- Mail relay object destroyer

  PROCEDURE Destroy(Self : IN OUT RelaySubclass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- Check whether mail relay object has been destroyed

  PROCEDURE CheckDestroyed(Self : RelaySubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Messaging.Text.RelayError WITH "Mail relay object has been destroyed";
    END IF;
  END CheckDestroyed;

  PROCEDURE Dispatch
   (Self      : RelaySubclass;
    parms     : String;
    message   : String) IS

    stream : System.Address;
    error  : Integer;
    file   : Ada.Text_IO.File_Type;

  BEGIN
    Self.CheckDestroyed;

    libLinux.POpenWrite(MailProg & " " & parms & ASCII.NUL, stream, error);

    IF error /= 0 THEN
      RAISE Messaging.Text.RelayError WITH "libLinux.POpenWrite() failed, " &
        errno.strerror(error);
    END IF;

    BEGIN
      Ada.Text_IO.C_Streams.Open(file, Ada.Text_IO.Out_File, stream);
      Ada.Text_IO.Put_Line(file, message);
      Ada.Text_IO.Close(file); -- This works even though we are *supposed* to call pclose().
    EXCEPTION
      WHEN OTHERS =>
        -- If something failed in Ada.Text_IO, we need to close the pipe...
        libLinux.PClose(stream, error);

        -- ...and then re-raise the exception.
        RAISE;
    END;
  END Dispatch;

  FUNCTION Quote(s : String) RETURN String IS

  BEGIN
    RETURN ASCII.QUOTATION & s & ASCII.QUOTATION;
  END Quote;

  FUNCTION PackSender(s : String) RETURN String IS

  BEGIN
    IF s = "" THEN
      RETURN s;
    ELSE
      RETURN " -r " & Quote(s) & " ";
    END IF;
  END PackSender;

  FUNCTION PackSubject(s : String) RETURN String IS

  BEGIN
    IF s = "" THEN
      RETURN s;
    ELSE
      RETURN " -s " & Quote(s) & " ";
    END IF;
  END PackSubject;

  FUNCTION PackAttachment(a : String) RETURN String IS

  BEGIN
    IF a = "" THEN
      RETURN a;
    ELSE
      IF NOT Ada.Directories.Exists(a) THEN
        RAISE Ada.Directories.Name_Error WITH "Attachment file does not exist";
      END IF;

      RETURN " -A " & Quote(a) & " ";
    END IF;
  END PackAttachment;

  FUNCTION PackRecipient(r : String) RETURN String IS

  BEGIN
    IF r = "" THEN
      RAISE Messaging.Text.RelayError WITH "Recipient cannot be empty string";
    END IF;

    RETURN Quote(r);
  END PackRecipient;

  -- Method for sending a message via a message relay

  PROCEDURE Send
   (Self       : RelaySubclass;
    sender     : String;
    recipient  : String;
    message    : String;
    subject    : String;
    attachment : String) IS

  BEGIN
    Self.CheckDestroyed;

    Self.Dispatch(PackSender(sender) & PackSubject(subject) &
      PackAttachment(attachment) & PackRecipient(recipient), message);
  END Send;

  PROCEDURE Send
   (Self      : RelaySubclass;
    sender    : String;
    recipient : String;
    message   : String;
    subject   : String := "") IS

  BEGIN
    Self.CheckDestroyed;

    Self.Dispatch(PackSender(sender) & PackSubject(subject) &
      PackRecipient(recipient), message);
  END Send;

END Email_Mail;

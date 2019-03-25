-- Fixed length message services implementing using GNAT.Serial_Communications
-- Must be instantiated for each message size.

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH GNAT.Serial_Communications;
WITH libStream;

PACKAGE BODY Messaging.Fixed.GNAT_Serial IS

  TYPE FrameType IS ARRAY (0 .. MessageSize*2 + 8 - 1) OF Byte;

  port : GNAT.Serial_Communications.Serial_Port;

  FUNCTION Create
   (portname  : String;
    timeoutms : Integer := 1000) RETURN Messaging.Fixed.Messenger IS

  BEGIN
    RETURN NEW MessengerSubclass'(NULL RECORD);
  END Create;

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message) IS

    msgsize  : Natural;
    frame    : FrameType;
    framelen : Integer;
    error    : Integer;

  BEGIN
    msgsize := msg'Length;

    -- Optimize bandwidth by not sending trailing zeros.  For short
    -- messages, this will greatly reduce channel bandwidth

    WHILE (msgsize > 0) AND (msg(msgsize - 1) = 0) LOOP
      msgsize := msgsize - 1;
    END LOOP;

    -- Encode the message

    libStream.Encode(msg'Address, msgsize, frame'Address, frame'Length,
      framelen, error);

    -- Send the frame
  END Send;

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message) IS

  BEGIN
    NULL;
  END Receive;

END Messaging.Fixed.GNAT_Serial;

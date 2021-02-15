-- Fixed length message services using the Stream Framing Protocol.
-- Must be instantiated for each message size.

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

WITH Stream_Framing_Protocol;

PACKAGE BODY Messaging.Fixed.Ada_Streams IS

  PACKAGE SFP IS NEW Stream_Framing_Protocol(MessageSize);

  DLE : CONSTANT Messaging.Byte := 16#10#;
  STX : CONSTANT Messaging.Byte := 16#02#;
  ETX : CONSTANT Messaging.Byte := 16#03#;

  -- Constructor

  FUNCTION Create
   (stream    : NOT NULL Ada.Streams.Stream_IO.Stream_Access;
    trimzeros : Boolean := True) RETURN Messenger IS

  BEGIN
    RETURN NEW MessengerSubclass'(stream, trimzeros);
  END Create;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message) IS

    msglen   : Natural;
    frame    : SFP.FrameBuffer;
    framelen : SFP.FrameSize;

  BEGIN
    msglen := msg'Length;

    -- Optimize bandwidth by not sending trailing zeros.  For short
    -- messages, this will greatly reduce channel bandwidth

    IF Self.trim THEN
      WHILE (msglen > 0) AND (msg(msglen - 1) = 0) LOOP
        msglen := msglen - 1;
      END LOOP;
    END IF;

    -- Encode the frame

    SFP.Encode(msg, msglen, frame, framelen);

    -- Send the frame

    Messaging.Buffer'Write(Self.stream, frame(1 .. framelen));
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message) IS

    b          : Messaging.Byte;
    DLE_count  : Natural := 0;
    frame      : SFP.FrameBuffer;
    framelen   : Natural := 0;
    payload    : SFP.PayloadBuffer;
    payloadlen : SFP.PayloadSize;

  BEGIN
    LOOP
      Messaging.Byte'Read(Self.stream, b);

      CASE framelen IS
        WHEN 0 =>
          IF b = DLE THEN
            frame(1)  := DLE;
            framelen  := 1;
            DLE_Count := 1;
          ELSE
            framelen  := 0;
            DLE_Count := 0;
          END IF;

        WHEN 1 =>
          IF b = STX THEN
            frame(2)  := STX;
            framelen  := 2;
          ELSE
            framelen  := 0;
            DLE_Count := 0;
          END IF;

        WHEN OTHERS =>
          IF b = DLE THEN
            DLE_Count := DLE_Count + 1;
          END IF;

          frame(framelen+1) := b;
          framelen := framelen + 1;
      END CASE;

      -- Check for complete frame

      EXIT WHEN framelen >= 6 AND THEN (DLE_count MOD 2 = 0 AND
        frame(1) = DLE AND
        frame(2) = STX AND
        frame(framelen-1) = DLE AND
        frame(framelen) = ETX);

      -- Check for buffer overflow

      IF framelen = SFP.FrameSize'Last THEN
        framelen  := 0;
        DLE_Count := 0;
      END IF;
    END LOOP;

    SFP.Decode(frame, framelen, payload, payloadlen);

    msg := payload;
  END Receive;

END Messaging.Fixed.Ada_Streams;

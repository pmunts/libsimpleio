-- Pure Ada implementation of the Stream Framing Protocol

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

-- See http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf

WITH Messaging;

GENERIC

  MaxPayloadSize : Positive;

PACKAGE Stream_Framing_Protocol IS

  Framing_Error : EXCEPTION RENAMES Messaging.Framing_Error;
  CRC_Error     : EXCEPTION RENAMES Messaging.CRC_Error;

  SUBTYPE PayloadSize   IS Natural  RANGE 0 .. MaxPayloadSize;
  SUBTYPE FrameSize     IS Positive RANGE 1 .. 2*MaxPayloadSize + 8;

  SUBTYPE PayloadBuffer IS Messaging.Buffer(1 .. PayloadSize'Last);
  SUBTYPE FrameBuffer   IS Messaging.Buffer(FrameSize);

  -- Encode a frame. Zero length (indicating an empty frame) is allowed.

  PROCEDURE Encode
   (src    : PayloadBuffer;
    srclen : PayloadSize;
    dst    : OUT FrameBuffer;
    dstlen : OUT FrameSize);

  -- Decode a frame.  May raise Messaging.Framing_Error or Messaging.CRC_Error.

  PROCEDURE Decode
   (src    : FrameBuffer;
    srclen : FrameSize;
    dst    : OUT PayloadBuffer;
    dstlen : OUT PayloadSize);

END Stream_Framing_Protocol;

-- Minimal Ada wrapper for the Linux Stream Framing Protocol services
-- implemented in libso

-- Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

WITH System;

PACKAGE libStream IS
  PRAGMA Link_With("-lsimpleio");

  -- Encode a message to a frame

  PROCEDURE Encode
   (src      : System.Address;
    srclen   : Integer;
    dst      : System.Address;
    dstsize  : Integer;
    dstlen   : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Encode, "STREAM_encode_frame");

  -- Decode a frame to a message

  PROCEDURE Decode
   (src      : System.Address;
    srclen   : Integer;
    dst      : System.Address;
    dstsize  : Integer;
    dstlen   : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Decode, "STREAM_decode_frame");

  -- Send a frame to the Stream Framing Protocol peer

  PROCEDURE Send
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    len      : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Send, "LINUX_write");

  -- Receive a frame from the Stream Framing Protocol peer.
  -- Each call reads one byte from the stream, so Receive()
  -- must be called repeatedly until a complete frame has
  -- been assembled.  len must be set to zero each time a
  -- new frame is to be received.
  -- EAGAIN will be returned in error if the current frame
  -- is incomplete.  Zero will be returned in error if the
  -- frame is complete.  Other errors are possible: EPIPE
  -- or ECONNRESET indicate that the stream has been closed,
  -- and EINVAL indicates that a parameter is invalid.
  -- Invalid frames will be silently ignored with error set
  -- to EAGAIN.  If error is neither zero (frame complete)
  -- nor EAGAIN (frame incomplete), len will be reset to
  -- zero to prepare for the next incoming frame.

  PROCEDURE Receive
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    len      : IN OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Receive, "STREAM_receive_frame");

END libStream;

-- Stream Framing Protocol Encoding Test

-- Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
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
WITH Messaging;
WITH libStream;

PROCEDURE test_stream_framing_libstream IS

  MaxPayloadSize : CONSTANT := 10;

  SUBTYPE Message IS Messaging.Buffer(1 .. MaxPayloadSize);
  SUBTYPE Frame   IS Messaging.Buffer(1 .. 2*MaxPayloadSize + 8);

  msgbuf   : Message;
  framebuf : Frame;
  framelen : Integer;
  error    : Integer;

BEGIN
  New_Line;
  Put_Line("Stream Framing Protocol Encoding Test");
  New_Line;

  framebuf := (OTHERS =>  0);
  libStream.Encode(msgbuf'Address, 0, framebuf'Address, framebuf'Length, framelen, error);

  Messaging.Dump(framebuf, framelen);

  msgbuf(1) := Character'Pos('1');
  msgbuf(2) := Character'Pos('2');
  msgbuf(3) := Character'Pos('3');
  msgbuf(4) := Character'Pos('4');
  msgbuf(5) := Character'Pos('5');
  msgbuf(6) := Character'Pos('6');
  msgbuf(7) := Character'Pos('7');
  msgbuf(8) := Character'Pos('8');
  msgbuf(9) := Character'Pos('9');

  framebuf := (OTHERS =>  0);
  libStream.Encode(msgbuf'Address, 9, framebuf'Address, framebuf'Length, framelen, error);

  Messaging.Dump(framebuf, framelen);
END test_stream_framing_libstream;

-- Stream Framing Protocol Encoding Test

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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Strings.Fixed;
WITH libStream;

PROCEDURE test_stream_framing IS

  TYPE Byte    IS MOD 256;
  Type Message IS ARRAY (Natural RANGE <>) OF Byte;
  Type Frame   IS ARRAY (Natural RANGE <>) OF Byte;

  PACKAGE ByteIO IS NEW Ada.Text_IO.Modular_IO(Byte); USE ByteIO;

  PROCEDURE DumpFrame(frm : Frame; len : Integer) IS

    buf : String(1 .. 6);

  BEGIN
    FOR i IN Natural Range 0 .. len-1 LOOP
      ByteIO.Put(buf, frm(i), 16);

      IF buf(1) = ' ' THEN
        Ada.Strings.Fixed.Insert(buf, 5, "0", Ada.Strings.Left);
      END IF;

      Ada.Strings.Fixed.Replace_Slice(buf, 6, 6, " ");
      Ada.Strings.Fixed.Replace_Slice(buf, 1, 3, " ");

      Put(Ada.Strings.Fixed.Trim(buf, Ada.Strings.Both));
      Put(" ");
    END LOOP;

    New_Line;
  END DumpFrame;

  msgbuf   : Message(0 .. 64);
  framebuf : Frame(0 .. 136);
  framelen : Integer;
  error    : Integer;

BEGIN
  New_Line;
  Put_Line("Stream Framing Protocol Encoding Test");
  New_Line;

  libStream.Encode(msgbuf'Address, 0, framebuf'Address, framebuf'Length, framelen, error);

  DumpFrame(framebuf, framelen);

  msgbuf(0) := Character'Pos('1');
  msgbuf(1) := Character'Pos('2');
  msgbuf(2) := Character'Pos('3');
  msgbuf(3) := Character'Pos('4');
  msgbuf(4) := Character'Pos('5');
  msgbuf(5) := Character'Pos('6');
  msgbuf(6) := Character'Pos('7');
  msgbuf(7) := Character'Pos('8');
  msgbuf(8) := Character'Pos('9');

  libStream.Encode(msgbuf'Address, 9, framebuf'Address, framebuf'Length, framelen, error);

  DumpFrame(framebuf, framelen);
END test_stream_framing;

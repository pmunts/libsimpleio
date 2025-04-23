-- CRC16-CCITT Test

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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
WITH Interfaces;

WITH CRC16_CCITT;

USE TYPE Interfaces.Unsigned_16;

PROCEDURE test_crc16 IS

  SUBTYPE IndexType IS Positive RANGE 1 .. 64;

  TYPE Byte         IS MOD 256;
  TYPE BufferType   IS ARRAY (IndexType) OF Byte;

  FUNCTION CRC16 IS NEW CRC16_CCITT(Byte, IndexType, BufferType);

  FUNCTION ToBuffer(s : String) RETURN BufferType IS

    outbuf : BufferType := (OTHERS => 0);

  BEGIN
    FOR I IN s'Range LOOP
     outbuf(i) := Character'Pos(s(i)); 
    END LOOP;

    RETURN outbuf;
  END;

  FUNCTION ToHex(n : Interfaces.Unsigned_16) RETURN String IS

    hexchars : CONSTANT ARRAY (Interfaces.Unsigned_16 RANGE 0 .. 15) OF Character := "0123456789ABCDEF";

    outbuf : String(1 .. 4);

  BEGIN
    outbuf(1) := hexchars(n / 4096 MOD 16);
    outbuf(2) := hexchars(n / 256  MOD 16);
    outbuf(3) := hexchars(n / 16   MOD 16);
    outbuf(4) := hexchars(n        MOD 16);
    RETURN outbuf;
  END ToHex;

BEGIN
  New_Line;
  Put_Line("CRC16-CCITT Test");
  New_Line;

  Put_Line(ToHex(CRC16(ToBuffer(""), 0)));
  Put_Line(ToHex(CRC16(ToBuffer("123456789"), 9)));
  Put_Line(ToHex(CRC16(ToBuffer("This is a test."), 15)));
  Put_Line(ToHex(CRC16(ToBuffer("This is ONLY a test."), 20)));
  Put_Line(ToHex(CRC16(ToBuffer("The quick brown fox jumps over the lazy dog."), 44)));
END test_crc16;

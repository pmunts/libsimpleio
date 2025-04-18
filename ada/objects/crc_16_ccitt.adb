-- Calculate the CRC-16-CCITT checksum for an array of bytes

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

WITH Interfaces; USE Interfaces;

PACKAGE BODY CRC_16_CCITT IS

  -- The following CRC16-CCITT subroutine came from:
  -- http://stackoverflow.com/questions/10564491/function-to-calculate-a-crc16-checksum

  FUNCTION Calc(buf : BufferType; len : Positive) RETURN Unsigned_16 IS

    crc : Unsigned_16 := Seed;
    x   : Unsigned_8;

  BEGIN
    FOR i IN BufferRange'First .. BufferRange'First + BufferRange(len-1) LOOP
      x   := Unsigned_8(Shift_Right(crc, 8)) XOR Unsigned_8(buf(i));
      x   := x XOR Shift_Right(x, 4);
      crc := Shift_Left(crc, 8) XOR Shift_Left(Unsigned_16(x), 12) XOR
        Shift_Left(Unsigned_16(x), 5) XOR Unsigned_16(x);
    END LOOP;

    RETURN crc;
  END Calc;

END CRC_16_CCITT;

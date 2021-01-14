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

WITH Ada.Strings.Fixed;
WITH Ada.Text_IO;
WITH Interfaces; USE Interfaces;

PACKAGE BODY Stream_Framing_Protocol IS

  DLE : CONSTANT Byte := 16#10#;
  STX : CONSTANT Byte := 16#02#;
  ETX : CONSTANT Byte := 16#03#;

  -- The following CRC16-CCITT subroutine came from:
  -- http://stackoverflow.com/questions/10564491/function-to-calculate-a-crc16-checksum

  FUNCTION CRC16(buf : PayloadBuffer; length : Natural) RETURN Unsigned_16 IS

    crc : Unsigned_16 := 16#1D0F#;
    x   : Unsigned_8;

  BEGIN
    FOR i IN 1 .. length LOOP
      x   := Unsigned_8(Shift_Right(crc, 8)) XOR Unsigned_8(buf(i));
      x   := x XOR Shift_Right(x, 4);
      crc := Shift_Left(crc, 8) XOR Shift_Left(Unsigned_16(x), 12) XOR
        Shift_Left(Unsigned_16(x), 5) XOR Unsigned_16(x);
    END LOOP;

    RETURN crc;
  END CRC16;

  -- Encode a frame. Zero length (indicating an empty frame) is allowed.

  PROCEDURE Encode
   (src    : PayloadBuffer;
    srclen : PayloadSize;
    dst    : OUT FrameBuffer;
    dstlen : OUT FrameSize) IS

    crc  : Unsigned_16 := CRC16(src, srclen);
    didx : Positive := 1;

  BEGIN
    dst := (OTHERS => 0);

    -- Prefix start of frame delimiter

    dst(didx) := DLE;
    didx := didx + 1;
    dst(didx) := STX;
    didx := didx + 1;

    -- Copy data bytes, with DLE byte stuffing

    FOR sidx IN 1 .. srclen LOOP
      IF src(sidx) = DLE THEN
        dst(didx) := DLE;
        didx := didx + 1;
      END IF;

      dst(didx) := src(sidx);
      didx := didx + 1;
    END LOOP;

    -- Append frame check sequence high byte

    dst(didx) := Byte(crc / 256);
    didx := didx + 1;

    IF dst(didx - 1) = DLE THEN
      dst(didx) := DLE;
      didx := didx + 1;
    END IF;

    -- Append frame check sequence low byte

    dst(didx) := Byte(crc MOD 256);
    didx := didx + 1;

    IF dst(didx - 1) = DLE THEN
      dst(didx) := DLE;
      didx := didx + 1;
    END IF;

    -- Append end of frame delimiter

    dst(didx) := DLE;
    didx := didx + 1;
    dst(didx) := ETX;
    didx := didx + 1;

    -- Return encoded frame length

    dstlen := didx - 1;
  END Encode;

  -- Decode a frame.

  PROCEDURE Decode
   (src    : FrameBuffer;
    srclen : FrameSize;
    dst    : OUT PayloadBuffer;
    dstlen : OUT PayloadSize) IS

    sidx : Positive := 1;
    slen : Integer;
    didx : Positive := 1;

    crcsent : Unsigned_16;
    crccalc : Unsigned_16;

  BEGIN
    dst := (OTHERS => 0);

    -- Verify minimum frame length

    IF srclen < 6 THEN
      RAISE Framing_Error WITH "Frame is too short at line 140";
    END IF;

    -- Verify frame delimiters

    IF src(1)        /= DLE OR
       src(2)        /= STX OR
       src(srclen-1) /= DLE OR
       src(srclen)   /= ETX THEN
      RAISE Framing_Error WITH "Invalid delimiters at line 149";
    END IF;

    -- Skip delimiter bytes at both ends

    sidx := 3;
    slen := srclen - 4;

    -- Extract frame check sequence low byte

    IF src(sidx + slen - 1) /= DLE THEN
      crcsent := Unsigned_16(src(sidx + slen - 1));
      slen    := slen - 1;

      IF slen < 0 THEN
        RAISE Framing_Error WITH "Source length underflow at line 164";
      END IF;
    ELSIF src(sidx + slen - 2) = DLE THEN
      crcsent := Unsigned_16(DLE);
      slen    := slen - 2;

      IF slen < 0 THEN
        RAISE Framing_Error WITH "Source length underflow at line 171";
      END IF;
    ELSE
      RAISE Framing_Error WITH "Invalid byte stuffing at line 174";
    END IF;

    -- Extract frame check sequence high byte

    IF src(sidx + slen - 1) /= DLE THEN
      crcsent := crcsent + Shift_Left(Unsigned_16(src(sidx + slen - 1)), 8);
      slen    := slen - 1;

      IF slen < 0 THEN
        RAISE Framing_Error WITH "Source length underflow at line 184";
      END IF;
    ELSIF src(sidx + slen - 2) = DLE THEN
      crcsent := crcsent + Shift_Left(Unsigned_16(DLE), 8);
      slen    := slen - 2;

      IF slen < 0 THEN
        RAISE Framing_Error WITH "Source length underflow at line 191";
      END IF;
    ELSE
      RAISE Framing_Error WITH "Invalid byte stuffing at line 194";
    END IF;

    -- Copy payload bytes, removing any stuffed DLE's

    WHILE slen > 0 LOOP
      IF didx > MaxPayloadSize THEN
        RAISE Framing_Error WITH "Destination index overflow at line 201";
      END IF;

      IF src(sidx) /= DLE THEN
        dst(didx) := src(sidx);
        didx := didx + 1;
        sidx := sidx + 1;
        slen := slen - 1;

        IF slen < 0 THEN
          RAISE Framing_Error WITH "Source length underflow at line 211";
        END IF;
      ELSIF src(sidx + 1) = DLE THEN
        dst(didx) := DLE;
        didx := didx + 1;
        sidx := sidx + 2;
        slen := slen - 2;

        IF slen < 0 THEN
          RAISE Framing_Error WITH "Source length underflow at line 220";
        END IF;
      ELSE
        RAISE Framing_Error WITH "Invalid byte stuffing at line 223";
      END IF;
    END LOOP;

    -- Calculate frame check sequence

    crccalc := CRC16(dst, didx - 1);

    -- Compare send and calculated frame check sequences

    IF crcsent /= crccalc THEN
      RAISE CRC_Error WITH "CRC mismatch at line 234";
    END IF;

    dstlen := didx - 1;
  END Decode;

  -- Display buffer contents in hexadecimal

  PROCEDURE Dump
   (src  : Buffer;
    trim : Boolean := True) IS

    len : Positive;
    buf : String(1 .. 6);

    PACKAGE ByteIO IS NEW Ada.Text_IO.Modular_IO(Byte);

  BEGIN
    len := src'Last;

    WHILE trim AND (len > 1) AND (src(len) = 0) LOOP
      len := len - 1;
    END LOOP;

    FOR b OF src(1 .. len) LOOP
      ByteIO.Put(buf, b, 16);

      IF buf(1) = ' ' THEN
        Ada.Strings.Fixed.Insert(buf, 5, "0", Ada.Strings.Left);
      END IF;

      Ada.Strings.Fixed.Replace_Slice(buf, 6, 6, " ");
      Ada.Strings.Fixed.Replace_Slice(buf, 1, 3, " ");

      Ada.Text_IO.Put(Ada.Strings.Fixed.Trim(buf, Ada.Strings.Both));
      Ada.Text_IO.Put(" ");
    END LOOP;

    Ada.Text_IO.New_Line;
  END Dump;

END Stream_Framing_Protocol;

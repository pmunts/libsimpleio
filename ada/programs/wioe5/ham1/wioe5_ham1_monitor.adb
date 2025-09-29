-- Wio-E5 LoRa Amateur Radio Flavor #1 Passive Monitor

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
WITH Ada.Strings.Fixed;

WITH Wio_E5.P2P;

PROCEDURE wioe5_ham1_monitor IS

  HeaderBytes : CONSTANT Positive := 12;

  FUNCTION Trim
   (Source : String;
    Side   : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  PACKAGE LoRa IS NEW Wio_E5.P2P;

  FUNCTION Dump(msg : LoRa.Payload; nbytes : Positive) RETURN String IS

    hexchars   : CONSTANT ARRAY (0 .. 15) OF Character := "0123456789ABCDEF";

    b     : Natural;
    chars : String(1 .. nbytes);
    bytes : String(1 .. nbytes*3) := (OTHERS => ' ');

  BEGIN
    FOR i IN Positive RANGE 1 .. nbytes LOOP
      b := Natural(msg(i + HeaderBytes));

      IF b > 31 AND b < 127 THEN
        chars(i)         := Character'Val(b);
      ELSE
        chars(i) := '.';
      END IF;

      bytes(i*3-1) := hexchars(b / 16);
      bytes(i*3)   := hexchars(b MOD 16);
    END LOOP;

    RETURN """" & chars & """" & bytes;
  END Dump;

  dev : LoRa.Device;
  msg : LoRa.Payload;
  len : Natural;
  RSS : Integer;
  SNR : Integer;

BEGIN
  New_Line;
  Put_Line("Wio-E5 LoRa Amateur Radio Flavor #1 Passive Monitor");
  New_Line;

  dev := LoRa.Create;

  LOOP
    dev.Receive(msg, len, RSS, SNR);

    IF len > HeaderBytes THEN
      DECLARE
        nbytes   : Positive     := len - HeaderBytes;
        net      : String       := LoRa.ToString(msg, len)(1 .. HeaderBytes - 2);
        dstnode  : Wio_E5.Byte  := msg(HeaderBytes - 1);
        srcnode  : Wio_E5.Byte  := msg(HeaderBytes);
        sender   : String       := Trim(net) & "-" & Trim(srcnode'Image);
        receiver : String       := Trim(net) & "-" & Trim(dstnode'Image);
        pay      : String       := Dump(msg, nbytes);

      BEGIN
        Put_Line(sender & " => " & Receiver & "  RSS:" & RSS'Image & " dbM  SNR:" & SNR'Image & " dB " & nbytes'Image & " Bytes  " & pay);
      END;
    END IF;
  END LOOP;
END wioe5_ham1_monitor;

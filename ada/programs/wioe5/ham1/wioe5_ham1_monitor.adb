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

  FUNCTION Delete
   (Source  : IN String;
    From    : IN Positive;
    Through : IN Natural) RETURN String RENAMES Ada.Strings.Fixed.Delete;

  FUNCTION Trim
   (Source : String;
    Side   : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  PACKAGE LoRa IS NEW Wio_E5.P2P;

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

    IF len > 12 THEN
      DECLARE
        s        : String      := LoRa.ToString(msg, len);
        net      : String      := s(1 .. 10);
        dstnode  : Wio_E5.Byte := msg(11);
        srcnode  : Wio_E5.Byte := msg(12);
        pay      : String      := Delete(s, 1, 12);
        sender   : String      := Trim(net) & "-" & Trim(srcnode'Image);
        receiver : String      := Trim(net) & "-" & Trim(dstnode'Image);
        nbytes   : Positive    := len - 22;
      BEGIN
        Put_Line(sender & " => " & Receiver & " " & nbytes'Image &
          " Bytes => """ & pay & """" & "  RSS:" & RSS'Image & " dbM  SNR:" &
          SNR'Image & " dB");
      END;
    END IF;
  END LOOP;
END wioe5_ham1_monitor;

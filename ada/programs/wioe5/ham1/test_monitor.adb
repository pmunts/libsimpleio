-- Wio-E5 LoRa Amateur Radio Flavor #1 Passive Monitor Test

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

PROCEDURE test_monitor IS

  PACKAGE LoRa IS NEW Wio_E5.P2P;

  dev : LoRa.Device;
  msg : LoRa.Payload;
  len : Natural;
  RSS : Integer;
  SNR : Integer;

BEGIN
  New_Line;
  Put_Line("Wio-E5 LoRa Amateur Radio Flavor #1 Passive Monitor Test");
  New_Line;

  dev := LoRa.Create;

  LOOP
    dev.Receive(msg, len, RSS, SNR);

    IF len > 0 THEN
      DECLARE
        s   : String      := LoRa.ToString(msg, len);
        net : String      := s(1 .. 10);
        src : Wio_E5.Byte := msg(12);
        dst : Wio_E5.Byte := msg(11);
        pay : String      := Ada.Strings.Fixed.Delete(s, 1, 12);
      BEGIN
        Put_Line("net: """ & net & """ src:" & src'Image & " dst:" &
          dst'Image & " payload: """ & pay & """");
      END;
    END IF;
  END LOOP;
END test_monitor;

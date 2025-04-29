-- Wio-E5 LoRa Transceiver Receive Test

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

WITH Wio_E5.Ham1;

PROCEDURE test_spew_rx IS

  PACKAGE LoRa IS NEW Wio_E5.Ham1; USE LoRa;

  dev : Device := Create("/dev/ttyAMA0", 115200, "XXXXXXXX", 2, 915.0);
  msg : Frame;
  len : Natural;
  src : Wio_E5.Byte;
  dst : Wio_E5.Byte;
  RSS : Integer;
  SNR : Integer;

BEGIN
  New_Line;
  Put_Line("Wio-E5 LoRa Transceiver Receive Test");
  New_Line;

  LOOP
    dev.Receive(msg, len, src, dst, RSS, SNR);

    IF len > 0 THEN
      Put_Line("Received => """ & ToString(msg, len) & """ from node" &
        src'Image & " to node" & dst'Image & " RSS:" & RSS'Image &
        " dBm SNR:" & SNR'Image & " dB");
    END IF;
  END LOOP;
END test_spew_rx;

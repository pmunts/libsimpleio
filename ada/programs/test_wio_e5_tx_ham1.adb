-- WIO-E5 LoRa Transceiver Transmit Test

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

WITH WIO_E5.Ham1;

PROCEDURE test_wio_e5_tx_ham1 IS

  PACKAGE LoRaHam IS NEW WIO_E5.Ham1(64); USE LoRaHam;

  dev : Device := Create("/dev/ttyAMA0", 115200, 915.0, "N7AHL   ", 65);
  msg : Packet;
  len : Natural := 0;
  src : WIO_E5.Byte;
  dst : WIO_E5.Byte;

BEGIN
  New_Line;
  Put_Line("WIO-E5 LoRa Transceiver Transmit Test");
  New_Line;

  FOR i IN 1 .. 10 LOOP
    dev.Send("This is test" & i'Image, 66);

    DELAY 0.3;

    dev.Receive(msg, len, src, dst);

    IF len > 0 THEN
      Put_Line("Received => """ & ToString(msg, len) & """ from node" & src'Image &
        " to node" & dst'Image);
    END IF;

    DELAY 0.3;
  END LOOP;

  dev.Shutdown;
END test_wio_e5_tx_ham1;

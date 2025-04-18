-- WIO-E5 LoRa Transceiver Receive Test

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

WITH WIO_E5.P2P;

PROCEDURE test_wio_e5_rx_p2p IS

  PACKAGE LoRaP2P IS NEW WIO_E5.P2P(64); USE LoRaP2P;

  dev : Device := Create("/dev/ttyAMA0");
  msg : Packet;
  len : Natural;

BEGIN
  New_Line;
  Put_Line("WIO-E5 LoRa Transceiver Receive Test");
  New_Line;

  dev.Start(915);

  LOOP
    dev.Receive(msg, len);

    IF len > 0 THEN
      Put_Line("Received => " & ToString(msg, len));
      dev.Send("ACK");
    END IF;
  END LOOP;
END test_wio_e5_rx_p2p;

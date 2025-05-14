-- Wio-E5 LoRa Transceiver Transmit Test

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

WITH Ada.Command_Line;
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Wio_E5.Ham2;

PROCEDURE test_wioe5_tx_ham2 IS

  PACKAGE LoRa IS NEW Wio_E5.Ham2;

  dev               : LoRa.Device;
  responder_network : LoRa.NetworkID;
  responder_node    : LoRa.NodeID;
  iterations        : Positive;
  msg               : LoRa.Payload;
  len               : Natural := 0;
  srcnet            : LoRa.NetworkID;
  srcnode           : LoRa.NodeID;
  dstnet            : LoRa.NetworkID;
  dstnode           : LoRa.NodeID;
  RSS               : Integer;
  SNR               : Integer;

BEGIN
  New_Line;
  Put_Line("Wio-E5 LoRa Transceiver Transmit Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 3 THEN
    Put_Line("Usage: test_wioe5_tx_ham2 <network id> <node id> <iterations>");
    New_Line;
    Ada.Command_Line.Set_Exit_Status(1);
    RETURN;
  END IF;

  dev               := LoRa.Create;
  responder_network := Ada.Strings.Fixed.Head(Ada.Command_Line.Argument(1), LoRa.NetworkID'Length);
  responder_node    := LoRa.NodeID'Value(Ada.Command_Line.Argument(2));
  iterations        := Positive'Value(Ada.Command_Line.Argument(3));

  FOR i IN 1 .. iterations LOOP
    dev.Send("This is test" & i'Image, responder_network, responder_node);

    DELAY 0.4;

    dev.Receive(msg, len, srcnet, srcnode, dstnet, dstnode, RSS, SNR);

    IF len > 0 THEN
      Put_Line("Received => """ & LoRA.ToString(msg, len) & """ from node"
        & srcnode'Image & " to node" & dstnode'Image & " RSS:" & RSS'Image &
        " dBm SNR:" & SNR'Image & " dB");
    END IF;
  END LOOP;

  dev.Shutdown;
END test_wioe5_tx_ham2;

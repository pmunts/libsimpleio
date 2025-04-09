-- Seeed Studio WIO-E5 LoRa Transceiver Device Driver

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

WITH GNAT.Regpat;

PACKAGE WIO_E5 IS

  Error : EXCEPTION;

  -- Type definitions

  TYPE DeviceClass IS TAGGED PRIVATE;
  TYPE Device      IS ACCESS ALL DeviceClass'Class;

  DefaultTimeout : CONSTANT Duration := 0.02;

-------------------------
-- Device Driver Services
-------------------------

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive := 115200) RETURN Device;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceClass;
    portname : String;
    baudrate : Positive := 115200);

  -- Send AT command string to WIO-E5

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String);

  -- Get response string from WIO-E5

  FUNCTION GetResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout);

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout);

--------------------------------------
-- Peer to Peer Communication Services
--------------------------------------

  TYPE SpreadingFactors IS (SF7, SF8, SF9, SF10, SF11, SF12);
  TYPE Bandwidths       IS (BW125K, BW250K, BW500K);
  TYPE Byte             IS MOD 256;
  TYPE Packet           IS ARRAY (Natural RANGE <>) OF Byte;

  -- Enable Peer to Peer mode

  PROCEDURE P2P_Enable
   (Self       : DeviceClass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14);

  -- Send a text message

  PROCEDURE P2P_Send(Self : DeviceClass; msg : String);

  -- Send a binary message

  PROCEDURE P2P_Send(Self : DeviceClass; msg : Packet);

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    fd : Integer := -1;
  END RECORD;

END WIO_E5;

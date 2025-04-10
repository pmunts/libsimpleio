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

PRIVATE WITH Ada.Containers.Synchronized_Queue_Interfaces;
PRIVATE WITH Ada.Containers.Bounded_Synchronized_Queues;
PRIVATE WITH GNAT.Regpat;

PACKAGE WIO_E5 IS

  Error : EXCEPTION;

  -- Type definitions

  TYPE DeviceClass      IS TAGGED PRIVATE;
  TYPE Device           IS ACCESS ALL DeviceClass'Class;
  TYPE SpreadingFactors IS (SF7, SF8, SF9, SF10, SF11, SF12);
  TYPE Bandwidths       IS (BW125K, BW250K, BW500K);
  TYPE Byte             IS MOD 256;
  TYPE Packet           IS ARRAY (1 .. 256) OF Byte;

  Uninitialized  : CONSTANT DeviceClass;

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive := 115200) RETURN Device

    WITH Pre => portname'Length > 0;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceClass;
    portname : String;
    baudrate : Positive := 115200)

    WITH Pre => portname'Length > 0;

  -- Begin Peer to Peer mode.

  PROCEDURE P2P_Begin
   (Self       : IN OUT DeviceClass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14)

    WITH Pre => Self /= Uninitialized;

  -- End Peer to Peer mode.

  PROCEDURE P2P_End(Self : DeviceClass)

    WITH Pre => Self /= Uninitialized;

  -- Send a text message, which cannot be empty.

  PROCEDURE P2P_Send(Self : DeviceClass; s : String)

    WITH Pre => Self /= Uninitialized AND s'Length > 0;

  -- Send a binary message, which cannot be empty.

  PROCEDURE P2P_Send(Self : DeviceClass; msg : Packet; len : Positive)

    WITH Pre => Self /= Uninitialized;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE P2P_Receive(Self : DeviceClass; msg : OUT Packet; len : OUT Natural)

    WITH Pre => Self /= Uninitialized;

  -- Dump contents of a packet in hexadecimal form.

  PROCEDURE Dump(msg : Packet; len : Positive)

    WITH Pre => len <= Packet'Length;

  -- Convert a message from binary to string.

  FUNCTION ToString(p : Packet; len : Positive) RETURN String

    WITH Pre => len <= Packet'Length;

  -- Convert a message from string to binary.

  FUNCTION ToPacket(s : String) RETURN Packet

    WITH Pre => s'Length > 0 AND s'Length <= Packet'Length;

PRIVATE

  DefaultTimeout : CONSTANT Duration := 0.02;
  hexchars       : CONSTANT ARRAY (0 .. 15) OF Character := "0123456789ABCDEF";

  -- Send AT command string to WIO-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String)

    WITH Pre => Self /= Uninitialized AND cmd'Length > 0;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout)

    WITH Pre => Self /= Uninitialized AND cmd'Length > 0 AND resp'Length > 0;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout)

    WITH Pre => Self /= Uninitialized AND cmd'Length > 0;

  -- Get response string from WIO-E5

  FUNCTION GetATResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String

   WITH Pre => Self /= Uninitialized;

  -- Define a background task for handling Peer to Peer communication events

  TASK TYPE P2P_Task IS
    ENTRY Initialize(dev : DeviceClass);
    ENTRY Finalize;
  END P2P_Task;

  TYPE P2P_TaskAccess IS ACCESS P2P_Task;

  -- Event queue definitions

  TYPE P2P_Queue_Item IS RECORD
    msg : Packet;
    len : Natural;
  END RECORD;

  PACKAGE P2P_Queue_Interface IS NEW Ada.Containers.Synchronized_Queue_Interfaces(P2P_Queue_Item);
  PACKAGE P2P_Queue_Package   IS NEW Ada.Containers.Bounded_Synchronized_Queues(P2P_Queue_Interface, 100);

  TYPE P2P_Queue_Access IS ACCESS P2P_Queue_Package.Queue;

  -- WIO-E5 device class

  TYPE DeviceClass IS TAGGED RECORD
    fd       : Integer            := -1;
    rxqueue  : P2P_Queue_Access   := NULL;
    txqueue  : P2P_Queue_Access   := NULL;
    response : P2P_TaskAccess     := NULL;
  END RECORD;

  Uninitialized : CONSTANT DeviceClass := DeviceClass'(-1, NULL, NULL, NULL);

END WIO_E5;

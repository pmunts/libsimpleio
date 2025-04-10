-- Seeed Studio WIO-E5 LoRa Transceiver Peer to Peer Support

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

GENERIC

  -- The maximum payload size is constrained first by the RF subsystem of the
  -- STM32WLE5JC microcontroller within the WIO-E5 module (maximum RF frame
  -- size of 255 bytes) and constrained further by the RF spreading and
  -- bandwidth settings.  Values of 59, 123, and 230 bytes seem to supported
  -- by the LoRa PHY and MAC specifications.
  --
  -- I have determined empirically that the maximum usable payload using the
  -- Send and Receive services below at US915 Data Rate Scheme #13 (spreading
  -- factor 7 and 500 kHz bandwidth) is 253 bytes.  This is larger than what
  -- is defined in any LoRa specification I have read and may not interoperate
  -- with any other RF chipset.  YMMV.

  MaxPayloadSize : Positive; -- bytes

  MaxQueueSize   : Positive := 10; -- elements

PACKAGE WIO_E5.P2P IS

  Error : EXCEPTION;

  -- Type definitions

  TYPE DeviceSubclass   IS NEW DeviceClass WITH PRIVATE;
  TYPE Device           IS ACCESS ALL DeviceSubclass'Class;
  TYPE SpreadingFactors IS (SF7, SF8, SF9, SF10, SF11, SF12);
  TYPE Bandwidths       IS (BW125K, BW250K, BW500K);
  TYPE Byte             IS MOD 256;
  TYPE Packet           IS ARRAY (1 .. MaxPayloadSize) OF Byte;

  Uninitialized  : CONSTANT DeviceSubclass;

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive := 115200) RETURN Device

    WITH Pre => portname'Length > 0;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceSubclass;
    portname : String;
    baudrate : Positive := 115200)

    WITH Pre => portname'Length > 0;

  -- Begin Peer to Peer mode.

  PROCEDURE Start
   (Self       : IN OUT DeviceSubclass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14)

    WITH Pre => Self /= Uninitialized;

  -- End Peer to Peer mode.

  PROCEDURE Finish(Self : DeviceSubclass)

    WITH Pre => Self /= Uninitialized;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; s : String)

    WITH Pre => Self /= Uninitialized AND s'Length > 0;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; msg : Packet; len : Positive)

    WITH Pre => Self /= Uninitialized;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive(Self : DeviceSubclass; msg : OUT Packet; len : OUT Natural)

    WITH Pre => Self /= Uninitialized;

  -- Dump contents of a packet in hexadecimal form.

  PROCEDURE Dump(msg : Packet; len : Positive)

    WITH Pre => len <= MaxPayloadSize;

  -- Convert a message from binary to string.

  FUNCTION ToString(p : Packet; len : Positive) RETURN String

    WITH Pre => len <= MaxPayloadSize;

  -- Convert a message from string to binary.

  FUNCTION ToPacket(s : String) RETURN Packet

    WITH Pre => s'Length > 0 AND s'Length <= MaxPayloadSize;

PRIVATE

  USE Ada.Containers;

  -- Define a background task for handling Peer to Peer communication events

  TASK TYPE BackgroundTask IS
    ENTRY Initialize(dev : DeviceSubclass);
    ENTRY Finalize;
  END BackgroundTask;

  TYPE TaskAccess IS ACCESS BackgroundTask;

  -- Event queue definitions

  TYPE Queue_Item IS RECORD
    msg : Packet;
    len : Natural;
  END RECORD;

  PACKAGE Queue_Interface IS NEW Synchronized_Queue_Interfaces(Queue_Item);
  PACKAGE Queue_Package   IS NEW Bounded_Synchronized_Queues(Queue_Interface, Count_Type(MaxQueueSize));

  TYPE Queue_Access IS ACCESS Queue_Package.Queue;

  -- WIO-E5 device class

  TYPE DeviceSubclass IS NEW DeviceClass WITH RECORD
    rxqueue  : Queue_Access   := NULL;
    txqueue  : Queue_Access   := NULL;
    response : TaskAccess     := NULL;
  END RECORD;

  Uninitialized : CONSTANT DeviceSubclass := DeviceSubclass'(-1, NULL, NULL, NULL);

END WIO_E5.P2P;

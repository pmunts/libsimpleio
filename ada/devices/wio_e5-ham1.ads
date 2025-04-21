-- Seeed Studio Wio-E5 LoRa Transceiver Support for Amateur Radio, using
-- Test aka P2P mode.
--
-- Flavor #1: All stations are administered by the same ham radio operator.
--
-- The first 10 bytes of the payload are dedicated to address information:
--
-- * 8 ASCII bytes for the network ID aka call sign, left justified and space
--   padded.  Unlike AX.25, the ASCII bytes are *not* left shifted one bit.
--
-- * 1 byte for the destination node ID (ARCNET style: broadcast=0,
--   unicast=1 to 255).
--
-- * 1 byte for the source node ID (ARCNET style: 1 to 255).
--
-- In test aka P2P mode, the Wio-E5 transmits unencrypted "implicit header"
-- frames consisting of a configurable number of preamble bits, 1 to 253
-- payload bytes, and two CRC bytes.  After the RF frame has been serialized,
-- the Wio-E5 applies sprectrum whitening and adds forward error correction
-- bits to the outgoing bit stream.
--
-- Upon reception the Wio-E5 performs error correction using the added FEC
-- bits and then transparently strips them and reverses spectrum whitening.
-- After reconstituting the original RF frame, the Wio-E5 verifies the CRC,
-- discarding erroneous frames and passing valid ones to the device driver.
--
-- Unlike LoRaWan mode, frames with up to 253 payload bytes can be sent and
-- received using *any* data rate scheme (the combination of spreading
-- factor, modulation bandwidth, and the derived RF symbol rate).
--
-- In the context of this package, the terms "preamble" and "syncword" are
-- synonymous as are "frame" and "packet".
--
-- This package will drop any received frame that does not contain matching
-- network aka callsign and node ID's, imposing a unicast scheme onto the
-- inherently broadcast P2P mode.  In accordance with the digital data
-- transparency required by U.S. Amateur Radio Service regulations, any
-- Wio-E5 using the same RF settings (possibly using the related Ada package
-- Wio_E5.P2P) can monitor communications among a group of ham radio stations
-- using this package.

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

  MaxPayloadSize  : Positive;        -- bytes, NOT including address header
  QueueSize       : Positive := 10;  -- elements
  SpreadingFactor : Positive := 7;   -- (7 to 12)
  Bandwidth       : Positive := 500; -- kHz (125, 250, or 500)
  TxPreamble      : Positive := 12;  -- bits;
  RxPreamble      : Positive := 15;  -- bits;
  TxPower         : Positive := 20;  -- dBm;

PACKAGE Wio_E5.Ham1 IS

  -- Type definitions

  TYPE DeviceSubclass IS NEW DeviceClass WITH PRIVATE;
  TYPE Device         IS ACCESS ALL DeviceSubclass'Class;
  TYPE Packet         IS ARRAY (1 .. MaxPayloadSize + 10) OF Byte;

  SUBTYPE NetworkID IS String(1 .. 8); -- e.g. callsign

  Uninitialized  : CONSTANT DeviceSubclass;

  Broadcast : CONSTANT Byte := 0; -- ARCNET style broadcast address

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive;  -- bits per second
    freqmhz  : Frequency; -- MHz e.g. 915.000
    network  : NetworkID; -- aka callsign
    node     : Byte) RETURN Device

    WITH Pre => portname'Length > 0 AND network'Length > 0 AND node > Broadcast;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceSubclass;
    portname : String;
    baudrate : Positive;  -- bits per second;
    freqmhz  : Frequency; -- MHz e.g. 915.000
    network  : NetworkID; -- aka callsign
    node     : Byte)

    WITH Pre => portname'Length > 0 AND network'Length > 0 AND node > Broadcast;

  -- Terminate background task

  PROCEDURE Shutdown(Self : DeviceSubclass)

    WITH Pre => Self /= Uninitialized;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send
   (Self : DeviceSubclass;
    s    : String;
    dst  : Byte)

    WITH Pre => Self /= Uninitialized AND s'Length > 0 AND s'Length <= MaxPayloadSize;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send
   (Self : DeviceSubclass;
    msg  : Packet;
    len  : Positive;
    dst  : Byte)

    WITH Pre => Self /= Uninitialized AND len <= MaxPayloadSize;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive
   (Self : DeviceSubclass;
    msg  : OUT Packet;
    len  : OUT Natural;
    src  : OUT Byte;
    dst  : OUT Byte)

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

  USE Ada.Containers;

  -- Define a background task for handling Peer to Peer communication events

  TASK TYPE BackgroundTask IS
    ENTRY Initialize(dev : DeviceSubclass);
    ENTRY Shutdown;
  END BackgroundTask;

  TYPE TaskAccess IS ACCESS BackgroundTask;

  -- Event queue definitions

  TYPE Queue_Item IS RECORD
    msg : Packet;
    len : Natural;
    src : Byte;
    dst : Byte;
  END RECORD;

  PACKAGE Queue_Interface IS NEW Synchronized_Queue_Interfaces(Queue_Item);
  PACKAGE Queue_Package   IS NEW Bounded_Synchronized_Queues(Queue_Interface, Count_Type(QueueSize));

  TYPE Queue_Access IS ACCESS Queue_Package.Queue;

  -- Wio-E5 device class

  TYPE DeviceSubclass IS NEW DeviceClass WITH RECORD
    network  : NetworkID;
    node     : Byte;
    rxqueue  : Queue_Access;
    txqueue  : Queue_Access;
    response : TaskAccess;
  END RECORD;

  Uninitialized : CONSTANT DeviceSubclass :=
    DeviceSubclass'(-1, (OTHERS => ASCII.NUL), 0, NULL, NULL, NULL);

END Wio_E5.Ham1;

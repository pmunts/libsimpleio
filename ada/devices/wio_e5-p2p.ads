-- Seeed Studio WIO-E5 LoRa Transceiver Test Mode aka P2P (Peer to Peer or
-- Point to Point) Support.  P2P is misleading because there is no station
-- addressing and all transmissions are broadcasts.  Any station with the
-- same RF settings (frequency, spreading factor, and bandwidth) will be able
-- to receive what you transmit with this package.
--
-- In test aka P2P mode, the WIO-E5 transmits unencrypted "implicit header"
-- frames consisting of a configurable number of preamble bits, 1 to 253
-- payload bytes, and two CRC bytes.  After the RF frame has been serialized,
-- the WIO-E5 applies sprectrum whitening and adds forward error correction
-- bits to the outgoing bit stream.
--
-- Upon reception the WIO-E5 performs error correction using the added FEC
-- bits and then transparently strips them and reverses spectrum whitening.
-- After reconstituting the original RF frame, the WIO-E5 verifies the CRC,
-- discarding erroneous frames and passing valid ones to the device driver.
--
-- Unlike LoRaWan mode, frames with up to 253 payload bytes can be sent and
-- received using *any* data rate scheme (the combination of spreading
-- factor, modulation bandwidth, and the derived RF symbol rate).
--
-- In the context of this package, the terms "preamble" and "syncword" are
-- synonymous as are "frame" and "packet".

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

  MaxPayloadSize  : Positive;        -- bytes (1 to 253)
  QueueSize       : Positive := 10;  -- elements
  SpreadingFactor : Positive := 7;   -- (7, 8, 9, 10, 11, or 12)
  Bandwidth       : Positive := 500; -- kHz (125, 250, or 500)
  TxPreamble      : Positive := 12;  -- bits;
  RxPreamble      : Positive := 15;  -- bits;
  TxPower         : Integer  := 14;  -- dBm;

PACKAGE WIO_E5.P2P IS

  -- Type definitions

  TYPE DeviceSubclass IS NEW DeviceClass WITH PRIVATE;
  TYPE Device         IS ACCESS ALL DeviceSubclass'Class;
  TYPE Packet         IS ARRAY (1 .. MaxPayloadSize) OF Byte;

  Uninitialized  : CONSTANT DeviceSubclass;

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive;
    freqmhz  : Frequency) RETURN Device

    WITH Pre => portname'Length > 0;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceSubclass;
    portname : String;
    baudrate : Positive;
    freqmhz  : Frequency)

    WITH Pre => portname'Length > 0;

  -- Terminate background task

  PROCEDURE Shutdown(Self : DeviceSubclass)

    WITH Pre => Self /= Uninitialized;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; s : String)

    WITH Pre => Self /= Uninitialized AND s'Length > 0 AND s'Length <= Packet'Length;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; msg : Packet; len : Positive)

    WITH Pre => Self /= Uninitialized AND len > 0 AND len <= Packet'Length;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive(Self : DeviceSubclass; msg : OUT Packet; len : OUT Natural)

    WITH Pre => Self /= Uninitialized;

  -- Dump contents of a packet in hexadecimal form.

  PROCEDURE Dump(msg : Packet; len : Positive)

    WITH Pre => len > 0 AND len <= Packet'Length;

  -- Convert a message from binary to string.

  FUNCTION ToString(p : Packet; len : Positive) RETURN String

    WITH Pre => len > 0 AND len <= Packet'Length;

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
  END RECORD;

  PACKAGE Queue_Interface IS NEW Synchronized_Queue_Interfaces(Queue_Item);
  PACKAGE Queue_Package   IS NEW Bounded_Synchronized_Queues(Queue_Interface, Count_Type(QueueSize));

  TYPE Queue_Access IS ACCESS Queue_Package.Queue;

  -- WIO-E5 device class

  TYPE DeviceSubclass IS NEW DeviceClass WITH RECORD
    rxqueue  : Queue_Access;
    txqueue  : Queue_Access;
    response : TaskAccess;
  END RECORD;

  Uninitialized : CONSTANT DeviceSubclass := DeviceSubclass'(-1, NULL, NULL, NULL);

END WIO_E5.P2P;

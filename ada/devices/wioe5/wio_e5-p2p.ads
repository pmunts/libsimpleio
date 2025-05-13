-- Seeed Studio Wio-E5 LoRa Transceiver Test Mode aka P2P (Peer to Peer or
-- Point to Point) Support.  P2P is misleading because there is no station
-- addressing and all transmissions are broadcasts.  Any station with the
-- same RF settings (frequency, spreading factor, and bandwidth) will be able
-- to receive what you transmit with this package.
--
-- In test aka P2P mode, the Wio-E5 transmits unencrypted "implicit header"
-- frames consisting of a configurable number of preamble bits, 1 to 253
-- payload bytes, and two CRC bytes.  Upon reception of each frame, the Wio-E5
-- verifies the CRC, discarding erroneous frames and passing valid ones to the
-- device driver.
--
-- Unlike LoRaWan mode, frames with up to 253 payload bytes can be sent and
-- received using *any* data rate scheme (the combination of spreading
-- factor, modulation bandwidth, and the derived RF symbol rate).

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

  MaxPayloadBytes : Positive := 253; -- 1 to 253
  QueueSize       : Positive := 10;  -- elements

PACKAGE Wio_E5.P2P IS

  TYPE DeviceSubclass IS NEW DeviceClass WITH PRIVATE;
  TYPE Device         IS ACCESS ALL DeviceSubclass'Class;
  TYPE Payload        IS ARRAY (1 .. MaxPayloadBytes) OF Byte;

  -- Verify the instantiated frame size is less than or equal to 255 bytes,
  -- the maximum RF frame size.

  PRAGMA Assert(MaxPayloadBytes + 2 <= 255);

  Uninitialized    : CONSTANT DeviceSubclass;

  -- Device object constructor

  FUNCTION Create
   (portname   : String;          -- e.g. "/dev/ttyAMA0" or "/dev/ttyUSB0"
    baudrate   : Integer;         -- bits per second e.g. 115200
    freqmhz    : Frequency;       -- MHz (863.0 to 870, or 902.0 to 928.0)
    spreading  : Integer := 7;    -- (7 to 12)
    bandwidth  : Integer := 500;  -- kHz (125, 250, or 500)
    txpreamble : Integer := 12;   -- bits
    rxpreamble : Integer := 15;   -- bits
    txpower    : Integer := 14)   -- dBm (-1 to 22, subject to EIRP limits)
  RETURN Device;

  -- Device object constructor that gets configuration parameters from
  -- environment variables, some of which have default values.
  --
  -- This is mostly for MuntsOS Embedded Linux targets with configuration
  -- parameters defined in /etc/environment.
  --
  -- WIOE5_PORT
  -- WIOE5_BAUD         (Default: 115200)
  -- WIOE5_FREQ
  -- WIOE5_SPREADING    (Default: 7)
  -- WIOE5_BANDWIDTH    (Default: 500)
  -- WIOE5_TXPREAMBLE   (Default: 12)
  -- WIOE5_RXPREAMBLE   (Default: 15)
  -- WIOE5_TXPOWER      (Default: 14)

  FUNCTION Create RETURN Device;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self       : OUT DeviceSubclass;
    portname   : String;          -- e.g. "/dev/ttyAMA0" or "/dev/ttyUSB0"
    baudrate   : Integer;         -- bits per second e.g. 115200
    freqmhz    : Frequency;       -- MHz (863.0 to 870, or 902.0 to 928.0)
    spreading  : Integer := 7;    -- (7 to 12)
    bandwidth  : Integer := 500;  -- kHz (125, 250, or 500)
    txpreamble : Integer := 12;   -- bits
    rxpreamble : Integer := 15;   -- bits
    txpower    : Integer := 14);  -- dBm (-1 to 22, subject to EIRP limits)

  -- Terminate background task

  PROCEDURE Shutdown(Self : DeviceSubclass)

    WITH Pre => Self /= Uninitialized;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; s : String)

    WITH Pre => Self /= Uninitialized;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; msg : Payload; len : Positive)

    WITH Pre => Self /= Uninitialized;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive
   (Self : DeviceSubclass;
    msg  : OUT Payload;
    len  : OUT Natural;
    RSS  : OUT Integer;
    SNR  : OUT Integer)

    WITH Pre => Self /= Uninitialized;

  -- Dump contents of a payload in hexadecimal form.

  PROCEDURE Dump(msg : Payload; len : Positive)

    WITH Pre => len <= Payload'Length;

  -- Convert a payload from binary to string.

  FUNCTION ToString(p : Payload; len : Positive) RETURN String

    WITH Pre => len <= Payload'Length;

  -- Convert a payload from string to binary.

  FUNCTION ToPayload(s : String) RETURN Payload

    WITH Pre => s'Length > 0 AND s'Length <= Payload'Length;

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
    msg : Payload;
    len : Natural;
    RSS : Integer;
    SNR : Integer;
  END RECORD;

  PACKAGE Queue_Interface IS NEW Synchronized_Queue_Interfaces(Queue_Item);
  PACKAGE Queue_Package   IS NEW Bounded_Synchronized_Queues(Queue_Interface, Count_Type(QueueSize));

  TYPE Queue_Access IS ACCESS Queue_Package.Queue;

  -- Wio-E5 device class

  TYPE DeviceSubclass IS NEW DeviceClass WITH RECORD
    rxqueue  : Queue_Access;
    txqueue  : Queue_Access;
    response : TaskAccess;
  END RECORD;

  Uninitialized : CONSTANT DeviceSubclass := DeviceSubclass'(NULL, NULL, NULL, NULL);

END Wio_E5.P2P;

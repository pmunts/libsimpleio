-- Seeed Studio Wio-E5 LoRa Transceiver Support for Amateur Radio Flavor #2,
-- using test aka P2P mode and prefixing the payload with an address header.
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
--
-- Flavor #2: Stations are administered by different same ham radio operators.
--
-- The first 22 bytes of the payload are dedicated to address information:
--
-- * 10 upper case ASCII bytes for the destination network ID aka call sign,
--   left justified and space padded.
--
-- * 1 byte for the destination node ID (ARCNET style: broadcast=0,
--   unicast=1 to 255).
--
-- * 10 upper case ASCII bytes for the source network ID aka call sign,
--   left justified and space padded.
--
-- * 1 byte for the source node ID (ARCNET style: 1 to 255).
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

WITH Ada.Containers;
WITH Ada.Directories;
WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

USE TYPE Ada.Containers.Count_Type;

PACKAGE BODY Wio_E5.Ham2 IS

  -- Convert a hex string to a byte

  FUNCTION ToByte(s : string) RETURN Byte IS

  BEGIN
    RETURN Byte'Value("16#" & s & "#");
  END ToByte;

  FUNCTION ToNodeID(s : string) RETURN NodeID IS

  BEGIN
    RETURN NodeID'Value("16#" & s & "#");
  END ToNodeID;

  -- Convert a byte to hex string

  FUNCTION ToHex(b : Byte) RETURN String IS

    hexchars : CONSTANT ARRAY (0 .. 15) OF Character := "0123456789ABCDEF";

  BEGIN
    RETURN hexchars(Natural(b / 16)) & hexchars(Natural(b MOD 16));
  END ToHex;

  -- Convert a byte to hex string

  FUNCTION ToHex(b : NodeID) RETURN String IS

    hexchars : CONSTANT ARRAY (0 .. 15) OF Character := "0123456789ABCDEF";

  BEGIN
    RETURN hexchars(Natural(b / 16)) & hexchars(Natural(b MOD 16));
  END ToHex;

  -- Convert a hex string to a network ID

  FUNCTION ToNetworkID(s : string) RETURN NetworkID IS

    net : NetworkID;

  BEGIN
    FOR i IN NetworkID'Range LOOP
      net(i) := Character'Val(Natural'Value("16#" & s(s'First + 2*i - 2 .. s'First + 2*i - 1) & "#"));
    END LOOP;

    RETURN net;
  END ToNetworkID;

  -- Convert a network ID string to hex string

  FUNCTION ToHex(n : NetworkID) RETURN String IS

    s : String(1 .. NetworkID'Length*2);

  BEGIN
    FOR i IN NetworkID'Range LOOP
      s(i*2-1 .. i*2) := ToHex(Wio_E5.Byte(Character'Pos(n(i))));
    END LOOP;

    RETURN s;
  END ToHex;

  -- Check for broadcast network ID

  FUNCTION IsBroadcast(net : NetworkID) RETURN Boolean IS

  BEGIN
    RETURN net = BroadcastNet1 OR net = BroadcastNet2 OR net = BroadcastNet3;
  END IsBroadcast;

  -- Check for broadcast

  FUNCTION IsBroadcast(net : NetworkID; node : NodeID) RETURN Boolean IS

  BEGIN
    RETURN IsBroadcast(net) AND node = BroadcastNode;
  END IsBroadcast;

  -- Check for unicast

  FUNCTION IsUnicast(net : NetworkID; node : NodeID) RETURN Boolean IS

  BEGIN
    RETURN NOT IsBroadcast(net) AND node /= BroadcastNode;
  END IsUnicast;

  FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  TASK BODY BackgroundTask IS

    mydev  : DeviceSubclass;
    active : Boolean           := False;
    inrcv  : Boolean           := False;
    inxmt  : Boolean           := False;
    RSS    : Integer           := Integer'First;
    SNR    : Integer           := Integer'First;
    buf    : String(1 .. 1024) := (OTHERS => ASCII.NUL);
    buflen : Natural           := 0;

    resp_ign  : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: TXLRPKT|RFCFG");
    resp_rcv1 : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: LEN:[0-9]+, RSSI:-*[0-9]+, SNR:-*[0-9]+");
    resp_rcv2 : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RX [""][0-9a-fA-F]*[""]");

    PROCEDURE PopTxQueue IS

      item : Queue_Item;

    BEGIN
      mydev.txqueue.Dequeue(item);

      DECLARE
        cmd : String(1 .. 2*item.len + 63) := (OTHERS => '.');
      BEGIN
        cmd(1 .. 17)    := "AT+TEST=TXLRPKT, ";
        cmd(18)         := ASCII.Quotation;
        cmd(19 .. 38)   := ToHex(item.dstnet);
        cmd(39 .. 40)   := ToHex(item.dstnode);
        cmd(41 .. 60)   := ToHex(item.srcnet);
        cmd(61 .. 62)   := ToHex(item.srcnode);
        cmd(cmd'Length) := ASCII.Quotation;

        FOR i IN 1 .. item.len LOOP
          cmd(61 + i*2 .. 62 + i*2) := ToHex(item.msg(i));
        END LOOP;

        inxmt := True;
        mydev.SendATCommand(cmd);
      END;
    END PopTxQueue;

    PROCEDURE PushRxQueue
     (s   : String;
      RSS : Integer;
      SNR : Integer) IS
      PRAGMA Warnings(Off, "index for * may assume lower bound *");

      dstnet  : NetworkID := ToNetworkID(s(12 .. 31));
      dstnode : NodeID    := ToNodeID(s(32 .. 33));
      srcnet  : NetworkID := ToNetworkID(s(34 .. 53));
      srcnode : NodeID    := ToNodeID(s(54 .. 55));

      item    : Queue_Item;

    BEGIN

      -- Source network or source node must not be broadcast

      IF IsBroadcast(srcnet) OR srcnode = BroadcastNode THEN
        RETURN;
      END IF;

      -- Check for matching network ID or broadcast network ID

      IF dstnet /= mydev.network AND NOT IsBroadcast(dstnet) THEN
        RETURN;
      END IF;

      -- Check for broadcast network ID and unicast node ID

      IF IsBroadcast(dstnet) AND dstnode /= BroadcastNode THEN
        RETURN;
      END IF;

      -- Check for matching node ID or broadcast node ID

      IF dstnode /= mydev.node AND dstnode /= BroadcastNode THEN
        RETURN;
      END IF;

      item.len := (s'Length - 56)/2;

      FOR i IN 1 .. item.len LOOP
        item.msg(i) := ToByte(s(54+i*2 .. 55+i*2));
      END LOOP;

      item.srcnet  := srcnet;
      item.srcnode := srcnode;
      item.dstnet  := dstnet;
      item.dstnode := dstnode;
      item.RSS     := RSS;
      item.SNR     := SNR;
      mydev.rxqueue.Enqueue(item);

      PRAGMA Warnings(On, "index for * may assume lower bound *");
    END PushRxQueue;

    PROCEDURE ProcessResponse(s : String) IS

      i : Positive;
      j : Positive;
      k : Positive;

    BEGIN

      -- Check for frame received

      IF GNAT.Regpat.Match(resp_rcv1, s) THEN
        i   := Ada.Strings.Fixed.Index(s, "RSSI:") + 5;
        j   := Ada.Strings.Fixed.Index(s, " ", i) - 2;
        k   := Ada.Strings.Fixed.Index(s, "SNR:") + 4;
        RSS := Integer'Value(s(i .. j));
        SNR := Integer'Value(s(k .. s'Last));
        RETURN;
      END IF;

      IF s'Length >= 14 + 2*HeaderBytes AND THEN GNAT.Regpat.Match(resp_rcv2, s) THEN
        PushRxQueue(s, RSS, SNR);
        RSS := Integer'First;
        SNR := Integer'First;
        RETURN;
      END IF;

      -- Any other response poisons RSSI and SNR

      RSS := Integer'First;
      SNR := Integer'First;

      -- Check for transmit done

      IF s = "+TEST: TX DONE" THEN
        IF mydev.txqueue.Current_Use > 0 THEN
          PopTxQueue;
          RETURN;
        END IF;

        inxmt := False;
        inrcv := True;
        mydev.SendATCommand("AT+TEST=RXLRPKT");
        RETURN;
      END IF;

      -- Check for receiver started

      IF s = "+TEST: RXLRPKT" THEN
        inrcv := False;
        RETURN;
      END IF;

      -- Check for ignored responses

      IF GNAT.Regpat.Match(resp_ign, s) THEN
        RETURN;
      END IF;

      Put_Line("DEBUG: response line => " & s);
    END ProcessResponse;

    PROCEDURE ReceiveOneCharacter IS

      c : Character;

    BEGIN
      IF NOT mydev.SerialPortReceive(c) THEN
        RETURN;
      END IF;

      -- Check for buffer overrun

      IF buflen = buf'Length THEN
        buf    := (OTHERS => ASCII.NUL);
        buflen := 0;
        RETURN;
      END IF;

      buflen      := buflen + 1;
      buf(buflen) := c;

      IF buf(buflen) = ASCII.LF THEN
        buf(buflen) := ASCII.NUL;
        buflen := buflen - 1;
        IF buf(buflen) = ASCII.CR THEN
          buf(buflen) := ASCII.NUL;
          buflen := buflen - 1;
        END IF;

        IF (buflen > 0) THEN
          ProcessResponse(buf(1 .. buflen));
        END IF;

        buf    := (OTHERS => ASCII.NUL);
        buflen := 0;
      END IF;
    END ReceiveOneCharacter;

  BEGIN
    ACCEPT Initialize(dev : DeviceSubclass) DO
      mydev  := dev;
      active := True;
    END Initialize;

    -- Main task loop

    WHILE active LOOP
      SELECT
        WHEN mydev.txqueue.Current_Use = 0 AND NOT inrcv AND NOT inxmt =>
          ACCEPT Shutdown DO
            active := False;
          END Shutdown;
      ELSE

        -- Check for queued outbound frames

        IF mydev.txqueue.Current_Use > 0 AND NOT inrcv AND NOT inxmt THEN
          PopTxQueue;
        END IF;

        -- Run the serial port receiver state machine

        ReceiveOneCharacter;
      END SELECT;
    END LOOP;
  END BackgroundTask;

  -- Device object constructor

  FUNCTION Create
   (portname   : String;          -- e.g. "/dev/ttyAMA0" or "/dev/ttyUSB0"
    baudrate   : Integer;         -- bits per second e.g. 115200
    network    : NetworkID;       -- aka callsign e.g. "WA7AAA  "
    node       : NodeID;          -- ARCNET style e.g. 1 to 255
    freqmhz    : Frequency;       -- MHz (902.0 to 928.0)
    spreading  : Integer := 7;    -- (7 to 12)
    bandwidth  : Integer := 500;  -- kHz (125, 250, or 500)
    txpreamble : Integer := 12;   -- bits
    rxpreamble : Integer := 15;   -- bits
    txpower    : Integer := 22)   -- dBm (-1 to 22)
  RETURN Device IS

    dev : DeviceSubclass;

  BEGIN
    Initialize(dev, portname, baudrate, network, node, freqmhz, spreading,
      bandwidth, txpreamble, rxpreamble, txpower);
    RETURN NEW DeviceSubclass'(dev);
  END Create;

  -- Device object constructor that gets configuration parameters from
  -- environment variables, some of which have default values.
  --
  -- This is mostly for MuntsOS Embedded Linux targets with configuration
  -- parameters defined in /etc/environment.
  --
  -- WIOE5_PORT
  -- WIOE5_BAUD         (Default: 115200)
  -- WIOE5_NETWORK
  -- WIOE5_NODE
  -- WIOE5_FREQ
  -- WIOE5_SPREADING    (Default: 7)
  -- WIOE5_BANDWIDTH    (Default: 500)
  -- WIOE5_TXPREAMBLE   (Default: 12)
  -- WIOE5_RXPREAMBLE   (Default: 15)
  -- WIOE5_TXPOWER      (Default: 22)

  FUNCTION Create RETURN Device IS

    PACKAGE env RENAMES Ada.Environment_Variables;
    PACKAGE str RENAMES Ada.Strings.Fixed;

    portname   : String    := env.Value("WIOE5_PORT");
    baudrate   : Integer   := Integer'Value(env.Value("WIOE5_BAUD", "115200"));
    network    : String    := str.Head(env.Value("WIOE5_NETWORK"), 10);
    node       : NodeID    := NodeID'Value(env.Value("WIOE5_NODE"));
    freqmhz    : Frequency := Frequency'value(env.Value("WIOE5_FREQ"));
    spreading  : Integer   := Integer'value(env.Value("WIOE5_SPREADING", "7"));
    bandwidth  : Integer   := Integer'value(env.Value("WIOE5_BANDWIDTH", "500"));
    txpreamble : Integer   := Integer'value(env.Value("WIOE5_TXPREAMBLE", "12"));
    rxpreamble : Integer   := Integer'value(env.Value("WIOE5_RXPREAMBLE", "15"));
    txpower    : Integer   := Integer'value(env.Value("WIOE5_TXPOWER", "22"));

  BEGIN
    RETURN Create(portname, baudrate, network, node, freqmhz, spreading,
      bandwidth, txpreamble, rxpreamble, txpower);
  END Create;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self       : OUT DeviceSubclass;
    portname   : String;          -- e.g. "/dev/ttyAMA0" or "/dev/ttyUSB0"
    baudrate   : Integer;         -- bits per second e.g. 115200
    network    : NetworkID;       -- aka callsign e.g. "WA7AAA  "
    node       : NodeID;          -- ARCNET style e.g. 1 to 255
    freqmhz    : Frequency;       -- MHz (902.0 to 928.0)
    spreading  : Integer := 7;    -- (7 to 12)
    bandwidth  : Integer := 500;  -- kHz (125, 250, or 500)
    txpreamble : Integer := 12;   -- bits
    rxpreamble : Integer := 15;   -- bits
    txpower    : Integer := 22)   -- dBm (-1 to 22)
   IS

    config_cmd  : CONSTANT String := "AT+TEST=RFCFG," &
                                     Trim(freqmhz'Image)          & "," &
                                     "SF" & Trim(spreading'Image) & "," &
                                     Trim(bandwidth'Image)        & "," &
                                     Trim(txpreamble'Image)       & "," &
                                     Trim(rxpreamble'Image)       & "," &
                                     Trim(txpower'Image)          & "," &
                                     "ON,OFF,OFF";

    config_resp : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST:.*NET:OFF");

  BEGIN

    -- Validate parameters

    IF portname'Length < 1 THEN
      RAISE Error WITH "Invalid port name, cannot be empty";
    END IF;

    IF NOT Ada.Directories.Exists(portname) THEN
      RAISE Error WITH "Serial port device does not exist";
    END IF;

    IF baudrate /= 230400 AND baudrate /= 115200 AND baudrate /= 57600 AND
       baudrate /= 38400  AND baudrate /= 19200  AND baudrate /= 9600 THEN
      RAISE ERROR WITH "Invalid serial port data rate";
    END IF;

    IF network'Length < 1 THEN
      RAISE Error WITH "Invalid network ID, cannot be empty";
    END IF;

    IF IsBroadcast(network) THEN
      RAISE Error WITH "Invalid network ID, cannot be broadcast";
    END IF;

    IF node = BroadcastNode THEN
      RAISE Error WITH "Invalid node ID, cannot be broadcast";
    END IF;

    IF freqmhz < 902.0 OR freqmhz > 928.0 THEN
      RAISE Error WITH "Invalid RF center frequency";
    END IF;

    IF spreading < 7 OR spreading > 12 THEN
      RAISE Error WITH "Invalid spreading factor";
    END IF;

    IF bandwidth /= 125 AND bandwidth /= 250 AND bandwidth /= 500 THEN
      RAISE Error WITH "Invalid bandwidth";
    END IF;

    IF txpreamble < 1 THEN
      RAISE Error WITH "Invalid tx preamble bits";
    END IF;

    IF rxpreamble < 1 THEN
      RAISE Error WITH "Invalid rx preamble bits";
    END IF;

    IF txpower < -1 OR txpower > 22 THEN
      RAISE Error WITH "Invalid transmit power";
    END IF;

    Self.SerialPortOpen(portname, baudrate);

    -- Enter test mode

    Self.SendATCommand("AT+MODE=TEST", "+MODE: TEST", 0.15);

    -- Configure RF parameters

    Self.SendATCommand(config_cmd, config_resp, 0.15);

    -- Start receive mode

    Self.SendATCommand("AT+TEST=RXLRPKT", "+TEST: RXLRPKT", 0.15);

    -- Initialize the devicesubclass instance

    Self.network  := network;
    Self.node     := node;
    Self.rxqueue  := NEW Queue_Package.Queue;
    Self.txqueue  := NEW Queue_Package.Queue;
    Self.response := NEW BackgroundTask;

    -- Initialize the background task

    Self.response.Initialize(Self);
  END Initialize;

  -- Terminate background task

  PROCEDURE Shutdown(Self : DeviceSubclass) IS

  BEGIN
    Self.response.Shutdown;
  END Shutdown;

  -- Send a text message, which cannot be empty, to own network.

  PROCEDURE Send
   (Self    : DeviceSubclass;
    s       : String;
    dstnode : NodeID) IS

    item : Queue_Item;

  BEGIN
    IF s'Length < 1 OR s'Length > Payload'Length THEN
      RAISE Error WITH "Invalid payload length";
    END IF;

    item.msg     := ToPayload(s);
    item.len     := s'Length;
    item.srcnet  := Self.network;
    item.srcnode := Self.node;
    item.dstnet  := Self.network;
    item.dstnode := dstnode;
    item.RSS     := 0;
    item.SNR     := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send
   (Self    : DeviceSubclass;
    s       : String;
    dstnet  : NetworkID;
    dstnode : NodeID) IS
    item : Queue_Item;

  BEGIN
    IF s'Length < 1 OR s'Length > Payload'Length THEN
      RAISE Error WITH "Invalid payload length";
    END IF;

    IF dstnet /= Self.network AND NOT (IsBroadcast(dstnet, dstnode) OR IsUnicast(dstnet, dstnode)) THEN
      RAISE Error WITH "Invalid broadcast/unicast combination";
    END IF;

    item.msg     := ToPayload(s);
    item.len     := s'Length;
    item.srcnet  := Self.network;
    item.srcnode := Self.node;
    item.dstnet  := dstnet;
    item.dstnode := dstnode;
    item.RSS     := 0;
    item.SNR     := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Send a binary message, which cannot be empty, to own network.

  PROCEDURE Send
   (Self    : DeviceSubclass;
    msg     : Payload;
    len     : Positive;
    dstnode : NodeID) IS

    item : Queue_Item;

  BEGIN
    IF len > Payload'Length THEN
      RAISE Error WITH "Invalid payload length";
    END IF;

    item.msg     := msg;
    item.len     := len;
    item.srcnet  := Self.network;
    item.srcnode := Self.node;
    item.dstnet  := Self.network;
    item.dstnode := dstnode;
    item.RSS     := 0;
    item.SNR     := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send
   (Self    : DeviceSubclass;
    msg     : Payload;
    len     : Positive;
    dstnet  : NetworkID;
    dstnode : NodeID) IS


    item : Queue_Item;

  BEGIN
    IF len > Payload'Length THEN
      RAISE Error WITH "Invalid payload length";
    END IF;

    IF NOT (IsBroadcast(dstnet, dstnode) OR IsUnicast(dstnet, dstnode)) THEN
      RAISE Error WITH "Invalid broadcast/unicast combination";
    END IF;

    item.msg     := msg;
    item.len     := len;
    item.srcnet  := Self.network;
    item.srcnode := Self.node;
    item.dstnet  := dstnet;
    item.dstnode := dstnode;
    item.RSS     := 0;
    item.SNR     := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive
   (Self    : DeviceSubclass;
    msg     : OUT Payload;
    len     : OUT Natural;
    srcnet  : OUT NetworkID;
    srcnode : OUT NodeID;
    dstnet  : OUT NetworkID;
    dstnode : OUT NodeID;
    RSS     : OUT Integer;
    SNR     : OUT Integer) IS

    item : Queue_Item;

  BEGIN
    SELECT
      Self.rxqueue.Dequeue(item);
      msg     := item.msg;
      len     := item.len;
      srcnet  := item.srcnet;
      srcnode := item.srcnode;
      dstnet  := item.dstnet;
      dstnode := item.dstnode;
      RSS     := item.RSS;
      SNR     := item.SNR;
    ELSE
      len := 0;
    END SELECT;
  END Receive;

  -- Dump contents of a payload in hexadecimal form.

  PROCEDURE Dump(msg : Payload; len : Positive) IS

  BEGIN
    Put("Payload:");

    FOR i IN 1 .. len LOOP
      Put(' ');
      Put(ToHex(msg(i)));
    END LOOP;

    New_Line;
  END Dump;

  -- Convert a payload from binary to string.

  FUNCTION ToString(p : Payload; len : Positive) RETURN String IS

  BEGIN
    DECLARE
      s : String(1 .. len);
    BEGIN
      FOR i IN s'Range LOOP
        s(i) := Character'Val(p(i));
      END LOOP;

      RETURN s;
    END;
  END ToString;

  -- Convert a payload from string to binary.

  FUNCTION ToPayload(s : String) RETURN Payload IS

    p : Payload;

  BEGIN
    FOR i IN s'Range LOOP
      p(i) := Character'Pos(s(i));
    END LOOP;

    RETURN p;
  END ToPayload;

END Wio_E5.Ham2;

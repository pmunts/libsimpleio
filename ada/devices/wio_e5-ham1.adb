-- Seeed Studio WIO-E5 LoRa Transceiver Support for Amateur Radio
--
-- Flavor #1: All stations are administered by the same ham radio operator.
--
-- The first 10 bytes of the payload are dedicated to address information:
--
-- 8 ASCII bytes for the call sign, left justified and space padded.
-- 1 byte for the destination node (ARCNET style, broadcast=0, node=1 to 255).
-- 1 byte for the source node (1 to 255).

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
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH LibLinux;
WITH LibSerial;
WITH Logging.libsimpleio;

USE TYPE Ada.Containers.Count_Type;

PACKAGE BODY WIO_E5.Ham1 IS

  -- Convert a hex string to a byte

  FUNCTION ToByte(s : string) RETURN Byte IS

  BEGIN
    RETURN Byte'Value("16#" & s & "#");
  END;

  -- Convert a byte to hex string

  FUNCTION ToHex(b : Byte) RETURN String IS

    hexchars : CONSTANT ARRAY (0 .. 15) OF Character := "0123456789ABCDEF";

  BEGIN
    RETURN hexchars(Natural(b / 16)) & hexchars(Natural(b MOD 16));
  END;

  -- Convert a network ID string to hex string

  FUNCTION ToHex(n : NetworkID) RETURN String IS

    s : String(1 .. NetworkID'Length*2);

  BEGIN
    FOR i IN NetworkID'Range LOOP
      s(i*2-1 .. i*2) := ToHex(Character'Pos(n(i)));
    END LOOP;

    RETURN s;
  END;

  FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    network  : NetworkID; -- aka callsign
    node     : Byte;
    baudrate : Positive := 115200) RETURN Device IS

    dev : DeviceSubclass;

  BEGIN
    Initialize(dev, portname, network, node, baudrate);
    RETURN NEW DeviceSubclass'(dev);
  END Create;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceSubclass;
    portname : String;
    network  : NetworkID; -- aka callsign
    node     : Byte;
    baudrate : Positive := 115200) IS

  BEGIN
    OpenSerialPort(portname, baudrate, Self.fd);

    Self.network  := network;
    Self.node     := node;
    Self.rxqueue  := NEW Queue_Package.Queue;
    Self.txqueue  := NEW Queue_Package.Queue;
    Self.response := NEW BackgroundTask;
  END Initialize;

  TASK BODY BackgroundTask IS

    mydev  : DeviceSubclass;
    myfd   : Integer           := -1;
    active : Boolean           := False;
    inrcv  : Boolean           := False;
    inxmt  : Boolean           := False;
    buf    : String(1 .. 1024) := (OTHERS => ASCII.NUL);
    buflen : Natural           := 0;

    resp_cfg : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RFCFG.*");
    resp_ign : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: TXLRPKT|LEN:");
    resp_rcv : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RX [""][0-9a-fA-F]*[""]");

    PROCEDURE BufError(msg : String) IS

    BEGIN
      Logging.libsimpleio.Error(msg);
      buf    := (OTHERS => ASCII.NUL);
      buflen := 0;
    END BufError;

    PROCEDURE PopTxQueue IS

      item : Queue_Item;

    BEGIN
      mydev.txqueue.Dequeue(item);

      DECLARE
        cmd : String(1 .. 2*item.len + 39) := (OTHERS => '.');
      BEGIN
        cmd(1 .. 17)    := "AT+TEST=TXLRPKT, ";
        cmd(18)         := ASCII.Quotation;
        cmd(cmd'Length) := ASCII.Quotation;
        cmd(19 .. 34)   := ToHex(mydev.network);
        cmd(35 .. 36)   := ToHex(item.dst);
        cmd(37 .. 38)   := ToHex(item.src);

        FOR i IN 1 .. item.len LOOP
          cmd(37 + i*2 .. 38 + i*2) := ToHex(item.msg(i));
        END LOOP;

        inxmt := True;
        mydev.SendATCommand(cmd);
      END;
    END;

    PROCEDURE PushRxQueue(s : String) IS
      PRAGMA Warnings(Off, "index for * may assume lower bound *");

      network : CONSTANT String(1 .. 16) := s(12 .. 27);
      dst     : CONSTANT String(1 .. 2)  := s(28 .. 29);
      src     : CONSTANT String(1 .. 2)  := s(30 .. 31);
      item    : Queue_Item;

    BEGIN

      -- Check for matching network ID

      IF network /= ToHex(mydev.network) THEN
        RETURN;
      END IF;

      -- Check for matching node ID or broadcast ID

      IF dst /= ToHex(mydev.node) AND dst /= "00" THEN
        RETURN;
      END IF;

      item.len := (s'Length - 32)/2;

      FOR i IN 1 .. item.len LOOP
        item.msg(i) := ToByte(s(30+i*2 .. 31+i*2));
      END LOOP;

      item.src := ToByte(src);
      item.dst := ToByte(dst);

      mydev.rxqueue.Enqueue(item);

      PRAGMA Warnings(On, "index for * may assume lower bound *");
    END PushRxQueue;

    PROCEDURE ProcessResponse(s : String) IS

    BEGIN

      -- Check for packet received

      IF GNAT.Regpat.Match(resp_rcv, s) THEN
        PushRxQueue(s);
        RETURN;
      END IF;

      -- Check for RF configuration report

      IF GNAT.Regpat.Match(resp_cfg, s) THEN
        Logging.libsimpleio.Note(Ada.Strings.Fixed.Delete(s, 1, 15));
        RETURN;
      END IF;

      -- Check for transmit done

      IF s = "+TEST: TX DONE" THEN
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

    PROCEDURE ProcessCharacter(c : Character) IS

    BEGIN
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
    END ProcessCharacter;

    PROCEDURE ProcessSerialPortRcv IS

      inbuf  : Character;
      count  : Integer;
      err    : Integer;

    BEGIN
      -- Check for serial data to arrive

      libLinux.PollInput(myfd, 10, err);
      DELAY 0.0;

      -- poll() timed out

      IF err = errno.EAGAIN THEN
        -- No data is available
        RETURN;
      END IF;

      -- Check for poll() error

      IF err < 0 THEN
        -- PollInput failed
        BufError("libLinux.PollInput failed, " & errno.strerror(err));
        RETURN;
      END IF;

      -- Data is available, read a byte

      libSerial.Receive(myfd, inbuf'Address, 1, count, err);

      -- Check for read() error

      IF err < 0 THEN
        BufError("libSerial.Receive failed, " & errno.strerror(err));
        RETURN;
      END IF;

      -- Check for short read (should be impossible, but we'll check anyway)

      IF count /= 1 THEN
        BufError("libSerial.Receive failed to read a byte");
        RETURN;
      END IF;

      -- It's now a little late, but check for buffer overrun

      IF buflen = buf'Length THEN
        BufError("Response buffer overrun");
        RETURN;
      END IF;

      -- Hurray, despite all the odds, we got a byte from the serial port

      ProcessCharacter(inbuf);
    END ProcessSerialPortRcv;

  BEGIN
    ACCEPT Initialize(dev : DeviceSubclass) DO
      Logging.libsimpleio.Note("Initializing response handler task");
      mydev  := dev;
      myfd   := dev.fd;
      active := True;
    END Initialize;

    -- Main task loop

    WHILE active LOOP
      SELECT
        WHEN mydev.txqueue.Current_Use = 0 AND NOT inrcv AND NOT inxmt =>
          ACCEPT Finalize DO
            active := False;
            Logging.libsimpleio.Note("Terminating response handler task");
          END Finalize;
      ELSE

        -- Check for queued outbound packets

        IF mydev.txqueue.Current_Use > 0 AND NOT inrcv AND NOT inxmt THEN
          PopTxQueue;
        END IF;

        -- Check the serial port receiver

        ProcessSerialPortRcv;
      END SELECT;
    END LOOP;
  END BackgroundTask;

  -- Begin Peer to Peer mode.

  PROCEDURE Start
   (Self       : IN OUT DeviceSubclass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14) IS

    BWS   : CONSTANT ARRAY (Bandwidths) OF String(1 .. 3) := ("125", "250", "500");

    config_cmd  : CONSTANT String := "AT+TEST=RFCFG," &
                                     Trim(freqmhz'Image)     & "," &
                                     Trim(spread'Image)      & "," &
                                     Trim(BWS(bandwidth))    & "," &
                                     Trim(txpreamble'Image)  & "," &
                                     Trim(rxpreamble'Image)  & "," &
                                     Trim(powerdbm'Image)    & "," &
                                     "ON,OFF,OFF";

    config_resp : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST:.*NET:OFF");

  BEGIN
    -- Enter test mode

    Self.SendATCommand("AT+MODE=TEST", "+MODE: TEST", 0.15);

    -- Configure RF parameters

    Self.SendATCommand(config_cmd, config_resp, 0.15);

    -- Start receive mode

    Self.SendATCommand("AT+TEST=RXLRPKT", "+TEST: RXLRPKT", 0.15);

    -- Pass Self to the background task

    Self.response.Initialize(Self);

    -- Query RF configuration for the log

    Self.SendATCommand("AT+TEST=?");
    DELAY DefaultTimeout;
  END Start;

  -- End Peer to Peer mode.

  PROCEDURE Finish(Self : DeviceSubclass) IS

  BEGIN
    Self.response.Finalize;
  END Finish;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send
   (Self : DeviceSubclass;
    s    : String;
    dst  : Byte) IS

    item : Queue_Item;

  BEGIN
    item.msg := ToPacket(s);
    item.len := s'Length;
    item.src := Self.node;
    item.dst := dst;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send
   (Self : DeviceSubclass;
    msg  : Packet;
    len  : Positive;
    dst  : Byte) IS

    item : Queue_Item;

  BEGIN
    item.msg := msg;
    item.len := len;
    item.src := Self.node;
    item.dst := dst;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive
   (Self : DeviceSubclass;
    msg  : OUT Packet;
    len  : OUT Natural;
    src  : OUT Byte;
    dst  : OUT Byte) IS

    item : Queue_Item;

  BEGIN
    SELECT
      Self.rxqueue.Dequeue(item);
      msg := item.msg;
      len := item.len;
      src := item.src;
      dst := item.dst;
    ELSE
      len := 0;
    END SELECT;
  END Receive;

  -- Dump contents of a packet in hexadecimal form.

  PROCEDURE Dump(msg : Packet; len : Positive) IS

  BEGIN
    Put("Packet:");

    FOR i IN 1 .. len LOOP
      Put(' ');
      Put(ToHex(msg(i)));
    END LOOP;

    New_Line;
  END Dump;

  -- Convert a message from binary to string.

  FUNCTION ToString(p : Packet; len : Positive) RETURN String IS

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

  -- Convert a message from string to binary.

  FUNCTION ToPacket(s : String) RETURN Packet IS

    p : Packet;

  BEGIN
    FOR i IN s'Range LOOP
      p(i) := Character'Pos(s(i));
    END LOOP;

    RETURN p;
  END ToPacket;

END WIO_E5.Ham1;

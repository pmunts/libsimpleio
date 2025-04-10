
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

WITH Ada.Calendar;
WITH Ada.Containers;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH LibLinux;
WITH LibSerial;
WITH Logging.libsimpleio;

USE TYPE Ada.Calendar.Time;
USE TYPE Ada.Containers.Count_Type;

PACKAGE BODY WIO_E5 IS

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive := 115200) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, portname, baudrate);
    RETURN NEW DeviceClass'(dev);
  END Create;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceClass;
    portname : String;
    baudrate : Positive := 115200) IS

    err : Integer;

  BEGIN
    -- Open the serial port

    libSerial.Open(portname, baudrate, libSerial.PARITY_NONE, 8, 1, Self.fd, err);

    IF err < 0 THEN
      RAISE Error WITH "libSerial.Open failed, " & errno.strerror(err);
    END IF;
  END Initialize;

  -- Send AT command string to WIO-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String) IS

    outbuf : String := cmd & ASCII.CR & ASCII.LF;
    count  : Integer;
    err    : Integer;

  BEGIN
    libSerial.Send(Self.fd, outbuf'Address, outbuf'Length, count, err);

    IF err < 0 THEN
      RAISE Error WITH "libSerial.Send failed, " & errno.strerror(err);
    END IF;

    IF count < outbuf'Length THEN
      RAISE Error WITH "libSerial.Send failed to send all data";
    END IF;
  END SendATCommand;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendATCommand(cmd);

    IF Self.GetATResponse(timeout) /= resp THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendATCommand;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendATCommand(cmd);

    IF NOT GNAT.Regpat.Match(resp, Self.GetATResponse(timeout)) THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendATCommand;

  -- Get response string from WIO-E5

  FUNCTION GetATResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String IS

    deadline : CONSTANT Ada.Calendar.Time := Ada.Calendar.Clock + Timeout;
    inbuf    : Character;
    count    : Natural;
    err      : Integer;
    respidx  : Natural := 0;
    resp     : String(1 .. 1024) := (OTHERS => ASCII.NUL);

  BEGIN
    WHILE Ada.Calendar.Clock < deadline LOOP
      libLinux.PollInput(Self.fd, 1, err);

      IF err < 0 AND err /= errno.EAGAIN THEN
        RAISE Error WITH "libLinux.PollInput failed, " & errno.strerror(err);
      END IF;

      IF err = 0 THEN
        libSerial.Receive(Self.fd, inbuf'Address, 1, count, err);

        IF err < 0 THEN
          RAISE Error WITH "libSerial.Receive failed, " & errno.strerror(err);
        END IF;

        IF count = 0 THEN
          RAISE Error WITH "libSerial.Receive failed to receive a byte";
        END IF;

        IF respidx = resp'Length THEN
          RAISE Error WITH "response buffer overrun";
        END IF;

        respidx := respidx + 1;
        resp(respidx) := inbuf;
      END IF;
    END LOOP;

    -- Trim NUL/CR/LF from the response string

    RETURN Ada.Strings.Fixed.Trim(resp,
      Ada.Strings.Maps.Constants.Control_Set,
      Ada.Strings.Maps.Constants.Control_Set);
  END GetATResponse;

  TASK BODY P2P_Task IS

    mydev  : DeviceClass;
    myfd   : Integer           := -1;
    active : Boolean           := False;
    inxmt  : Boolean           := False;
    buf    : String(1 .. 1024) := (OTHERS => ASCII.NUL);
    buflen : Natural           := 0;

    resp_cfg : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RFCFG.*");
    resp_ign : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: TXLRPKT|RXLRPKT|LEN:");
    resp_rcv : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RX [""][0-9a-fA-F]*[""]");
    resp_xmt : CONSTANT String := "+TEST: TX DONE";

    PROCEDURE BufError(msg : String) IS

    BEGIN
      Logging.libsimpleio.Error(msg);
      buf    := (OTHERS => ASCII.NUL);
      buflen := 0;
    END BufError;

    PROCEDURE PopTxQueue IS

      item : P2P_Queue_Item;

    BEGIN
      mydev.txqueue.Dequeue(item);

      DECLARE
        cmd : String(1 .. 2*item.len + 19) := (OTHERS => '.');
      BEGIN
        cmd(1 .. 17)    := "AT+TEST=TXLRPKT, ";
        cmd(18)         := ASCII.Quotation;
        cmd(cmd'Length) := ASCII.Quotation;

        FOR i IN 1 .. item.len LOOP
          cmd(17 + i*2) := hexchars(Natural(item.msg(i) / 16));
          cmd(18 + i*2) := hexchars(Natural(item.msg(i) MOD 16));
        END LOOP;

        mydev.SendATCommand(cmd);
        inxmt := True;
      END;
    END;

    PROCEDURE PushRxQueue(s : String) IS

      item : P2P_Queue_Item;

    BEGIN
      item.len := (s'Length - 12)/2;

      FOR i IN 1 .. item.len LOOP
        item.msg(i) := Byte'Value("16#" & s(10+i*2 .. 11+i*2) & "#");
      END LOOP;

      mydev.rxqueue.Enqueue(item);
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

      IF s = resp_xmt THEN
        IF mydev.txqueue.Current_Use > 0 THEN
          -- Pop another transmit packet
          PopTxQueue;
        ELSE
          -- Restart receive mode
          inxmt := False;
          mydev.SendATCommand("AT+TEST=RXLRPKT");
        END IF;
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
    ACCEPT Initialize(dev : DeviceClass) DO
      Logging.libsimpleio.Note("Initializing response handler task");
      mydev  := dev;
      myfd   := dev.fd;
      active := True;
    END Initialize;

    -- Main task loop

    WHILE active LOOP
      SELECT
        WHEN mydev.txqueue.Current_Use = 0 AND NOT inxmt =>
          ACCEPT Finalize DO
            active := False;
            Logging.libsimpleio.Note("Terminating response handler task");
          END Finalize;
      ELSE

        -- Check for queued outbound packets

        IF mydev.txqueue.Current_Use > 0 AND NOT inxmt THEN
          PopTxQueue;
        END IF;

        -- Check the serial port receiver

        ProcessSerialPortRcv;
      END SELECT;
    END LOOP;
  END P2P_Task;

  -- Begin Peer to Peer mode.

  PROCEDURE P2P_Begin
   (Self       : IN OUT DeviceClass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14) IS

    BWS   : CONSTANT ARRAY (Bandwidths) OF String(1 .. 3) := ("125", "250", "500");

    FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

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
  
    -- Create the receive and transmit packet queues

    Self.rxqueue  := NEW P2P_Queue_Package.Queue;
    Self.txqueue  := NEW P2P_Queue_Package.Queue;

    -- Start the response message handler task

    Self.response := NEW P2P_Task;
    Self.response.Initialize(Self);

    -- Query RF configuration for the log

    Self.SendATCommand("AT+TEST=?");
    DELAY DefaultTimeout;
  END P2P_Begin;

  -- End Peer to Peer mode.

  PROCEDURE P2P_End(Self : DeviceClass) IS

  BEGIN
    Self.response.Finalize;
  END P2P_End;

  -- Send a text message, which cannot be empty.

  PROCEDURE P2P_Send(Self : DeviceClass; s : String) IS
  
    item : P2P_Queue_Item;

  BEGIN
    item.msg := ToPacket(s);
    item.len := s'Length;
    Self.txqueue.Enqueue(item);
  END P2P_Send;

  -- Send a binary message, which cannot be empty.

  PROCEDURE P2P_Send(Self : DeviceClass; msg : Packet; len : Positive) IS

    item : P2P_Queue_Item;

  BEGIN
    item.msg := msg;
    item.len := len;
    Self.txqueue.Enqueue(item);
  END P2P_Send;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE P2P_Receive(Self : DeviceClass; msg : OUT Packet; len : OUT Natural) IS

    item : P2P_Queue_Item;

  BEGIN
    SELECT
      Self.rxqueue.Dequeue(item);
      msg := item.msg;
      len := item.len;
    ELSE
      len := 0;
    END SELECT;
  END P2P_Receive;

  -- Dump contents of a packet in hexadecimal form.

  PROCEDURE Dump(msg : Packet; len : Positive) IS

  BEGIN
    Put("Packet:");

    FOR i IN 1 .. len LOOP
      Put(' ');
      Put(hexchars(Natural(msg(i) / 16)));
      Put(hexchars(Natural(msg(i) MOD 16)));
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

END WIO_E5;

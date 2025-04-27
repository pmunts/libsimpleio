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

WITH Ada.Containers;
WITH Ada.Real_Time;
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH LibLinux;
WITH LibSerial;
WITH Logging.libsimpleio;

USE TYPE Ada.Containers.Count_Type;
USE TYPE Ada.Real_Time.Time;

PACKAGE BODY Wio_E5.P2P IS

  start_time : Ada.Real_Time.Time := Ada.Real_Time.Clock;

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

  FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  TASK BODY BackgroundTask IS

    mydev  : DeviceSubclass;
    myfd   : Integer           := -1;
    active : Boolean           := False;
    inrcv  : Boolean           := False;
    inxmt  : Boolean           := False;
    RSS    : Integer           := Integer'First;
    SNR    : Integer           := Integer'First;
    buf    : String(1 .. 1024) := (OTHERS => ASCII.NUL);
    buflen : Natural           := 0;

    resp_cfg  : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RFCFG.*");
    resp_ign  : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: TXLRPKT");
    resp_rcv1 : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: LEN:[0-9]+, RSSI:-*[0-9]+, SNR:-*[0-9]+");
    resp_rcv2 : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST: RX [""][0-9a-fA-F]*[""]");

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
        cmd : String(1 .. 2*item.len + 19) := (OTHERS => '.');
      BEGIN
        cmd(1 .. 17)    := "AT+TEST=TXLRPKT, ";
        cmd(18)         := ASCII.Quotation;
        cmd(cmd'Length) := ASCII.Quotation;

        FOR i IN 1 .. item.len LOOP
          cmd(17 + i*2 .. 18 + i*2) := ToHex(item.msg(i));
        END LOOP;

        inxmt := True;
        mydev.SendATCommand(cmd);
      END;
    END;

    PROCEDURE PushRxQueue
     (s   : String;
      RSS : Integer;
      SNR : Integer) IS

      item : Queue_Item;

    BEGIN
      item.len := (s'Length - 12)/2;

      FOR i IN 1 .. item.len LOOP
        item.msg(i) := ToByte(s(10+i*2 .. 11+i*2));
      END LOOP;

      item.RSS := RSS;
      item.SNR := SNR;
      mydev.rxqueue.Enqueue(item);
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

      IF GNAT.Regpat.Match(resp_rcv2, s) THEN
        PushRxQueue(s, RSS, SNR);
        RSS := Integer'First;
        SNR := Integer'First;
        RETURN;
      END IF;

      -- Any other response poisons RSSI and SNR

      RSS := Integer'First;
      SNR := Integer'First;

      -- Check for RF configuration report

      IF GNAT.Regpat.Match(resp_cfg, s) THEN
        Logging.libsimpleio.Note(Ada.Strings.Fixed.Delete(s, 1, 15));
        RETURN;
      END IF;

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

      IF err > 0 THEN
        -- PollInput failed
        BufError("libLinux.PollInput failed, " & errno.strerror(err));
        RETURN;
      END IF;

      -- Data is available, read a byte

      libSerial.Receive(myfd, inbuf'Address, 1, count, err);

      -- Check for read() error

      IF err > 0 THEN
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
      mydev  := dev;
      myfd   := dev.fd;
      active := True;
    END Initialize;

    -- Main task loop

    WHILE active LOOP
      SELECT
        WHEN mydev.txqueue.Current_Use = 0 AND NOT inrcv AND NOT inxmt =>
          ACCEPT Shutdown DO
            active := False;
            Logging.libsimpleio.Note("Terminating response handler task");
          END Shutdown;
      ELSE

        -- Check for queued outbound frames

        IF mydev.txqueue.Current_Use > 0 AND NOT inrcv AND NOT inxmt THEN
          PopTxQueue;
        END IF;

        -- Check the serial port receiver

        ProcessSerialPortRcv;
      END SELECT;
    END LOOP;
  END BackgroundTask;

  -- Device object constructor

  FUNCTION Create
   (portname : String;
    baudrate : Positive;
    freqmhz  : Frequency) RETURN Device IS

    dev : DeviceSubclass;

  BEGIN
    Initialize(dev, portname, baudrate, freqmhz);
    RETURN NEW DeviceSubclass'(dev);
  END Create;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceSubclass;
    portname : String;
    baudrate : Positive;
    freqmhz  : Frequency) IS

    config_cmd  : CONSTANT String := "AT+TEST=RFCFG," &
                                     Trim(freqmhz'Image)                 & "," &
                                     "SF" & Trim(SpreadingFactor'Image)  & "," &
                                     Trim(Bandwidth'Image)               & "," &
                                     Trim(TxPreamble'Image)              & "," &
                                     Trim(RxPreamble'Image)              & "," &
                                     Trim(TxPower'Image)                 & "," &
                                     "ON,OFF,OFF";

    config_resp : CONSTANT GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile("\+TEST:.*NET:OFF");

  BEGIN

    -- Validate parameters

    IF Frame'Length > 253 THEN
      RAISE Error WITH "Invalid frame size setting";
    END IF;

    IF SpreadingFactor < 7 OR SpreadingFactor > 12 THEN
      RAISE Error WITH "Invalid spreading factor setting";
    END IF;

    IF Bandwidth /= 125 AND Bandwidth /= 250 AND Bandwidth /= 500 THEN
      RAISE Error WITH "Invalid bandwidth setting";
    END IF;

    IF TxPower < -1 OR TxPower > 22 THEN
      RAISE Error WITH "Invalid transmit power setting";
    END IF;

    OpenSerialPort(portname, baudrate, Self.fd);

    Self.rxqueue  := NEW Queue_Package.Queue;
    Self.txqueue  := NEW Queue_Package.Queue;
    Self.response := NEW BackgroundTask;

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
  END Initialize;

  -- Terminate background task

  PROCEDURE Shutdown(Self : DeviceSubclass) IS

  BEGIN
    Self.response.Shutdown;
  END Shutdown;

  -- Send a text message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; s : String) IS

    item : Queue_Item;

  BEGIN
    item.msg := ToFrame(s);
    item.len := s'Length;
    item.RSS := 0;
    item.SNR := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Send a binary message, which cannot be empty.

  PROCEDURE Send(Self : DeviceSubclass; msg : Frame; len : Positive) IS

    item : Queue_Item;

  BEGIN
    item.msg := msg;
    item.len := len;
    item.RSS := 0;
    item.SNR := 0;
    Self.txqueue.Enqueue(item);
  END Send;

  -- Receive a binary message, which cannot be empty.
  -- Zero length indicates no messages are available.

  PROCEDURE Receive
   (Self : DeviceSubclass;
    msg  : OUT Frame;
    len  : OUT Natural;
    RSS  : OUT Integer;
    SNR  : OUT Integer) IS

    item : Queue_Item;

  BEGIN
    SELECT
      Self.rxqueue.Dequeue(item);
      msg := item.msg;
      len := item.len;
      RSS := item.RSS;
      SNR := item.SNR;
    ELSE
      len := 0;
      RSS := Integer'First;
      SNR := Integer'First;
    END SELECT;
  END Receive;

  -- Dump contents of a frame in hexadecimal form.

  PROCEDURE Dump(msg : Frame; len : Positive) IS

  BEGIN
    Put("Frame:");

    FOR i IN 1 .. len LOOP
      Put(' ');
      Put(ToHex(msg(i)));
    END LOOP;

    New_Line;
  END Dump;

  -- Convert a message from binary to string.

  FUNCTION ToString(p : Frame; len : Positive) RETURN String IS

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

  FUNCTION ToFrame(s : String) RETURN Frame IS

    p : Frame;

  BEGIN
    FOR i IN s'Range LOOP
      p(i) := Character'Pos(s(i));
    END LOOP;

    RETURN p;
  END ToFrame;

END Wio_E5.P2P;

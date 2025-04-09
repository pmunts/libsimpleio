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

WITH Ada.Calendar;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;

WITH errno;
WITH LibLinux;
WITH LibSerial;

USE TYPE Ada.Calendar.Time;

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
    libSerial.Open(portname, baudrate, libSerial.PARITY_NONE, 8, 1, Self.fd, err);
  END Initialize;

  -- Send AT command string to WIO-E5

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String) IS

    outbuf : String := cmd & ASCII.CR & ASCII.LF;
    count  : Integer;
    err    : Integer;

  BEGIN
    libSerial.Send(Self.fd, outbuf'Address, outbuf'Length, count, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Send failed, " & errno.strerror(err);
    END IF;

    IF count < outbuf'Length THEN
      RAISE Error WITH "libSerial.Send failed to send all data";
    END IF;
  END SendCommand;

  -- Get response string from WIO-E5

  FUNCTION GetResponse
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
  END GetResponse;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendCommand(cmd);

    IF Self.GetResponse(timeout) /= resp THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendCommand;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendCommand(cmd);

    IF NOT GNAT.Regpat.Match(resp, Self.GetResponse(timeout)) THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendCommand;

--------------------------------------
-- Peer to Peer Communication Services
--------------------------------------

  BWS   : ARRAY (Bandwidths) OF String(1 .. 3) := ("125", "250", "500");
  BOOLS : ARRAY (Boolean)    OF String(1 .. 3) := (" ON", "OFF");

  FUNCTION Trim(s : String) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Trim(s, Ada.Strings.Both);
  END Trim;

  -- Enable Peer to Peer mode

  PROCEDURE P2P_Enable
   (Self       : DeviceClass;
    freqmhz    : Positive;
    spread     : SpreadingFactors := SF7;
    bandwidth  : BandWidths       := BW500K;
    txpreamble : Positive         := 12;
    rxpreamble : Positive         := 15;
    powerdbm   : Positive         := 14) IS

    cmd  : CONSTANT String := "AT+TEST=RFCFG," &
                              Trim(freqmhz'Image)     & "," &
                              Trim(spread'Image)      & "," &
                              Trim(BWS(bandwidth))    & "," &
                              Trim(txpreamble'Image)  & "," &
                              Trim(rxpreamble'Image)  & "," &
                              Trim(powerdbm'Image)    & "," &
                              "ON,OFF,OFF";

    resp : CONSTANT String := "+TEST: RFCFG F:" &
                              Trim(freqmhz'Image)    & "000000, " &
                              Trim(spread'Image)     & ", "       &
                              Trim(bandwidth'Image)  & ", TXPR:"  &
                              Trim(txpreamble'Image) & ", RXPR:"  &
                              Trim(rxpreamble'Image) & ", POW:"   &
                              Trim(powerdbm'Image)   & "dBm, "    &
                              "CRC:ON, IQ:OFF, NET:OFF";

  BEGIN
    Self.SendCommand("AT+MODE=TEST", "+MODE: TEST", 0.15);
    Self.SendCommand(cmd, resp,  0.15);
  END P2P_Enable;

  -- Send a text message

  PROCEDURE P2P_Send(Self : DeviceClass; msg : String) IS

    cmd  : CONSTANT String := "AT+TEST=TXLRSTR, """ & msg & """";

    resp : CONSTANT String := "+TEST: TXLRSTR """ & msg & """" &
                              ASCII.CR & ASCII.LF & "+TEST: TX DONE";

  BEGIN
    Self.SendCommand(cmd, resp, 0.15);
  END P2P_Send;

  -- Send a binary message

  PROCEDURE P2P_Send(Self : DeviceClass; msg : Packet) IS

  BEGIN
    NULL;
  END P2P_Send;

END WIO_E5;

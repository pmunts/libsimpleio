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

  -- Open serial port connection to the WIO-E5

  PROCEDURE OpenSerialPort
   (name     : String;
    baudrate : Positive;
    fd       : OUT Integer) IS

    err : Integer;

  BEGIN
    -- Open the serial port

    libSerial.Open(name, baudrate, libSerial.PARITY_NONE, 8, 1, fd, err);

    IF err < 0 THEN
      RAISE Error WITH "libSerial.Open failed, " & errno.strerror(err);
    END IF;
  END;

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

END WIO_E5;

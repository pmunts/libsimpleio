-- Seeed Studio Wio-E5 LoRa Transceiver Low Level Device Driver for
-- child packages.  You cannot use this package on its own.
--
-- See also: https://wiki.seeedstudio.com/LoRa-E5_STM32WLE5JC_Module

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

WITH Ada.Real_Time;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH LibLinux;
WITH LibSerial;

USE TYPE Ada.Real_Time.Time;

PACKAGE BODY Wio_E5 IS

  -- Open serial port connection to the Wio-E5

  PROCEDURE OpenSerialPort
   (name     : String;
    baudrate : Positive;
    fd       : OUT Integer) IS

    err : Integer;

  BEGIN
    -- Open the serial port

    libSerial.Open(name & ASCII.NUL, baudrate, libSerial.PARITY_NONE,
      8, 1, fd, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Open failed, " & errno.strerror(err);
    END IF;
  END;

  -- Send AT command string to Wio-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String) IS

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
  END SendATCommand;

  -- Send AT command string to Wio-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendATCommand(cmd);

    DECLARE
      s : String := Self.GetATResponse(timeout);
    BEGIN
      IF s /= resp THEN
        RAISE Error WITH "Unexpected response string: " & s;
      END IF;
    END;
  END SendATCommand;

  -- Send AT command string to Wio-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SendATCommand(cmd);

    DECLARE
      s : String := Self.GetATResponse(timeout);
    BEGIN
      IF NOT GNAT.Regpat.Match(resp, s) THEN
        RAISE Error WITH "Unexpected response string: " & s;
      END IF;
    END;
  END SendATCommand;

  -- Get response string from Wio-E5

  FUNCTION GetATResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String IS

    deadline : CONSTANT Ada.Real_Time.Time := Ada.Real_Time.Clock +
      Ada.Real_Time.To_Time_Span(Timeout);
    inbuf    : Character;
    count    : Natural;
    err      : Integer;
    respidx  : Natural := 0;
    resp     : String(1 .. 1024) := (OTHERS => ASCII.NUL);

  BEGIN
    LOOP
      IF Ada.Real_Time.Clock > deadline THEN
        resp          := (OTHERS => ASCII.NUL);
        resp(1 .. 16) := "Deadline expired";
        RETURN resp;
      END IF;

      libLinux.PollInput(Self.fd, 1, err);

      IF err > 0 AND err /= errno.EAGAIN THEN
        RAISE Error WITH "libLinux.PollInput failed, " & errno.strerror(err);
      END IF;

      IF err = 0 THEN
        libSerial.Receive(Self.fd, inbuf'Address, 1, count, err);

        IF err > 0 THEN
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

        EXIT WHEN resp(respidx) = ASCII.LF;
      END IF;
    END LOOP;

    -- Trim NUL/CR/LF from the response string

    RETURN Ada.Strings.Fixed.Trim(resp,
      Ada.Strings.Maps.Constants.Control_Set,
      Ada.Strings.Maps.Constants.Control_Set);
  END GetATResponse;

END Wio_E5;

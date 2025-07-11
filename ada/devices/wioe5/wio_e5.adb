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

WITH Ada.IO_Exceptions;
WITH Ada.Real_Time;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;
WITH Ada.Text_IO; USE Ada.Text_IO;

USE TYPE Ada.Real_Time.Time;

PACKAGE BODY Wio_E5 IS

  PACKAGE sercom RENAMES GNAT.Serial_Communications;

  -- Open serial port connection to the Wio-E5

  PROCEDURE SerialPortOpen
   (Self     : OUT DeviceClass;
    name     : String;
    baudrate : Positive) IS

    baud : sercom.Data_Rate;

  BEGIN

    -- The following baud rates are specified in "LoRa-E5 AT Command Specification".
    -- As of 2024, GNAT.Serial_Communications does not support 14400 or 78600.

    CASE baudrate IS
      WHEN 9600   =>
        baud := sercom.B9600;
--    WHEN 14400  =>
--      baud := sercom.B14400;
      WHEN 19200  =>
        baud := sercom.B19200;
      WHEN 38400  =>
        baud := sercom.B38400;
      WHEN 57600  =>
        baud := sercom.B57600;
--    WHEN 76800  =>
--      baud := sercom.B76800;
      WHEN 115200 =>
        baud := sercom.B115200;
      WHEN 230400 =>
        baud := sercom.B230400;
      WHEN OTHERS =>
        RAISE Error WITH "Invalid baud rate parameter.";
    END CASE;

    PRAGMA Warnings(Off, "use of an anonymous access type allocator");

    Self.port := NEW sercom.Serial_Port;

    PRAGMA Warnings(On, "use of an anonymous access type allocator");

    sercom.Open(Self.port.ALL, sercom.Port_Name(name));
    sercom.Set(Self.port.ALL, baud, Block => False, Timeout => 0.0);
  END;

  -- Receive one character from Wio-E5

  FUNCTION SerialPortReceive
    (Self : DeviceClass;
     c    : OUT Character) RETURN Boolean IS

  BEGIN
    Character'Read(Self.port, c);
    RETURN True;
  EXCEPTION
    WHEN Ada.IO_Exceptions.End_Error | GNAT.Serial_Communications.Serial_Error =>
      DELAY 0.005; -- Workaround for broken GNAT.Serial_Communications timeout
      RETURN False;
  END SerialPortReceive;

  -- Send a string of characters to the Wio-E5

  PROCEDURE SerialPortSend
    (Self : DeviceClass;
     s    : String) IS

  BEGIN
    String'Write(Self.port, s);
  END SerialPortSend;

  -- Send AT command string to Wio-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String) IS

  BEGIN
    Self.SerialPortSend(cmd & ASCII.CR & ASCII.LF);
  END SendATCommand;

  -- Send AT command string to Wio-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout) IS

  BEGIN
    Self.SerialPortSend(cmd & ASCII.CR & ASCII.LF);

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
    Self.SerialPortSend(cmd & ASCII.CR & ASCII.LF);

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
    respidx  : Natural := 0;
    resp     : String(1 .. 1024) := (OTHERS => ASCII.NUL);

  BEGIN
    LOOP
      IF Ada.Real_Time.Clock > deadline THEN
        resp          := (OTHERS => ASCII.NUL);
        resp(1 .. 16) := "Deadline expired";
        RETURN resp;
      END IF;

      IF Self.SerialPortReceive(inbuf) THEN
        respidx := respidx + 1;
        resp(respidx) := inbuf;

        EXIT WHEN resp(respidx) = ASCII.LF;
      END IF;

      IF respidx = resp'Length THEN
        RAISE Error WITH "response buffer overrun";
      END IF;
    END LOOP;

    -- Trim NUL/CR/LF from the response string

    RETURN Ada.Strings.Fixed.Trim(resp,
      Ada.Strings.Maps.Constants.Control_Set,
      Ada.Strings.Maps.Constants.Control_Set);
  END GetATResponse;

  PROCEDURE StopWatch IS

    now : Ada.Real_Time.Time := Ada.Real_Time.Clock;

  BEGIN
    Put_Line("Stopwatch =>" & Ada.Real_Time.To_Duration(now - start_time)'Image);
  END StopWatch;

END Wio_E5;

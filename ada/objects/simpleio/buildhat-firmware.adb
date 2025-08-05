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
WITH Ada.Directories;
WITH Ada.Exceptions;

WITH errno;
WITH GPIO.libsimpleio;
WITH libLinux;
WITH libSerial;
WITH Logging.libsimpleio;
WITH RaspberryPi;

USE TYPE Ada.Calendar.Time;
USE TYPE Ada.Directories.File_Size;

PACKAGE BODY BuildHAT.Firmware IS

  TYPE Checksum IS MOD 2**32;

  PRAGMA Provide_Shift_Operators(Checksum);

  -- Read a whole binary file into a byte array

  FUNCTION ReadFile(name : String) RETURN ByteArray IS

    fd    : Integer;
    err   : Integer;
    inbuf : ByteArray(1 .. Positive(Ada.Directories.Size(name)));
    count : Integer;

  BEGIN
    libLinux.OpenRead(name & ASCII.NUL, fd, err);

    IF err > 0 THEN
      RAISE Error WITH "libLinux.OpenRead() failed, " & errno.strerror(err);
    END IF;

    libLinux.Read(fd, inbuf'Address, inbuf'Length, count, err);

    IF err > 0 THEN
      RAISE Error WITH "libLinux.Read() failed, " & errno.strerror(err);
    END IF;

    IF count /= inbuf'Length THEN
      RAISE Error WITH "libLinux.Read() failed to read correct number of bytes";
    END IF;

    libLinux.Close(fd, err);

    IF err > 0 THEN
      RAISE Error WITH "libLinux.Close() failed, " & errno.strerror(err);
    END IF;

    RETURN inbuf;
  END ReadFile;

  -- Calculate CRC of a byte array

  FUNCTION CalcChecksum(buf : ByteArray) RETURN Checksum IS

    u : Checksum := 1;

  BEGIN
    FOR b OF buf LOOP
      IF (u AND 16#80000000#) /= 0 THEN
        u := Shift_Left(u, 1) XOR 16#1D872B41#;
      ELSE
        u := Shift_Left(u, 1);
      END IF;

      u := (u XOR Checksum(b)) AND 16#FFFFFFFF#;
    END LOOP;

    RETURN u;
  END CalcChecksum;

  -- Issue hardware reset to RP2040 microcontroller

  PRAGMA Warnings(Off, "variable ""Boot0Out"" is not referenced");

  PROCEDURE Reset IS

    ResetOut : GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO4,
                             GPIO.Output, False,
                             Polarity => GPIO.libsimpleio.ActiveLow);

    Boot0Out : GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO22,
                             GPIO.Output, True,
                             Polarity => GPIO.libsimpleio.ActiveLow);

  BEGIN
    ResetOut.Put(True);
    DELAY 0.01;
    ResetOut.Put(False);
    DELAY 0.50;
  END Reset;

  PRAGMA Warnings(On, "variable ""Boot0Out"" is not referenced");

  -- Receive one character from the RP2040 microcontroller boot loader

  PROCEDURE SerialRead
   (fd      : Integer;
    c       : OUT Character;
    success : OUT Boolean) IS

    err : Integer;
    cnt : Integer;

  BEGIN
    libLinux.PollInput(fd, 10, err);

    IF err = errno.EAGAIN THEN
      success := False;
      RETURN;
    END IF;

    IF err > 0 THEN
      RAISE Error WITH "libLinux.PollInput() failed, " & errno.strerror(err);
    END IF;

    libSerial.Receive(fd, c'Address, 1, cnt, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Receive() failed, " & errno.strerror(err);
    END IF;

    IF cnt /= 1 THEN
      RAISE Error WITH "Unexpected number of bytes received";
    END IF;

    success := True;
  END SerialRead;

  -- Wait for a response string from the RP2040 microcontroller boot loader

  PROCEDURE WaitForString
   (fd      : Integer;
    s       : String;
    timeout : Duration := 0.25) IS

  buf     : String(s'Range) := (OTHERS => ASCII.NUL);
  c       : Character;
  success : Boolean;
  Tstart  : CONSTANT Ada.Calendar.Time := Ada.Calendar.Clock;
  Tlate   : CONSTANT Ada.Calendar.Time := Tstart + timeout;

  BEGIN
    WHILE buf /= s LOOP
      LOOP
        SerialRead(fd, c, success);
        EXIT WHEN Success;

        IF Ada.Calendar.Clock > Tlate THEN
          RAISE Error WITH "Serial port timeout expired";
        END IF;
      END LOOP;

      FOR i IN 1 .. buf'Length - 1 LOOP
        buf(i) := buf(i + 1);
      END LOOP;

      buf(buf'Last) := c;
    END LOOP;
  END WaitForString;

  -- Send one character to the RP2040 microcontroller boot loader

  PROCEDURE Send(fd : integer; c : Character) IS

    err : Integer;
    cnt : Integer;

  BEGIN
    libSerial.Send(fd, c'Address, 1, cnt, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Send() failed, " & errno.strerror(err);
    END IF;

    IF cnt /= 1 THEN
      RAISE Error WITH "Unexpected number of bytes sent";
    END IF;
  END Send;

  -- Send a string to the RP2040 microcontroller boot loader

  PROCEDURE Send(fd : integer; s : String) IS

    err : Integer;
    cnt : Integer;

  BEGIN
    libSerial.Send(fd, s'Address, s'Length, cnt, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Send() failed, " & errno.strerror(err);
    END IF;

    IF cnt /= s'Length THEN
      RAISE Error WITH "Unexpected number of bytes sent";
    END IF;
  END Send;

  -- Send an array of bytes to the RP2040 microcontroller boot loader

  PROCEDURE Send(fd : integer; b : ByteArray) IS

    err : Integer;
    cnt : Integer;

  BEGIN
    libSerial.Send(fd, b'Address, b'Length, cnt, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Send() failed, " & errno.strerror(err);
    END IF;

    IF cnt /= b'Length THEN
      RAISE Error WITH "Unexpected number of bytes sent";
    END IF;
  END Send;

  -- Load Build HAT firmware via serial port

  PROCEDURE Load
   (serialport : String   := DefaultSerialPort;
    baudrate   : Positive := DefaultBaudRate;
    firmware   : String   := DefaultFirmware;
    signature  : String   := DefaultSignature) IS

    syslog    : Logging.Logger := Logging.libsimpleio.Create("Build HAT Firmware Loader");
    serialfd  : Integer;
    err       : Integer;

  BEGIN
    syslog.Note("Starting download to RP2040.");

    -- Validate parameters

    IF NOT Ada.Directories.Exists(serialport) THEN
      RAISE Error WITH "Serial port device node does not exist";
    END IF;

    IF NOT Ada.Directories.Exists(firmware) THEN
      RAISE Error WITH "File " & firmware & " does not exist";
    END IF;

    IF Ada.Directories.Size(firmware) < 1 THEN
      RAISE Error WITH "File " & firmware & " is empty";
    END IF;

    IF NOT Ada.Directories.Exists(signature) THEN
      RAISE Error WITH "File " & signature & " does not exist";
    END IF;

    IF Ada.Directories.Size(signature) < 1 THEN
      RAISE Error WITH "File " & signature & " is empty";
    END IF;

    -- Open serial port

    libSerial.Open(serialport, baudrate, 0, 8, 1, serialfd, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Open() failed, " & errno.strerror(err);
    END IF;

    DECLARE
      -- Read firmware files
      FirmwareBytes  : CONSTANT ByteArray := ReadFile(firmware);
      FirmwareSize   : CONSTANT Positive  := FirmwareBytes'Length;
      FirmwareCRC    : CONSTANT Checksum  := CalcChecksum(FirmwareBytes);
      SignatureBytes : CONSTANT ByteArray := ReadFile(signature);
      SignatureSize  : CONSTANT Positive  := SignatureBytes'Length;
    BEGIN
      -- Conduct dialog with the RP2040 microcontroller boot loader to
      -- download Build HAT firmware

      Reset;
      WaitForString(serialfd, "BHBL> ");
      Send(serialfd, "clear" & ASCII.CR);
      WaitForString(serialfd, "BHBL> ");
      Send(serialfd, "load" & FirmwareSize'Image & FirmwareCRC'Image & ASCII.CR);
      DELAY 0.1;
      Send(serialfd, ASCII.STX);
      Send(serialfd, FirmwareBytes);
      Send(serialfd, ASCII.ETX);
      WaitForString(serialfd, "BHBL> ");
      Send(serialfd, "signature" & SignatureSize'Image & ASCII.CR);
      DELAY 0.1;
      Send(serialfd, ASCII.STX);
      Send(serialfd, SignatureBytes);
      Send(serialfd, ASCII.ETX);
      WaitForString(serialfd, "BHBL> ");
      Send(serialfd, "reboot" & ASCII.CR);
      WaitForString(serialfd, "Rebooting...", 5.0);
    END;

    syslog.Note("Finished.");

  EXCEPTION
    WHEN E : OTHERS =>
      syslog.Error("ERROR: " & Ada.Exceptions.Exception_Message(E));
      RAISE;
  END Load;

END BuildHAT.Firmware;

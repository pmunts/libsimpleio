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

WITH Ada.Directories;
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH errno;
WITH libLinux;
WITH libSerial;
WITH RaspberryPi;

USE TYPE Ada.Directories.File_Size;

PACKAGE BODY BuildHAT.Firmware IS

  TYPE Checksum IS MOD 2**32;

  PRAGMA Provide_Shift_Operators(Checksum);

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

  FUNCTION CalcChecksum(buf : ByteArray) RETURN Checksum IS

  -- Reverse engineered from the following Python3 code in serinterface.py:
  --
  -- u = 1
  -- for i in range(0, len(data)):
  --     if (u & 0x80000000) != 0:
  --         u = (u << 1) ^ 0x1d872b41
  --     else:
  --         u = u << 1
  --     u = (u ^ data[i]) & 0xFFFFFFFF
  -- return u

    u : Checksum := 1;

  BEGIN
    FOR b OF buf LOOP
      IF u >= 16#80000000# THEN
        u := Shift_Left(u, 1) OR 16#1D872B41#;
      ELSE
        u := Shift_Left(u, 1);
      END IF;

      u := u OR Checksum(b);
    END LOOP;

    RETURN u;
  END CalcChecksum;

  PROCEDURE Reset IS

  -- Reverse engineered from the following Python3 code in serinterface.py:
  --
  -- reset = DigitalOutputDevice(BuildHAT.RESET_GPIO_NUMBER)
  -- boot0 = DigitalOutputDevice(BuildHAT.BOOT0_GPIO_NUMBER)
  -- boot0.off()
  -- reset.off()
  -- time.sleep(0.01)
  -- reset.on()
  -- time.sleep(0.01)
  -- boot0.close()
  -- reset.close()
  -- time.sleep(0.5)

    ResetOut : GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO4,
                             GPIO.Output, Polarity => GPIO.ActiveLow);

    Boot0Out : GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO22,
                             GPIO.Output, False);

  BEGIN
    ResetOut.Put(True)
    DELAY 0.01;
    ResetOut.Put(False);
    DELAY 0.50;
  END Reset;

  -- Load Build HAT firmware via serial port

  PROCEDURE Load
   (port      : String   := DefaultPort;
    baudrate  : Positive := DefaultBaudRate;
    firmware  : String   := DefaultFirmware;
    signature : String   := DefaultSignature) IS

    serialfd  : Integer;
    err       : Integer;

  BEGIN
    IF NOT Ada.Directories.Exists(port) THEN
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

    libSerial.Open(port, baudrate, 0, 8, 1, serialfd, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Open() failed, " & errno.strerror(err);
    END IF;

    DECLARE
      FirmwareBytes  : CONSTANT ByteArray := ReadFile(firmware);
      FirmwareCRC    : CONSTANT Checksum  := CalcChecksum(FirmwareBytes);
      SignatureBytes : CONSTANT ByteArray := ReadFile(signature);
      SignatureCRC   : CONSTANT Checksum  := CalcChecksum(SignatureBytes);
    BEGIN
      Reset;
    END;
  END Load;

END BuildHAT.Firmware;

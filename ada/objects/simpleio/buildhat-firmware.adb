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

USE TYPE Ada.Directories.File_Size;

PACKAGE BODY BuildHAT.Firmware IS

  TYPE Checksum IS MOD 2**32;

  PRAGMA Provide_Shift_Operators(Checksum);

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

  FUNCTION ReadFile(name : String) RETURN ByteArray IS

    nbytes : CONSTANT Positive := Positive(Ada.Directories.Size(name));
    inbuf  : ByteArray(1 .. nbytes);
 
  BEGIN
    RETURN inbuf;
  END ReadFile;

  -- Load Build HAT firmware via serial port

  PROCEDURE Load
   (port      : String := DefaultPort;
    firmware  : String := DefaultFirmware;
    signature : String := DefaultSignature) IS

  BEGIN

    -- Validate parameters

    IF NOT Ada.Directories.Exists(port) THEN
      RAISE Error WITH "Serial port device node does not exist";
    END IF;

    IF NOT Ada.Directories.Exists(firmware) THEN
      RAISE Error WITH "Firmware file does not exist";
    END IF;

    IF Ada.Directories.Size(firmware) < 1 THEN
      RAISE Error WITH "Firmware file is empty";
    END IF;

    IF NOT Ada.Directories.Exists(signature) THEN
      RAISE Error WITH "Signature file does not exist";
    END IF;

    IF Ada.Directories.Size(signature) < 1 THEN
      RAISE Error WITH "Signature file is empty";
    END IF;

    DECLARE

      FirmwareBuf  : ByteArray := ReadFile(firmware);
      SignatureBuf : ByteArray := ReadFile(signature);

    BEGIN
      NULL;
    END;
  END Load;

END BuildHAT.Firmware;

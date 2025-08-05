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

WITH Debug;
WITH errno;
WITH libSerial;

PACKAGE BODY BuildHAT IS

  FUNCTION Create
   (serialport : String   := DefaultSerialPort;
    baudrate   : Positive := DefaultBaudRate) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    dev.Initialize(serialport, baudrate);
    RETURN NEW DeviceClass'(dev);
  END Create;

  PROCEDURE Initialize
   (Self       : OUT DeviceClass;
    serialport : String   := DefaultSerialPort;
    baudrate   : Positive := DefaultBaudRate) IS

    err : Integer;

  BEGIN
    libSerial.Open(serialport, baudrate, 0, 8, 1, Self.fd, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Open() failed, " & errno.strerror(err);
    END IF;
  END Initialize;

  PROCEDURE Send
   (Self       : DeviceClass;
    s          : String) IS

    err : Integer;
    cnt : Integer;

  BEGIN
    Debug.Put(s);
    libSerial.Send(Self.fd, s'Address, s'Length, cnt, err);

    IF err > 0 THEN
      RAISE Error WITH "libSerial.Send() failed, " & errno.strerror(err);
    END IF;

    IF cnt /= s'Length THEN
      RAISE Error WITH "Unexpected number of bytes sent";
    END IF;
  END Send;

END BuildHAT;

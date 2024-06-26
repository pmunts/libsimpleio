-- Serial Port Send Test

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH libSerial;

PROCEDURE test_serial_send IS

  TYPE Byte IS MOD 256;

  fd     : Integer;
  error  : Integer;
  outbuf : Byte;
  count  : Integer;

BEGIN
  New_Line;
  Put_Line("Serial Port Send Test");
  New_Line;

  -- Customize the parameters to Open as necessary for a particular test run

  libSerial.Open("/dev/ttyS0" & ASCII.NUL, 115200, libSerial.PARITY_NONE, 8, 1, fd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: libSerial.Open() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  FOR i IN Natural RANGE 0 .. 255 LOOP
    outbuf := Byte(i);

    libSerial.Send(fd, outbuf'Address, 1, count, error);

    IF error /= 0 THEN
      Put_Line("ERROR: libSerial.Send() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    DELAY 0.10;
  END LOOP;

  libSerial.Close(fd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: libSerial.Close() failed, " & errno.strerror(error));
    RETURN;
  END IF;
END test_serial_send;

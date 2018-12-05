-- Linux Simple I/O Library regression test

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
WITH System;

WITH errno;
WITH libEvent;
WITH libGPIO;
WITH libHIDRaw;
WITH libI2C;
WITH libSerial;
WITH libSPI;
WITH GPIO.libsimpleio;
WITH I2C;
WITH I2C.libsimpleio;
WITH RaspberryPi;
WITH SPI;
WITH SPI.libsimpleio;

PROCEDURE test_libsimpleio IS

  error : Integer;
  epfd  : Integer;
  fd    : Integer;
  b     : I2C.Bus;
  d     : SPI.Device;
  p     : GPIO.Pin;

BEGIN
  Put_Line("Linux Simple I/O Library Regression Test");
  New_Line;

  libEvent.Open(epfd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: Event.Open() failed, " & errno.strerror(error));
  END IF;

  libEvent.Close(epfd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: Event.Close() failed, " & errno.strerror(error));
  END IF;

  libHIDRaw.Open("/dev/hidraw0" & ASCII.NUL, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: HIDRaw.Open() failed, " & errno.strerror(error));
  END IF;

  libHIDRaw.Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: HIDRaw.Close() failed, " & errno.strerror(error));
  END IF;

  libI2C.Open("/dev/i2c-1" & ASCII.NUL, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: I2C.Open() failed, " & errno.strerror(error));
  END IF;

  libI2C.Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: I2C.Close() failed, " & errno.strerror(error));
  END IF;

  libSerial.Open("/dev/ttyS0" & ASCII.NUL, 115200, 0, 8, 1, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: Serial.Open() failed, " & errno.strerror(error));
  END IF;

  libSerial.Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: Serial.Close() failed, " & errno.strerror(error));
  END IF;

  libSPI.Open("/dev/spidev0.0" & ASCII.NUL, 0, 8, 1000000, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: SPI.Open() failed, " & errno.strerror(error));
  END IF;

  libSPI.Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: SPI.Close() failed, " & errno.strerror(error));
  END IF;

  b := I2C.libsimpleio.Create("/dev/i2c-1");

  d := SPI.libsimpleio.Create("/dev/spidev0.0", 0, 8, 100000);

  p := GPIO.libsimpleio.Create(RaspberryPi.GPIO21, GPIO.Input);

  Put_line("END OF PROGRAM");
END test_libsimpleio;

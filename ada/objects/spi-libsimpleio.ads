-- SPI device services using libsimpleio

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

WITH GPIO.libsimpleio;

PACKAGE SPI.libsimpleio IS

  AUTOCHIPSELECT : CONSTANT GPIO.libsimpleio.Designator :=
    GPIO.libsimpleio.Unavailable;

  TYPE DeviceSubclass IS NEW SPI.DeviceInterface WITH PRIVATE;

  Destroyed : CONSTANT DeviceSubclass;

  -- SPI device object constructor

  FUNCTION Create
   (name     : String;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : GPIO.libsimpleio.Designator := AUTOCHIPSELECT) RETURN SPI.Device;

  -- Write only SPI bus cycle method

  PROCEDURE Write
   (Self     : DeviceSubclass;
    cmd      : Command;
    cmdlen   : Natural);

  -- Read only SPI bus cycle method

  PROCEDURE Read
   (Self     : DeviceSubclass;
    resp     : OUT Response;
    resplen  : Natural);

  -- Combined Write/Read SPI bus cycle method

  PROCEDURE Transaction
   (Self     : DeviceSubclass;
    cmd      : Command;
    cmdlen   : Natural;
    resp     : OUT Response;
    resplen  : Natural;
    delayus  : MicroSeconds := 0);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : DeviceSubclass) RETURN Integer;

PRIVATE

  TYPE DeviceSubclass IS NEW SPI.DeviceInterface WITH RECORD
    fd   : Integer;  -- SPI channel device file descriptor
    fdcs : Integer;  -- GPIO chip select pin device file descriptor
  END RECORD;

  Destroyed : CONSTANT DeviceSubclass := DeviceSubclass'(-1, -1);

END SPI.libsimpleio;

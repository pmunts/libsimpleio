-- I2C bus controller services using libsimpleio

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

WITH errno;
WITH libI2C;

PACKAGE BODY I2C.libsimpleio.Static IS

  FUNCTION Create(name : String) RETURN BusSubclass IS

    fd    : Integer;
    error : Integer;

  BEGIN
    libI2C.Open(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN I2C.libsimpleio.BusSubclass'(fd => fd);
  END Create;

  PROCEDURE Destroy(Self : IN OUT BusSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libI2C.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

END I2C.libsimpleio.Static;

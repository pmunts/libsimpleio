-- A/D (Analog to Digital) input services using libsimpleio without heap

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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
WITH libADC;

PACKAGE BODY ADC.libsimpleio.Static IS

  FUNCTION Create
   (chip       : Natural;
    channel    : Natural;
    resolution : Positive) RETURN InputSubclass IS

    fd    : Integer;
    error : Integer;

  BEGIN
    libADC.Open(chip, channel, fd, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN InputSubclass'(fd, resolution);
  END Create;

  PROCEDURE Destroy(Self : IN OUT InputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libADC.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

END ADC.libsimpleio.Static;

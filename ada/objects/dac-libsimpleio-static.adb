-- D/A (Digital to Analog) output services using libsimpleio without heap

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

WITH Analog;
WITH errno;
WITH libDAC;

USE TYPE Analog.Sample;

PACKAGE BODY DAC.libsimpleio.Static IS

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclass;
    desg       : Device.Designator;
    resolution : Positive) IS

  BEGIN
    Initialize(Self, desg.chip, desg.chan, resolution);
  END Initialize;

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclass;
    chip       : Natural;
    channel    : Natural;
    resolution : Positive) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self := Destroyed;

    libDAC.Open(chip, channel, fd, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := OutputSubclass'(fd, resolution, 2**resolution - 1);
  END Initialize;

  PROCEDURE Destroy(Self : IN OUT OutputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libDAC.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

END DAC.libsimpleio.Static;

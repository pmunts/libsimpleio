-- D/A (Digital to Analog) output services

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY DAC.libsimpleio IS

  -- DAC output object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Output IS

    Self : OutputSubclass;

  BEGIN
    Self.Initialize(desg, resolution);
    RETURN NEW OutputSubclass'(Self);
  END Create;

  -- DAC output object initializer

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclass;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libDAC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := OutputSubclass'(fd, resolution, 2**resolution - 1);
  END Initialize;

  -- DAC output object destroyer

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

  -- DAC output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclass;
    sample     : Analog.Sample) IS

    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF sample > Self.maxsample THEN
      RAISE DAC.DAC_Error WITH "Sample parameter is out of range";
    END IF;

    libDAC.Write(Self.fd, Integer(Sample), error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the DAC resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.resolution;
  END GetResolution;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether DAC output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE DAC_Error WITH "Analog output has been destroyed";
    END IF;
  END CheckDestroyed;

END DAC.libsimpleio;

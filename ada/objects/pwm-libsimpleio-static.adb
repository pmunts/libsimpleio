-- PWM (Pulse Width Modulated) output services using libsimpleio without heap

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
WITH libPWM;

PACKAGE BODY PWM.libsimpleio.Static IS

  FUNCTION Create
   (desg      : Designator;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh) RETURN OutputSubclass IS

  BEGIN
    RETURN Create(desg.chip, desg.chan, frequency, dutycycle, polarity);
  END Create;

  FUNCTION Create
   (chip      : Natural;
    channel   : Natural;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh) RETURN OutputSubclass IS

    fd     : Integer;
    period : Integer;
    ontime : Integer;
    error  : Integer;

  BEGIN

    -- The Linux kernel expects period and on-time values in nanoseconds

    period := Integer(1.0E9/Float(frequency));
    ontime := Integer(Float(dutycycle/PWM.MaximumDutyCycle)*Float(period));

    libPWM.Configure(chip, channel, period, ontime, Polarities'Pos(polarity), error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Configure() failed, " & errno.strerror(error);
    END IF;

    libPWM.Open(chip, channel, fd, error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN OutputSubclass'(fd, period);
  END Create;

  PROCEDURE Destroy(Self : IN OUT OutputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libPWM.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

END PWM.libsimpleio.Static;

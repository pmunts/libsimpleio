-- Servo output services using libsimpleio

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

PACKAGE BODY Servo.libsimpleio IS

  -- Servo output object constructor

  FUNCTION Create
   (chip      : Natural;
    channel   : Natural;
    frequency : Positive := 50;
    position  : Servo.Position := Servo.NeutralPosition)
   RETURN Servo.Interfaces.Output IS

    period : Integer;
    ontime : Integer;
    error  : Integer;
    fd     : Integer;

  BEGIN
    IF frequency > 400 THEN
      RAISE Servo_Error WITH "Frequency parameter is out of range";
    END IF;

    -- The Linux kernel expects PWM period and on-time values in nanoseconds

    period := Integer(1.0E9/Float(frequency));
    ontime := 1500000 + Integer(500000.0*position);

    libPWM.Configure(chip, channel, period, ontime, libPWM.POLARITY_ACTIVEHIGH, error);

    IF error /= 0 THEN
      RAISE Servo_Error WITH "libPWM.Configure() failed, " & errno.strerror(error);
    END IF;

    libPWM.Open(chip, channel, fd, error);

    IF error /= 0 THEN
      RAISE Servo_Error WITH "libPWM.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN NEW OutputSubclass'(fd => fd);
  END Create;

  -- Servo output write method

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    position  : Servo.Position) IS

    ontime : Integer;
    error  : Integer;

  BEGIN
    ontime := 1500000 + Integer(500000.0*position);

    libPWM.Write(Self.fd, ontime, error);

    IF error /= 0 THEN
      RAISE Servo_Error WITH "libPWM.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclass) RETURN Integer IS

  BEGIN
    RETURN Self.fd;
  END fd;

END Servo.libsimpleio;

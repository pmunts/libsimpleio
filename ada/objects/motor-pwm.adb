-- Motor services using PWM and GPIO outputs

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Motor.PWM IS

  -- Type 1 motor outputs: Consisting of one PWM output for speed and one
  -- GPIO output for direction control

  FUNCTION Create
   (pwmout : Standard.PWM.Output;
    dirout : GPIO.Pin;
    velo   : Velocity := 0.0) RETURN Motor.Interfaces.Output IS

    dev : ACCESS OutputSubclass1;

  BEGIN
    dev := NEW OutputSubclass1'(pwmout, dirout);
    dev.Put(velo);
    RETURN dev;
  END Create;

  PROCEDURE Put
   (Self : IN OUT OutputSubclass1;
    velo : Velocity) IS

  BEGIN
    IF velo >= 0.0 THEN
      -- Forward
      Self.dirout.Put(True);
      Self.pwmout.Put(Standard.PWM.DutyCycle(100.0*velo));
    ELSE
      -- Reverse
      Self.dirout.Put(False);
      Self.pwmout.Put(Standard.PWM.DutyCycle(-100.0*velo));
    END IF;
  END Put;

  -- Type 2 motor outputs: Consisting of CW (clockwise) and CCW
  -- (counterclockwise) PWM outputs

  FUNCTION Create
   (cwout  : Standard.PWM.Output;
    ccwout : Standard.PWM.Output;
    velo   : Velocity := 0.0) RETURN Motor.Interfaces.Output IS

    dev : ACCESS OutputSubclass2;

  BEGIN
    dev := NEW OutputSubclass2'(cwout, ccwout);
    dev.Put(velo);
    RETURN dev;
  END Create;

  PROCEDURE Put
   (Self : IN OUT OutputSubclass2;
    velo : Velocity) IS

  BEGIN
    IF velo >= 0.0 THEN
      -- Forward
      Self.ccwout.Put(Standard.PWM.DutyCycle(0.0));
      Self.cwout.Put(Standard.PWM.DutyCycle(100.0*velo));
    ELSE
      -- Reverse
      Self.cwout.Put(Standard.PWM.DutyCycle(0.0));
      Self.ccwout.Put(Standard.PWM.DutyCycle(-100.0*velo));
    END IF;
  END Put;

END Motor.PWM;

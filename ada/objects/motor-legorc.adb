-- Motor services for LEGO Power Functions Remote Control motors, using
-- "Single Output Mode".

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Motor.LEGORC IS

  FUNCTION Create
   (ired : NOT NULL Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : MotorID;
    velo : Motor.Velocity := 0.0) RETURN Motor.Output IS

    m : Motor.Output;

  BEGIN
    m := NEW OutputSubclass'(ired, chan, mot);
    m.Put(velo);
    RETURN m;
  END Create;

  -- Methods

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    velo : Motor.Velocity) IS

    dir : Standard.LEGORC.Direction;
    dat : Standard.LEGORC.Data;

  BEGIN
    IF velo >= 0.0 THEN
      dir := Standard.LEGORC.Forward;
      dat := Standard.LEGORC.Data(7.0*velo);
    ELSE
      dir := Standard.LEGORC.Backward;
      dat := Standard.LEGORC.Data(-7.0*velo);
    END IF;

    Self.ired.Put(Self.chan, Standard.LEGORC.Command(Self.mot), dat, dir);
  END Put;

END Motor.LEGORC;

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces;

WITH LEGORC;
WITH Motor;

PACKAGE RemoteIO.LPC1114.LEGORC IS

  TYPE OutputClass IS NEW Standard.LEGORC.OutputInterface WITH PRIVATE;

  TYPE MotorClass  IS NEW Motor.OutputInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (dev  : Abstract_Device.Device;
    pin  : Interfaces.Unsigned_32) RETURN Standard.LEGORC.Output;

  FUNCTION Create
   (outp : Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : Standard.LEGORC.MotorID;
    vel  : Motor.Velocity := 0.0) RETURN Motor.Output;

  -- Methods

  PROCEDURE Put
   (Self : OutputClass;
    chan : Standard.LEGORC.Channel;
    cmd  : Standard.LEGORC.Command;
    data : Standard.LEGORC.Speed;
    dir  : Standard.LEGORC.Direction);

  PROCEDURE Put
   (Self : IN OUT MotorClass;
    vel  : Motor.Velocity);

PRIVATE

  TYPE OutputClass IS NEW Standard.LEGORC.OutputInterface WITH RECORD
    dev  : Abstract_Device.Device;
    pin  : Interfaces.Unsigned_32;
  END RECORD;

  TYPE MotorClass  IS NEW Motor.OutputInterface WITH RECORD
    outp : Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : Standard.LEGORC.MotorID;
  END RECORD;

END RemoteIO.LPC1114.LEGORC;

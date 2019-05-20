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

WITH Interfaces; USE Interfaces;

WITH Motor;

USE TYPE Motor.Velocity;

PACKAGE BODY RemoteIO.LPC1114.LEGORC IS

  -- Constructors

  FUNCTION Create
   (dev : Abstract_Device.Device;
    pin : Unsigned_32) RETURN Standard.LEGORC.Output IS

    scmd  : SPIAGENT_COMMAND_MSG_t;
    sresp : SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    scmd.Command := SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT;
    scmd.Pin     := pin;
    scmd.Data    := 0;

    dev.Operation(scmd, sresp);

    RETURN NEW OutputClass'(dev, pin);
  END Create;

  FUNCTION Create
   (outp : Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : Standard.LEGORC.MotorID;
    vel  : Motor.Velocity := 0.0) RETURN Motor.Output IS

    m : Motor.Output;

  BEGIN
    m := NEW MotorClass'(outp, chan, mot);
    m.Put(vel);
    RETURN m;
  END Create;

  -- Methods

  PROCEDURE Put
   (Self : OutputClass;
    chan : Standard.LEGORC.Channel;
    cmd  : Standard.LEGORC.Command;
    data : Standard.LEGORC.Speed;
    dir  : Standard.LEGORC.Direction) IS

    scmd  : SPIAGENT_COMMAND_MSG_t;
    sresp : SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    scmd.Command := SPIAGENT_CMD_PUT_LEGORC;
    scmd.Pin     := Self.pin;
    scmd.Data    := Shift_Left(Unsigned_32(chan), 24) OR
      Shift_Left(Unsigned_32(Standard.LEGORC.Command'Pos(cmd)), 16) OR
      Shift_left(Unsigned_32(Standard.LEGORC.Direction'Pos(dir)), 8) OR
      Unsigned_32(data);

    Self.dev.Operation(scmd, sresp);
  END Put;

  PROCEDURE Put
   (Self : IN OUT MotorClass;
    vel  : Motor.Velocity) IS

    dir   : Standard.LEGORC.Direction;
    speed : Standard.LEGORC.Speed;

  BEGIN
    IF vel >= 0.0 THEN
      dir   := Standard.LEGORC.Forward;
      speed := Standard.LEGORC.Speed(7.0*vel);
    ELSE
      dir   := Standard.LEGORC.Backward;
      speed := Standard.LEGORC.Speed(-7.0*vel);
    END IF;

    Self.outp.Put(Self.chan, Standard.LEGORC.Command(Self.mot), speed, dir);
  END Put;

END RemoteIO.LPC1114.LEGORC;

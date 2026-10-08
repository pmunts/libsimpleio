-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

WITH Motor;
WITH Vehicle;

USE TYPE Motor.Velocity;
USE TYPE Vehicle.Steering;

PACKAGE BODY SkidSteer2WD IS

  -- 2WD skidsteer vehicle object constructor

  FUNCTION Create
   (LeftMotorDriver     : NOT NULL Motor.Output;
    RightMotorDriver    : NOT NULL Motor.Output;
    SteeringSensitivity : Vehicle.Steering := 0.2) RETURN Vehicle.Controller IS

  BEGIN
    RETURN NEW SkidSteerClass'(LeftMotorDriver, RightMotorDriver,
      SteeringSensitivity, 0.0);
  END Create;

  -- 2WD skidsteer vehicle object initializer

  PROCEDURE Initialize
   (Self                : OUT SkidSteerClass;
    LeftMotorDriver     : NOT NULL Motor.Output;
    RightMotorDriver    : NOT NULL Motor.Output;
    SteeringSensitivity : Vehicle.Steering := 0.2) IS

  BEGIN
    Self.left  := LeftMotorDriver;
    Self.right := RightMotorDriver;
    Self.sens  := SteeringSensitivity;
    Self.velo  := 0.0;
  END Initialize;

  -- Start or change forward or reverse speed

  PROCEDURE Go
   (Self : IN OUT SkidSteerClass;
    v    : Motor.Velocity;
    t    : DURATION := 0.0) IS

  BEGIN
    Self.left.Put(v);
    Self.right.Put(v);
    Self.velo := v;

    IF t > 0.0 THEN
      DELAY t;
    END IF;
  END Go;

  -- Stop forward or reverse motion

  PROCEDURE Stop(Self : IN OUT SkidSteerClass) IS

  BEGIN
    Self.Go(0.0);
  END Stop;

  -- Execute a turn

  PROCEDURE Turn
   (Self : IN OUT SkidSteerClass;
    s    : Vehicle.Steering;
    t    : DURATION) IS

  BEGIN
    IF s = Vehicle.STEER_NONE THEN
      -- No turn, so just keep moving
      RETURN;
    ELSIF Self.velo > Vehicle.SPEED_STOP THEN
      -- Moving forward
      Self.left.Put (Self.velo*Motor.Velocity(1.0 - Self.sens) +
        Motor.Velocity(s*Self.sens));
      Self.right.Put(Self.velo*Motor.Velocity(1.0 - Self.sens) -
        Motor.Velocity(s*Self.sens));
    ELSIF Self.velo < Vehicle.SPEED_STOP THEN
      -- Moving reverse
      Self.left.Put (Self.velo*Motor.Velocity(1.0 - Self.sens) -
        Motor.Velocity(s*Self.sens));
      Self.right.Put(Self.velo*Motor.Velocity(1.0 - Self.sens) +
        Motor.Velocity(s*Self.sens));
    ELSE
      -- Stopped, so just spin in place
      Self.left.Put(Motor.Velocity(s));
      Self.right.Put(Motor.Velocity(-s));
    END IF;

    DELAY t;

    -- Resume forward or reverse motion
    Self.Go(Self.velo);
  END Turn;
END SkidSteer2WD;

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

PACKAGE SkidSteer2WD IS

  TYPE SkidSteerClass IS NEW Vehicle.ControllerInterface WITH PRIVATE;

  -- 2WD skidsteer vehicle object constructor

  FUNCTION Create
   (LeftMotorDriver     : NOT NULL Motor.Output;
    RightMotorDriver    : NOT NULL Motor.Output;
    SteeringSensitivity : Vehicle.Steering := 0.2) RETURN Vehicle.Controller;

  -- 2WD skidsteer vehicle object initializer

  PROCEDURE Initialize
   (Self                : OUT SkidSteerClass;
    LeftMotorDriver     : NOT NULL Motor.Output;
    RightMotorDriver    : NOT NULL Motor.Output;
    SteeringSensitivity : Vehicle.Steering := 0.2);

  -- Start or change forward or reverse speed

  PROCEDURE Go
   (Self : IN OUT SkidSteerClass;
    v    : Motor.Velocity;
    t    : DURATION := 0.0);

  -- Stop forward or reverse motion

  PROCEDURE Stop(Self : IN OUT SkidSteerClass);

  -- Execute a turn

  PROCEDURE Turn
   (Self : IN OUT SkidSteerClass;
    s    : Vehicle.Steering;
    t    : DURATION);

PRIVATE

  TYPE SkidSteerClass IS NEW Vehicle.ControllerInterface WITH RECORD
    left  : Motor.Output;
    right : Motor.Output;
    sens  : Vehicle.Steering;
    velo  : Motor.Velocity;
  END RECORD;

END SkidSteer2WD;

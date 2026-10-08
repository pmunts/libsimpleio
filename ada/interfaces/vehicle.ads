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

PACKAGE Vehicle IS

  TYPE Steering IS NEW Long_Float RANGE -1.0 .. +1.0;

  SPEED_MIN  : CONSTANT Motor.Velocity := Motor.Velocity'First;
  SPEED_STOP : CONSTANT Motor.Velocity := 0.0;
  SPEED_MAX  : CONSTANT Motor.Velocity := Motor.Velocity'Last;

  STEER_MIN  : CONSTANT Steering := Steering'First;
  STEER_MAX  : CONSTANT Steering := Steering'Last;
  STEER_NONE : CONSTANT Steering := 0.0;

  -- Define an abstract interface for vehicle control systems

  TYPE ControllerInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- ControllerInterface

  TYPE Controller IS ACCESS ALL ControllerInterface'Class;

  -- Start or change forward or reverse speed

  PROCEDURE Go
   (Self : IN OUT ControllerInterface;
    v    : Motor.Velocity;
    t    : DURATION := DURATION'Last) IS ABSTRACT;

  -- Stop forward or reverse motion

  PROCEDURE Stop(Self : IN OUT ControllerInterface) IS ABSTRACT;

  -- Execute a turn

  PROCEDURE Turn
   (Self : IN OUT ControllerInterface;
    s    : Steering;
    t    : DURATION) IS ABSTRACT;

END Vehicle;

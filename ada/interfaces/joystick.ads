-- Abstract interface for 9 position joystick switches

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

PACKAGE Joystick IS

  Joystick_Error : Exception;

  -- Joystick positions, named for the points of a compass

  TYPE Positions IS
   (Center,
    North,
    Northeast,
    East,
    Southeast,
    South,
    Southwest,
    West,
    Northwest);

  -- Define an abstract interface for joystick devices

  TYPE DeviceInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- DeviceInterface

  TYPE Device IS ACCESS ALL DeviceInterface'Class;

  -- Joystick position method

  FUNCTION Position(Self : DeviceInterface) RETURN Positions IS ABSTRACT;

  -- Joystick pressed method

  FUNCTION Pressed(Self : DeviceInterface) RETURN Boolean IS ABSTRACT;

END Joystick;

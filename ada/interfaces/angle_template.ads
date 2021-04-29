-- Abstract angle sensor and actuator interface definitions

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Text_IO;
WITH Ada.Numerics;
WITH IO_Interfaces;

PRIVATE WITH Ada.Numerics.Generic_Elementary_Functions;

GENERIC

  TYPE Float_Type IS DIGITS <>;

PACKAGE Angle_Template IS

  -- Define a type for full circle angle values

  TYPE Radians IS NEW Float_Type RANGE -2.0*Ada.Numerics.Pi .. 2.0*Ada.Numerics.Pi;

  TYPE Degrees IS NEW Float_Type RANGE -360.0 .. +360.0;

  -- Instantiate text I/O package

  PACKAGE Radians_IO IS NEW Ada.Text_IO.Float_IO(Radians);

  PACKAGE Degrees_IO IS NEW Ada.Text_IO.Float_IO(Degrees);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(Radians);

  -- Interfaces

  TYPE InputInterface IS INTERFACE AND Interfaces.InputInterface;

  TYPE OutputInterface IS INTERFACE AND Interfaces.OutputInterface;

  TYPE InputOutputInterface IS INTERFACE AND Interfaces.InputOutputInterface;

  -- Access types

  TYPE Input IS ACCESS ALL InputInterface'Class;

  TYPE Output IS ACCESS ALL OutputInterface'Class;

  TYPE InputOutput IS ACCESS ALL InputOutputInterface'Class;

  -- Conversion functions

  FUNCTION To_Degrees(theta : Radians) RETURN Degrees;

  FUNCTION To_Radians(theta : Degrees) RETURN Radians;

  -- Trigonometric functions

  FUNCTION Sin(theta : Radians) RETURN Float_Type;

  FUNCTION Cos(theta : Radians) RETURN Float_Type;

  FUNCTION Tan(theta : Radians) RETURN Float_Type;

  FUNCTION Cot(theta : Radians) RETURN Float_Type;

PRIVATE

  Degrees_Per_Radian : CONSTANT := 180.0*Ada.Numerics.Pi;
  Radians_Per_Degree : CONSTANT := Ada.Numerics.Pi/180.0;

  -- Conversion functions

  FUNCTION To_Degrees(theta : Radians) RETURN Degrees IS
   (Degrees(Float_Type(theta)*Degrees_Per_Radian));

  FUNCTION To_Radians(theta : Degrees) RETURN Radians IS
   (Radians(Float_Type(theta)*Radians_Per_Degree));

  -- Instantiate elementary functions

  PACKAGE Trig IS NEW Ada.Numerics.Generic_Elementary_Functions(Float_Type);

  -- Trigonometric functions

  FUNCTION Sin(theta : Radians) RETURN Float_Type IS
   (Trig.Sin(Float_Type(theta)));

  FUNCTION Cos(theta : Radians) RETURN Float_Type IS
   (Trig.Cos(Float_Type(theta)));

  FUNCTION Tan(theta : Radians) RETURN Float_Type IS
   (Trig.Tan(Float_Type(theta)));

  FUNCTION Cot(theta : Radians) RETURN Float_Type IS
   (Trig.Cot(Float_Type(theta)));

END Angle_Template;

-- Temperature measurement definitions

-- Copyright (C)2016-2019, Philip Munts, President, Munts AM Corp.
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
WITH IO_Interfaces;

PACKAGE Temperature IS

  TYPE Kelvins    IS NEW Float RANGE 0.0 .. Float'Large;
  TYPE Celsius    IS NEW Float RANGE -273.16 .. Float'Large;
  TYPE Fahrenheit IS NEW Float RANGE -459.67 .. Float'Large;

  -- Define some temperature constants

  AbsoluteZero  : CONSTANT Celsius := -273.16;
  FreezingPoint : CONSTANT Celsius := 0.0;
  BoilingPoint  : CONSTANT Celsius := 100.0;

  -- Instantiate text I/O packages

  PACKAGE Kelvins_IO    IS NEW Ada.Text_IO.Float_IO(Kelvins);
  PACKAGE Celsius_IO    IS NEW Ada.Text_IO.Float_IO(Celsius);
  PACKAGE Fahrenheit_IO IS NEW Ada.Text_IO.Float_IO(Fahrenheit);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(Celsius);

  -- Define an abstract interface for temperature sensor intputs, derived from
  -- Interfaces.InputInterface

  TYPE InputInterface IS INTERFACE AND Interfaces.InputInterface;

  -- Define an access type compatible with any subclass implementing
  -- InputInterface

  TYPE Input IS ACCESS ALL InputInterface'Class;

END Temperature;

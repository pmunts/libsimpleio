-- Pressure measurement definitions

-- Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

PACKAGE Pressure IS

  TYPE Pascals IS NEW Float;

  -- Conversion factors

  Pascals_per_atmosphere     : CONSTANT := 1.01325E+05;
  Pascals_per_millibar       : CONSTANT := 1.0E+02;
  Pascals_per_bar            : CONSTANT := 1.0E+05;
  Pascals_per_PSI            : CONSTANT := 6.894757E+03;
  Pascals_per_inches_mercury : CONSTANT := 3.386389E+03;

  -- Instantiate text I/O package

  PACKAGE Pascals_IO IS NEW Ada.Text_IO.Float_IO(Pascals);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(Pascals);

  -- Define an abstract interface for pressure sensor inputs, derived from
  -- Interfaces.InputInterface

  TYPE InputInterface IS INTERFACE AND Interfaces.InputInterface;

  -- Define an access type compatible with any subclass implementing
  -- InputInterface

  TYPE Input IS ACCESS ALL InputInterface'Class;

END Pressure;

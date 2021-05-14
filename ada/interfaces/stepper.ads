-- Abstract interface for stepper motors

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
WITH IO_Interfaces;

PACKAGE Stepper IS

  Error : EXCEPTION;

  TYPE Steps IS NEW Integer; -- Forward is positive and reverse is negative
  TYPE Rate  IS NEW Float;   -- Forward is positive and reverse is negative

  -- Instantiate text I/O packages

  PACKAGE Steps_IO IS NEW Ada.Text_IO.Integer_IO(Steps);

  PACKAGE Rate_IO IS NEW Ada.Text_IO.Float_IO(Rate);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(Steps);

  -- Define an interface for stepper motor outputs

  TYPE OutputInterface IS INTERFACE AND Interfaces.OutputInterface;

  -- Define an access type for stepper motor outputs

  TYPE OUTPUT IS ACCESS ALL OutputInterface'Class;

  -- Additional methods aka primitive operations

  PROCEDURE Put
   (Self   : IN OUT OutputInterface;
    nsteps : Steps;
    slew   : Rate) IS ABSTRACT;

  FUNCTION StepsPerRotation
   (Self   : IN OUT OutputInterface) RETURN Steps IS ABSTRACT;

END Stepper;

-- Abstract servo output interface definitions

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

PACKAGE Servo IS

  Servo_Error : EXCEPTION;

  TYPE Position IS NEW Float RANGE -1.0 .. 1.0;

  MinimumPosition  : CONSTANT Position := Position'First;
  NeutralPosition  : CONSTANT Position := 0.0;
  MaximumPosition  : CONSTANT Position := Position'Last;

  -- Instantiate text I/O package

  PACKAGE Position_IO IS NEW Ada.Text_IO.Float_IO(Position);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(Position);

  -- Define an abstract interface for servo outputs, derived from
  -- Interfaces.OutputInterface

  TYPE OutputInterface IS INTERFACE AND Interfaces.OutputInterface;

  -- Define an access type compatible with any subclass implementing
  -- OutputInterface

  TYPE Output IS ACCESS ALL OutputInterface'Class;

END Servo;

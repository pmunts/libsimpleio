-- Abstract interface for I2C bus controllers

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE I2C IS

  -- Define an exception for I2C errors

  I2C_Error : EXCEPTION;

  -- Type definitions

  TYPE Address IS RANGE 0 .. 127;

  TYPE Byte IS MOD 256;

  TYPE Command IS ARRAY (Natural RANGE <>) OF Byte;

  TYPE Response IS ARRAY (Natural RANGE <>) OF Byte;

  TYPE MicroSeconds IS RANGE 0 .. 65535;

  -- Define an abstract interface for I2C bus controllers

  TYPE BusInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- I2C.BusInterface

  TYPE Bus IS ACCESS ALL I2C.BusInterface'Class;

  -- I2C clock speed constants

  SpeedStandard : CONSTANT Positive := 100_000;
  SpeedFast     : CONSTANT Positive := 400_000;
  SpeedFastPlus : CONSTANT Positive := 1_000_000;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusInterface;
    addr    : Address;
    resp    : OUT Response;
    resplen : Natural) IS ABSTRACT;

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self   : BusInterface;
    addr   : Address;
    cmd    : Command;
    cmdlen : Natural) IS ABSTRACT;

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusInterface;
    addr    : Address;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0) IS ABSTRACT;

  -- Dump a command buffer in hexadecimal format

  PROCEDURE Dump
   (cmd     : Command;
    cmdlen  : Natural := Natural'Last);

  -- Dump a response buffer in hexadecimal format

  PROCEDURE Dump
   (resp    : Response;
    resplen : Natural := Natural'Last);

END I2C;

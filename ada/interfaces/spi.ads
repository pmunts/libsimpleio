-- Abstract interface for SPI devices

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE SPI IS

  -- Define an exception for SPI errors

  SPI_Error : EXCEPTION;

  -- Type definitions

  TYPE Byte IS MOD 256;

  TYPE Command IS ARRAY (Natural RANGE <>) OF Byte;

  TYPE Response IS ARRAY (Natural RANGE <>) OF Byte;

  TYPE MicroSeconds IS RANGE 0 .. 65536;

  -- Define an abstract interface for SPI devices

  TYPE DeviceInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- SPI.DeviceInterface

  TYPE Device IS ACCESS ALL SPI.DeviceInterface'Class;

  -- Write only SPI bus cycle method

  PROCEDURE Write
   (Self     : DeviceInterface;
    cmd      : Command;
    cmdlen   : Natural) IS ABSTRACT;

  -- Read only SPI bus cycle method

  PROCEDURE Read
   (Self     : DeviceInterface;
    resp     : OUT Response;
    resplen  : Natural) IS ABSTRACT;

  -- Combined Write/Read SPI bus cycle method

  PROCEDURE Transaction
   (Self     : DeviceInterface;
    cmd      : Command;
    cmdlen   : Natural;
    resp     : OUT Response;
    resplen  : Natural;
    delayus  : MicroSeconds := 0) IS ABSTRACT;

END SPI;

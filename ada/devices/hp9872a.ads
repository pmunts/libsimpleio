-- HP9872A HP-GL Plotter Services

-- Copyright (C)2023, Philip Munts.
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

WITH GPIB.Slave;

PACKAGE HP9872A IS

  -- Maximum plotting area

  TYPE Height IS NEW Natural RANGE 0 .. 11400;  -- 0.025 mm per step
  TYPE Width  IS NEW Natural RANGE 0 .. 16000;  -- 0.025 mm per step

  -- Error numbers sent by the plotter in response to the OE
  -- (Output Error) instruction:

  OE_NOERROR                    : CONSTANT := 0;
  OE_UNRECOGNIZED_INSTRUCTION   : CONSTANT := 1;
  OE_WRONG_NUMBER_OF_PARAMETERS : CONSTANT := 2;
  OE_OUT_OF_RANGE_PARAMETERS    : CONSTANT := 3;
  OE_ILLEGAL_CHARACTERS         : CONSTANT := 4;
  OE_UNKNOWN_CHARACTER_SET      : CONSTANT := 5;
  OE_POSITION_OVERFLOW          : CONSTANT := 6;

  -- Bit mask values sent by the plotter in response to the OS
  -- (Output Status) instruction

  OS_PEN_DOWN                   : CONSTANT := 1;
  OS_P1_OR_P2_CHANGED           : CONSTANT := 2;
  OS_DIGITIZED_POINT_AVAILABLE  : CONSTANT := 4;
  OS_INITIALIZED                : CONSTANT := 8;
  OS_READY_FOR_DATA             : CONSTANT := 16;
  OS_ERROR                      : CONSTANT := 32;
  OS_REQUIRE_SERVICE_MESSAGE    : CONSTANT := 64;

  -- Default GPIB slave address

  DefaultAddress : CONSTANT GPIB.Address := 5;

  TYPE Device IS NEW GPIB.Slave.DeviceClass WITH PRIVATE;

PRIVATE

  TYPE Device IS NEW GPIB.Slave.DeviceClass WITH NULL RECORD;

END HP9872A;

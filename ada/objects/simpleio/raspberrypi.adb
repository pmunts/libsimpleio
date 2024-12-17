-- Raspberry Pi I/O Resource Definitions

-- Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Strings.Fixed;

WITH libLinux;

PACKAGE BODY RaspberryPi IS

  -- Current (more or less) 64-bit models

  RaspberryPi2_2710 : CONSTANT String := "Raspberry Pi 2 Model B Rev 1.2";
  RaspberryPi3      : CONSTANT String := "Raspberry Pi 3";
  RaspberryPiCM3    : CONSTANT String := "Raspberry Pi Compute Module 3";
  RaspberryPiZero2  : CONSTANT String := "Raspberry Pi Zero 2";
  RaspberryPi4      : CONSTANT String := "Raspberry Pi 4";
  RaspberryPiCM4    : CONSTANT String := "Raspberry Pi Compute Module 4";
  RaspberryPi5      : CONSTANT String := "Raspberry Pi 5";
  RaspberryPiCM5    : CONSTANT String := "Raspberry Pi Compute Module 5";

  -- Obsolete 32-bit models

  RaspberryPi1      : CONSTANT String := "Raspberry Pi Model";
  RaspberryPiCM1    : CONSTANT String := "Raspberry Pi Compute Module Rev";
  RaspberryPiZero   : CONSTANT String := "Raspberry Pi Zero Rev";
  RaspberryPiZeroW  : CONSTANT String := "Raspberry Pi Zero W Rev";
  RaspberryPi2      : CONSTANT String := "Raspberry Pi 2";

  -- Detect the CPU generation

  FUNCTION GetCPU RETURN CPUs IS

    ModelName : CONSTANT String := libLinux.ModelName;

  BEGIN

    -- Current (more or less) 64-bit models

    IF Ada.Strings.Fixed.Index(ModelName, RaspberryPi2_2710) > 0 OR
       Ada.Strings.Fixed.Index(ModelName, RaspberryPi3)      > 0 OR
       Ada.Strings.Fixed.Index(ModelName, RaspberryPiCM3)    > 0 OR
       Ada.Strings.Fixed.Index(ModelName, RaspberryPiZero2)  > 0 THEN
      RETURN BCM2710;
    END IF;

    IF Ada.Strings.Fixed.Index(ModelName, RaspberryPi4)      > 0 OR
       Ada.Strings.Fixed.Index(ModelName, RaspberryPiCM4)    > 0 THEN
      RETURN BCM2711;
    END IF;

    IF Ada.Strings.Fixed.Index(ModelName, RaspberryPi5)      > 0 OR
       Ada.Strings.Fixed.Index(ModelName, RaspberryPiCM5)    > 0 THEN
      RETURN BCM2712;
    END IF;

    -- Obsolete 32-bit models

    IF Ada.Strings.Fixed.Index(ModelName, RaspberryPiCM1)    > 0 THEN
      RETURN BCM2708;
    END IF;

    IF Ada.Strings.Fixed.Index(ModelName, RaspberryPi2)      > 0 THEN
      RETURN BCM2709;
    END IF;

    RETURN UNKNOWN;
  END GetCPU;

END RaspberryPi;

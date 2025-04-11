-- CPU information services

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

WITH libLinux;

PACKAGE CPUInfo IS

  UNKNOWN_MODEL : String RENAMES liblinux.UNKNOWN_MODEL;

  -- Known CPU kinds

  TYPE Kinds IS
   (AM6254,   -- BeaglePlay
    H618,     -- Orange Pi Zero 2W
    BCM2708,  -- Raspberry Pi 1
    BCM2709,  -- Raspberry Pi 2
    BCM2710,  -- Raspberry Pi 3
    BCM2711,  -- Raspberry Pi 4
    BCM2712,  -- Raspberry Pi 5
    UNKNOWN);

  -- CPU kind synonyms

  BCM2835   : CONSTANT Kinds := BCM2708; -- Raspberry Pi 1
  BCM2836   : CONSTANT Kinds := BCM2709; -- Raspberry Pi 2
  BCM2837   : CONSTANT Kinds := BCM2710; -- Raspberry Pi 3
  BCM2837B0 : CONSTANT Kinds := BCM2710; -- Raspberry Pi 3+
  RP3A0     : CONSTANT Kinds := BCM2710; -- Raspberry Pi Zero 2 W

  TYPE Platforms IS
   (BeaglePlay,
    OrangePiZero2W,
    RaspberryPi,
    UNKNOWN);

  -- Fetch the CPU device tree model name

  FUNCTION ModelName RETURN String RENAMES libLinux.ModelName;

  -- Fetch the CPU kind

  FUNCTION Kind RETURN Kinds;

  -- Fetch the platform

  FUNCTION Platform RETURN Platforms;

END CPUInfo;

-- PCA9685 GPIO output services

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

WITH GPIO;

PACKAGE PCA9685.GPIO IS

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH PRIVATE;

  -- PCA9685 GPIO output object constructor

  FUNCTION Create
   (device  : NOT NULL PCA9685.Device;
    channel : PCA9685.ChannelNumber;
    state   : Boolean := False) RETURN Standard.GPIO.Pin;

  -- PCA9685 GPIO read method

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- PCA9685 GPIO write method

  PROCEDURE Put(Self : IN OUT PinSubclass; state: Boolean);

PRIVATE

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH RECORD
    device  : PCA9685.Device;
    channel : PCA9685.ChannelNumber;
  END RECORD;

END PCA9685.GPIO;

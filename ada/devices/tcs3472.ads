-- TCS3472 Color Sensor services

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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
WITH I2C;

PACKAGE TCS3472 IS

  TYPE Brightness IS MOD 2**16;

  TYPE Channels IS (Clear, Red, Green, Blue);

  TYPE Gains IS (X1, X4, X16, X60);

  TYPE Sample IS ARRAY (Channels) OF Brightness;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Instantiate text I/O package for Brightness

  PACKAGE Brightness_IO IS NEW Ada.Text_IO.Modular_IO(Brightness);

  -- Instantiate abstract interfaces package for Sample

  PACKAGE Interfaces IS NEW IO_Interfaces(Sample);

  -- Define a device type

  TYPE DeviceSubclass IS NEW Interfaces.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  TYPE Time IS NEW Natural RANGE 1 .. 256;

  -- Constructor

  FUNCTION Create
   (bus     : NOT NULL I2C.Bus;
    address : I2C.Address) RETURN Device;

  -- Methods

  FUNCTION Get
   (Self : IN OUT DeviceSubclass) RETURN Sample;

  FUNCTION Get
   (Self   : IN OUT DeviceSubclass;
    aticks : Time;
    wticks : Time := 1;
    gain   : Gains := X1;
    wlong  : Boolean := False) RETURN Sample;

PRIVATE

  TYPE DeviceSubclass IS NEW Interfaces.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
  END RECORD;
END TCS3472;

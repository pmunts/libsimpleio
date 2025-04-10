-- Seeed Studio WIO-E5 LoRa Transceiver Low Level Device Driver for
-- child packages.  You cannot use this package on its own.
--
-- See also: https://wiki.seeedstudio.com/LoRa-E5_STM32WLE5JC_Module

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

PRIVATE WITH GNAT.Regpat;

PACKAGE WIO_E5 IS

  Error : EXCEPTION;

  -- Type definitions

  TYPE DeviceClass      IS TAGGED PRIVATE;
  TYPE SpreadingFactors IS (SF7, SF8, SF9, SF10, SF11, SF12);
  TYPE Bandwidths       IS (BW125K, BW250K, BW500K);

PRIVATE

  DefaultTimeout : CONSTANT Duration := 0.02;

  -- Open serial port connection to the WIO-E5

  PROCEDURE OpenSerialPort
   (name     : String;
    baudrate : Positive;
    fd       : OUT Integer)

    WITH Pre => name'Length > 0;

  -- Send AT command string to WIO-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String)

    WITH Pre => cmd'Length > 0;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout)

    WITH Pre => cmd'Length > 0 AND resp'Length > 0;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout)

    WITH Pre => cmd'Length > 0;

  -- Get response string from WIO-E5

  FUNCTION GetATResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String;

  -- WIO-E5 device class

  TYPE DeviceClass IS TAGGED RECORD
    fd : Integer := -1;
  END RECORD;

END WIO_E5;

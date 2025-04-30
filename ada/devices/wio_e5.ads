-- Seeed Studio Wio-E5 LoRa Transceiver Low Level Device Driver for
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

PACKAGE Wio_E5 IS

  Error : EXCEPTION;

  -- Type definitions

  TYPE Byte             IS MOD 256;
  TYPE DeviceClass      IS TAGGED PRIVATE;
  TYPE Frequency        IS DELTA 0.001 DIGITS 6; -- MHz e.g. 915.000

PRIVATE

  DefaultTimeout : CONSTANT Duration := 0.02;

  -- Open serial port connection to the Wio-E5

  PROCEDURE SerialPortOpen
   (Self     : OUT DeviceClass;
    name     : String;
    baudrate : Positive)

    WITH Pre => name'Length > 0;

  -- Receive one character from Wio-E5

  FUNCTION SerialPortReceive
    (Self : DeviceClass;
     c    : OUT Character) RETURN Boolean;

  -- Send a string of characters to the Wio-E5

  PROCEDURE SerialPortSend
    (Self : DeviceClass;
     s    : String)

    WITH Pre => s'Length > 0;

  -- Send AT command string to Wio-E5

  PROCEDURE SendATCommand(Self : DeviceClass; cmd : String)

    WITH Pre => cmd'Length > 0;

  -- Send AT command string to Wio-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : String;
    timeout : Duration := DefaultTimeout)

    WITH Pre => cmd'Length > 0 AND resp'Length > 0;

  -- Send AT command string to Wio-E5 expecting a response string

  PROCEDURE SendATCommand
   (Self    : DeviceClass;
    cmd     : String;
    resp    : GNAT.Regpat.Pattern_Matcher;
    timeout : Duration := DefaultTimeout)

    WITH Pre => cmd'Length > 0;

  -- Get response string from Wio-E5

  FUNCTION GetATResponse
   (Self    : DeviceClass;
    timeout : Duration := DefaultTimeout) RETURN String;

  -- Wio-E5 device class

  TYPE DeviceClass IS TAGGED RECORD
    fd : Integer := -1;
  END RECORD;

  start_time : Ada.Real_Time.Time := Ada.Real_Time.Clock;

  PROCEDURE StopWatch;
`
END Wio_E5;

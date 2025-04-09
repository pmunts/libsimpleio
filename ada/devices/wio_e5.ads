-- Seeed Studio WIO-E5 LoRa Transceiver Device Driver

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

WITH GNAT.Regpat;
WITH GNAT.Serial_Communications;

PACKAGE WIO_E5 IS

  PACKAGE Serial RENAMES GNAT.Serial_Communications;

  Error : EXCEPTION;

  -- Type definitions

  TYPE DeviceClass IS TAGGED PRIVATE;
  TYPE Device      IS ACCESS ALL DeviceClass'Class;

  -- Device object constructor

  FUNCTION Create
   (portname : Serial.Port_Name;
    baudrate : Serial.Data_Rate := Serial.B115200) RETURN Device;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceClass;
    portname : Serial.Port_Name;
    baudrate : Serial.Data_Rate := Serial.B115200);

  -- Send AT command string to WIO-E5

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String);

  -- Get response string from WIO-E5

  FUNCTION GetResponse(Self : DeviceClass) RETURN String;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String; resp : String);

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand (Self : DeviceClass; cmd : String; resp : GNAT.Regpat.Pattern_Matcher);

PRIVATE

  TYPE SerialPortAccess IS ACCESS Serial.Serial_Port;

  TYPE DeviceClass IS TAGGED RECORD
    port : SerialPortAccess := NULL;
  END RECORD;

END WIO_E5;

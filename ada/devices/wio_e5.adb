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

WITH Ada.Streams;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;

PACKAGE BODY WIO_E5 IS

  -- Device object constructor

  FUNCTION Create
   (portname : Serial.Port_Name;
    baudrate : Serial.Data_Rate := Serial.B115200) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, portname, baudrate);
    RETURN NEW DeviceClass'(dev);
  END Create;

  -- Device instance initializer

  PROCEDURE Initialize
   (Self     : OUT DeviceClass;
    portname : Serial.Port_Name;
    baudrate : Serial.Data_Rate := Serial.B115200) IS

  BEGIN
    Self.port := NEW Serial.Serial_Port;
    Serial.Open(Self.port.ALL, portname);
    Serial.Set(Self.port.ALL, Rate => baudrate, Block => False, Timeout => 0.2);
  END Initialize;

  -- Send AT command string to WIO-E5

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String) IS

  BEGIN
    String'Write(Self.port, cmd & ASCII.CR & ASCII.LF);
  END SendCommand;

  -- Get response string from WIO-E5

  FUNCTION GetResponse(Self : DeviceClass) RETURN String IS

    inbuf : Ada.Streams.Stream_Element_Array(1 .. 1024) := (OTHERS => 0);
    count : Ada.Streams.Stream_Element_Offset;

  BEGIN
    Self.port.Read(inbuf, count);

    DECLARE

      resp : String(1 .. Natural(count));

    BEGIN
      FOR i IN 1 .. count LOOP
        resp(Positive(i)) := Character'Val(inbuf(i));
      END LOOP;

      RETURN Ada.Strings.Fixed.Trim(resp, Ada.Strings.Maps.Constants.Control_Set,
        Ada.Strings.Maps.Constants.Control_Set);
    END;
  END GetResponse;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand(Self : DeviceClass; cmd : String; resp : String) IS

  BEGIN
    String'Write(Self.port, cmd & ASCII.CR & ASCII.LF);

    IF Self.GetResponse /= resp THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendCommand;

  -- Send AT command string to WIO-E5 expecting a response string

  PROCEDURE SendCommand
   (Self     : DeviceClass;
    cmd      : String;
    resp     : GNAT.Regpat.Pattern_Matcher) IS

  BEGIN
    String'Write(Self.port, cmd & ASCII.CR & ASCII.LF);

    IF NOT GNAT.Regpat.Match(resp, Self.GetResponse) THEN
      RAISE Error WITH "Unexpected response string";
    END IF;
  END SendCommand;

END WIO_E5;

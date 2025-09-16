-- Linux Hardware Monitoring Subsystem Temperature Sensor Services

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

WITH Ada.Directories;
WITH Ada.Integer_Text_IO;
WITH Ada.Strings.Fixed;

PACKAGE BODY Temperature.libsimpleio.HWMon IS

  PACKAGE str RENAMES Ada.Strings;

  FUNCTION Trim(Source : String; Side : str.Trim_End := str.Both)
    RETURN String RENAMES str.Fixed.Trim;

  -- Temperature sensor object constructor (by Designator)

  FUNCTION Create(desg : Device.Designator) RETURN Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Temperature sensor object instance initializer (by Designator)

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator) IS

    filename : String := "/sys/class/hwmon/hwmon" & Trim(desg.chip'Image) &
      "/temp" & Trim(desg.chan'Image) & "_input";

  BEGIN
    Self.Destroy;

    Self.intemp := NEW Ada.Text_IO.File_Type;
    Ada.Text_IO.Open(Self.intemp.ALL, Ada.Text_IO.In_File, filename);
  END Initialize;

  -- Temperature sensor object constructor (by name and channel)

  FUNCTION Create(name : String; channel : Natural := 1) RETURN Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(name, channel);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Temperature sensor object instance initializer (by name and channel)

  PROCEDURE Initialize
   (Self    : IN OUT InputSubclass;
    name    : String;
    channel : Natural := 1) IS

  BEGIN
    FOR i IN Natural RANGE 0 .. 99 LOOP
      DECLARE
        dirname  : String := "/sys/class/hwmon/hwmon" & Trim(i'Image);
        namename : String := dirname & "/name";
        dataname : String := dirname & "/temp" & Trim(channel'Image) & "_input";
        namefile : Ada.Text_IO.File_Type;
      BEGIN
        EXIT WHEN NOT Ada.Directories.Exists(dirname);

        Ada.Text_IO.Open(namefile, Ada.Text_IO.In_File, namename);

        DECLARE
          candidate : String := Ada.Text_IO.Get_Line(namefile);
        BEGIN
          Ada.Text_IO.Close(namefile);

          IF candidate = name THEN
            Self.intemp := NEW Ada.Text_IO.File_Type;
            Ada.Text_IO.Open(Self.intemp.ALL, Ada.Text_IO.In_File, dataname);
            RETURN;
          END IF;
        END;
      END;
    END LOOP;

    RAISE Temperature_Error WITH "Cannot find matching hwmon sensor";
  END Initialize;

  -- Temperature sensor object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Ada.Text_IO.Close(Self.intemp.ALL);

    Self := Destroyed;
  END Destroy;

  -- Temperature sensor read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Celsius IS

    sample : Integer;

  BEGIN
    Self.CheckDestroyed;

    Ada.Text_IO.Reset(Self.intemp.ALL);
    Ada.Integer_Text_IO.Get(Self.intemp.ALL, sample);

    RETURN Celsius(sample)/1000.0;
  END Get;

  -- Check whether temperature sensor has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Temperature_Error WITH "Temperature sensor has been destroyed";
    END IF;
  END CheckDestroyed;

END Temperature.libsimpleio.HWMon;

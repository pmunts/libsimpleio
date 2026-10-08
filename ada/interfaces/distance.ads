-- Distance in meters measurement definitions

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

PACKAGE Distance IS

  TYPE meters      IS NEW Long_Float;
  TYPE millimeters IS NEW Long_Float;
  TYPE centimeters IS NEW Long_Float;
  TYPE kilometers  IS NEW Long_Float;

  TYPE mils        IS NEW Long_Float;
  TYPE inches      IS NEW Long_Float;
  TYPE feet        IS NEW Long_Float;
  TYPE yards       IS NEW Long_Float;
  TYPE miles       IS NEW Long_Float;  -- Statute

  -- Instantiate text I/O packages

  PACKAGE meters_IO      IS NEW Ada.Text_IO.Float_IO(meters);
  PACKAGE millimeters_IO IS NEW Ada.Text_IO.Float_IO(millimeters);
  PACKAGE centimeters_IO IS NEW Ada.Text_IO.Float_IO(centimeters);
  PACKAGE kilometers_IO  IS NEW Ada.Text_IO.Float_IO(kilometers);
  PACKAGE mils_IO        IS NEW Ada.Text_IO.Float_IO(mils);
  PACKAGE inches_IO      IS NEW Ada.Text_IO.Float_IO(inches);
  PACKAGE feet_IO        IS NEW Ada.Text_IO.Float_IO(feet);
  PACKAGE yards_IO       IS NEW Ada.Text_IO.Float_IO(yards);
  PACKAGE miles_IO       IS NEW Ada.Text_IO.Float_IO(miles);

  -- Instantiate abstract interfaces package

  PACKAGE Interfaces IS NEW IO_Interfaces(meters);

  -- Define an abstract interface for distance sensor inputs, derived from
  -- Interfaces.InputInterface

  TYPE InputInterface IS INTERFACE AND Interfaces.InputInterface;

  -- Define an access type compatible with any subclass implementing
  -- InputInterface

  TYPE Input IS ACCESS ALL InputInterface'Class;

  -- Metric conversions

  FUNCTION ToMillimeters(d : meters) RETURN millimeters IS (millimeters(d*1000.0));
  FUNCTION ToCentimeters(d : meters) RETURN centimeters IS (centimeters(d*100.0));
  FUNCTION ToKilometers (d : meters) RETURN kilometers  IS (kilometers (d/1000.0));
  FUNCTION ToMeters(d : millimeters) RETURN meters      IS (meters(d/1000.0));
  FUNCTION ToMeters(d : centimeters) RETURN meters      IS (meters(d/100.0));
  FUNCTION ToMeters(d : kilometers)  RETURN meters      IS (meters(d*1000.0));

  -- The following 8 significant digit conversion factors were extracted from
  -- the CRC Handbook of Chemistry and Physics, 60th Edition, pages F-321 and
  -- F-322.

  FUNCTION ToMils  (d : meters) RETURN mils   IS (mils  (d*39370.079));
  FUNCTION ToInches(d : meters) RETURN inches IS (inches(d*39.370079));
  FUNCTION ToFeet  (d : meters) RETURN feet   IS (feet  (d*3.2808399));
  FUNCTION ToYards (d : meters) RETURN yards  IS (yards (d*1.0936133));
  FUNCTION ToMiles (d : meters) RETURN miles  IS (miles (d/1609.344));
  FUNCTION ToMeters(d : mils)   RETURN meters IS (meters(d/39370.079));
  FUNCTION ToMeters(d : inches) RETURN meters IS (meters(d/39.370079));
  FUNCTION ToMeters(d : feet)   RETURN meters IS (meters(d/3.2808399));
  FUNCTION ToMeters(d : yards)  RETURN meters IS (meters(d/1.0936133));
  FUNCTION ToMeters(d : miles)  RETURN meters IS (meters(d*1609.344));

END Distance;

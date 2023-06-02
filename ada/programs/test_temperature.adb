-- Temperature Interface Test

-- Copyright (C)2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Temperature; USE Temperature;

PROCEDURE test_temperature IS

BEGIN
  New_Line;
  Put_Line("Temperature Interface Test");
  New_Line;

  Celsius_IO.Put(AbsoluteZero,  4, 3, 0); Put_Line(" C");
  Celsius_IO.Put(FreezingPoint, 4, 3, 0); Put_Line(" C");
  Celsius_IO.Put(BoilingPoint,  4, 3, 0); Put_Line(" C");
  New_Line;

  Kelvins_IO.Put(To_Kelvins(AbsoluteZero),  4, 3, 0); Put_Line(" K");
  Kelvins_IO.Put(To_Kelvins(FreezingPoint), 4, 3, 0); Put_Line(" K");
  Kelvins_IO.Put(To_Kelvins(BoilingPoint),  4, 3, 0); Put_Line(" K");
  New_Line;

  Fahrenheit_IO.Put(To_Fahrenheit(AbsoluteZero),  4, 3, 0); Put_Line(" F");
  Fahrenheit_IO.Put(To_Fahrenheit(FreezingPoint), 4, 3, 0); Put_Line(" F");
  Fahrenheit_IO.Put(To_Fahrenheit(BoilingPoint),  4, 3, 0); Put_Line(" F");
  New_Line;
END test_temperature;

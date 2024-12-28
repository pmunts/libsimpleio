-- Orange Pi Zero 2W SPI Output Test

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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Device;
WITH SPI.libsimpleio;
WITH OrangePiZero2W; USE OrangePiZero2W;

PROCEDURE test_spi IS

  SPISlaves : CONSTANT ARRAY (Natural RANGE <>) OF Device.Designator :=
   (SPI0_0, SPI0_1);

  num      : Natural;
  desg     : Device.Designator;
  mode     : Natural;
  wordsize : Natural;
  speed    : Natural;
  slave    : SPI.Device;
  outbuf   : CONSTANT SPI.Command(0 .. 31) := (OTHERS => 16#AA#);

BEGIN
  New_Line;
  Put_Line("Orange Pi Zero 2W SPI Output Test");
  New_Line;

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 4 THEN
    Put_Line("Usage: test_spi <slave> <mode> <wordsize> <speed>");
    New_Line;
    RETURN;
  END IF;

  -- Convert command line parameters

  num      := Natural'Value(Ada.Command_Line.Argument(1));
  mode     := Natural'Value(Ada.Command_Line.Argument(2));
  wordsize := Natural'Value(Ada.Command_Line.Argument(3));
  speed    := Natural'Value(Ada.Command_Line.Argument(4));

  -- Create the SPI slave device

  desg  := SPISlaves(num);
  slave := SPI.libsimpleio.Create(desg, mode, wordsize, speed);

  -- Write to the SPI slave device

  LOOP
    slave.Write(outbuf, outbuf'Length);
  END LOOP;
END test_spi;

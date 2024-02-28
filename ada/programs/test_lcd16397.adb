-- Sparkfun LCD-16397 16x2 Display Test

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH I2C.libsimpleio;
WITH RaspberryPi;
WITH LCD16397;

PROCEDURE test_lcd16397 IS

  bus : I2C.Bus;
  dev : LCD16397.Device;

BEGIN
  New_Line;
  Put_Line("Sparkfun LCD-16397 16x2 Display Test");
  New_Line;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);
  dev := LCD16397.Create(bus);

  -- Display something

  LOOP
    FOR row IN REVERSE LCD16397.RowNumber'Range LOOP
      FOR col IN REVERSE LCD16397.ColumnNumber'Range LOOP
        dev.Move(row, col);
        dev.Put('*');
      END LOOP;
    END LOOP;

    dev.Clear;
  END LOOP;
END test_lcd16397;

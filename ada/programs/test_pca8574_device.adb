-- Test an PCA8574 I2C GPIO expander as an 8-bit parallel port

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH I2C;
WITH I2C.libsimpleio;
WITH PCA8574;

PROCEDURE test_pca8574_device IS

  bus    : I2C.Bus;
  dev    : PCA8574.Device;

BEGIN
  New_Line;
  Put_Line("PCA8574 Byte I/O Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 2 THEN
    Put_Line("Usage: test_pca8574_device <bus> <addr>");
    New_Line;
    RETURN;
  END IF;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(Ada.Command_Line.Argument(1));

  -- Create PCA8574 device object

  dev := PCA8574.Create(bus, I2C.Address'Value(Ada.Command_Line.Argument(2)));

  -- Write increasing values to the PCA8574

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    FOR b IN PCA8574.Byte'Range LOOP
      dev.Put(b);
    END LOOP;
  END LOOP;
END test_pca8574_device;

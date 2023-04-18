-- HP9872A HP-GL Digitize Test

-- Copyright (C)2023, Philip Munts.
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

WITH GPIB.Slave;
WITH Prologix_GPIB_USB;

PROCEDURE test_hp9872a_digitize IS

  TYPE StatusByte IS MOD 256;

  DataAvailable : CONSTANT StatusByte := 16#04#;

  bus    : GPIB.Controller;
  dev    : GPIB.Slave.Device;
  status : StatusByte;

BEGIN
  New_Line;
  Put_Line("HP9872A HP-GL Digitize Test");
  New_Line;

  bus := Prologix_GPIB_USB.Create("/dev/ttyUSB0");
  dev := GPIB.Slave.Create(bus, 5);

  dev.Put("IN;");
  DELAY 10.0; -- Wait for plotter to settle

  LOOP
    dev.Put("DP;");

    Put("Press ENTER to capture a point: ");

    LOOP
      dev.Put("OS;");
      status := StatusByte'Value(dev.Get);
      EXIT WHEN (status AND DataAvailable) /= 0;
    END LOOP;

    dev.Put("OD;");
    Put_Line(dev.Get);
  END LOOP;

  dev.Put("IN;");
END test_hp9872a_digitize;

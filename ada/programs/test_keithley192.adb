-- Keithley 192 Programmable DMM Test

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

WITH Keithley192;
WITH Prologix_GPIB_USB;

PROCEDURE test_keithley192 IS

  dev : Keithley192.Device;

BEGIN
  New_Line;
  Put_Line("Keithley 192 Programmable DMM Test");
  New_Line;

  dev.Initialize(Prologix_GPIB_USB.Create("/dev/ttyUSB0"),
    Keithley192.DefaultAddress);

  dev.Clear;
  DELAY 1.0;

  dev.Configure(Keithley192.ConfigDCVolts);

  LOOP
    BEGIN
      DELAY 1.0;
      Put_Line(Float'Image(dev.Get));
    EXCEPTION
      WHEN Keithley192.OutOfRange => Put_Line("Input is out of range");
    END;
  END LOOP;
END test_keithley192;

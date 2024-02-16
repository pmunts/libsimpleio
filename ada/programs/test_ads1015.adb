-- ADS1015 A/D Converter Test

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

WITH ADS1015;
WITH Analog;
WITH Device;
WITH I2C.libsimpleio;

PROCEDURE test_ads1015 IS

  desg  : Device.Designator;
  bus   : I2C.Bus;
  addr  : I2C.Address;
  input : Analog.Input;

BEGIN
  New_Line;
  Put_Line("ADS1015 A/D Converter Test");
  New_Line;

  -- Get I2C bus designator

  desg := Device.GetDesignator(0, "Enter I2C bus");
  addr := I2C.GetAddress("Enter I2C dev address: ");

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(desg);

  -- Create ADS1015 input object

  input := ADS1015.Create(bus, addr, ADS1015.AIN0, ADS1015.FSR4096);

  -- Display analog samples

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Sample:");
    Analog.Sample_IO.Put(input.Get, 5);
    New_Line;

    DELAY 1.0;
  END LOOP;
END test_ads1015;

-- Change the Grove TB6612 Motor Driver I2C address

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

WITH Device;
WITH Grove_TB6612;
WITH I2C.libsimpleio;

PROCEDURE test_grove_tb6612_set_address IS

  desg    : Device.Designator;
  oldaddr : I2C.Address;
  newaddr : I2C.Address;
  bus     : I2C.Bus;
  dev     : Grove_TB6612.Device;

BEGIN
  New_Line;
  Put_Line("Grove TB6612 Set I2C Address");
  New_Line;

  desg    := Device.GetDesignator("Enter I2C bus: ");
  oldaddr := I2C.GetAddress("Enter old I2C address: ");
  newaddr := I2C.GetAddress("Enter new I2C address: ");

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(desg);

  -- Create Grove TB6612 device object

  dev := Grove_TB6612.Create(bus, oldaddr);

  -- Change the I2C address

  dev.ChangeAddress(newaddr);
END test_grove_tb6612_set_address;

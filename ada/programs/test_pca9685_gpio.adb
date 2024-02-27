-- Test a PCA9685 as 16 individual GPIO pins

-- Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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
WITH GPIO;
WITH I2C.libsimpleio;
WITH PCA9685.GPIO;

PROCEDURE test_pca9685_gpio IS

  desg : Device.Designator;
  addr : I2C.Address;
  bus  : I2C.Bus;
  dev  : PCA9685.Device;
  pins : ARRAY (PCA9685.ChannelNumber) OF GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("PCA9685 GPIO Toggle Test");
  New_Line;

  desg := Device.GetDesignator(0, "Enter I2C bus: ");
  addr := I2C.GetAddress("Enter I2C dev address: ");
  New_Line;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(desg);

  -- Create PCA9685 device object

  dev := PCA9685.Create(bus, addr, 6103);

  -- Configure GPIO pins

  FOR n IN pins'Range LOOP
    pins(n) := PCA9685.GPIO.Create(dev, n);
  END LOOP;

  -- Toggle GPIO outputs

  Put_Line("Toggle GPIO outputs...");

  LOOP
    FOR p OF pins LOOP
      p.Put(NOT p.Get);
    END LOOP;
  END LOOP;
END test_pca9685_gpio;

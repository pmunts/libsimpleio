-- PCA9534 I2C GPIO expander device services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY PCA9534 IS

  -- PCA9534 device object constructor

  FUNCTION Create
   (bus      : NOT NULL I2C.Bus;
    addr     : I2C.Address;
    config   : Byte := AllInputs;
    states   : Byte := AllOff) RETURN Device IS

    dev : Device;

  BEGIN
    dev := NEW DeviceClass'(bus, addr, AllInputs, AllOff);

    dev.Put(ConfigurationReg, config);
    dev.Put(InputPolarityReg, AllNormal);
    dev.Put(OutputPortReg, states);

    RETURN dev;
  END Create;

  -- Read from a PCA9534 register

  FUNCTION Get
   (Self : IN OUT DeviceClass;
    addr : RegisterAddress) RETURN Byte IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(addr);
    Self.bus.Transaction(Self.addr, cmd, cmd'Length, resp, resp'Length);
    RETURN Byte(resp(0));
  END Get;

  -- Write to a PCA9534 register

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    addr : RegisterAddress;
    data : Byte) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    IF addr = InputPortReg THEN
      RAISE PCA9534_Error WITH "ERROR: Cannot write to input port register";
    END IF;

    cmd(0) := I2C.Byte(addr);
    cmd(1) := I2C.Byte(data);

    Self.bus.Write(Self.addr, cmd, cmd'Length);

    IF addr = ConfigurationReg THEN
      Self.config := data;
    ELSIF addr = OutputPortReg THEN
      Self.latch := data;
    END IF;
  END Put;

  -- Read from the PCA9534 input port register

  FUNCTION Get
   (Self : IN OUT DeviceClass) RETURN Byte IS

  BEGIN
    RETURN Self.Get(InputPortReg);
  END Get;

  -- Write to the PCA9534 output port register

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    data : Byte) IS

  BEGIN
    Self.Put(OutputPortReg, data);
  END Put;

END PCA9534;

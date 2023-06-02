-- Modbus LED Test

-- Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

WITH GPIO;
WITH Modbus.Coils;

PROCEDURE test_modbus_led IS

  port    : String(1 .. 256);
  portlen : Natural;
  slave   : Natural;
  addr    : Natural;
  bus     : ModBus.Bus;
  LED     : GPIO.Pin;

  PACKAGE Natural_IO IS NEW Ada.Text_IO.Integer_IO(Natural); USE Natural_IO;

BEGIN
  New_Line;
  Put_Line("Modbus LED Test");
  New_Line;

  Put("Enter serial port:   ");
  Get_Line(port, portlen);

  Put("Enter slave address: ");
  Get(slave);

  Put("Enter coil number:   ");
  Get(addr);

  bus := Modbus.Create(port(1 .. portlen));
  LED := Modbus.Coils.Create(bus, slave, addr);

  New_Line;
  Put_Line("Press CONTROL-C to stop program.");

  LOOP
    LED.Put(NOT LED.Get);
    DELAY 0.5;
  END LOOP;
END test_modbus_led;

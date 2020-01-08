-- Modbus GPIO Toggle Test

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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
WITH Modbus.GPIO;

PROCEDURE test_gpio_modbus IS

  port    : String(1 .. 256);
  portlen : Natural;
  slave   : Natural;
  coil    : Natural;
  period  : Duration;
  bus     : ModBus.Bus;
  gpio0   : GPIO.Pin;

  PACKAGE Natural_IO IS NEW Ada.Text_IO.Integer_IO(Natural); USE Natural_IO;
  PACKAGE Duration_IO IS NEW Ada.Text_IO.Fixed_IO(Duration); USE Duration_IO;

BEGIN
  New_Line;
  Put_Line("Modbus GPIO Toggle Test");
  New_Line;

  Put("Enter serial port:   ");
  Get_Line(port, portlen);

  Put("Enter slave address: ");
  Get(slave);

  Put("Enter coil number:   ");
  Get(coil);

  Put("Period in seconds:   ");
  Get(period);

  bus   := Modbus.Create(port(1 .. portlen));
  gpio0 := Modbus.GPIO.Create(bus, slave, Modbus.GPIO.Coil, coil);

  New_Line;
  Put_Line("Press CONTROL-C to stop program.");

  LOOP
    gpio0.Put(NOT gpio0.Get);
    DELAY period;
  END LOOP;
END test_gpio_modbus;

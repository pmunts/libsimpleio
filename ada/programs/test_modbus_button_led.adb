-- Modbus Button and LED Test

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

-- NOTE: The button input has the internal pullup resistor enabled, so the
-- switch should be connected from GPIO0 to ground.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;
WITH Modbus.Coils;
WITH Modbus.DiscreteInputs;

PROCEDURE test_modbus_button_led IS

  port     : String(1 .. 256);
  portlen  : Natural;
  slave    : Natural;
  input    : Natural;
  coil     : Natural;
  bus      : ModBus.Bus;
  Button   : GPIO.Pin;
  LED      : GPIO.Pin;
  newstate : Boolean;
  oldstate : Boolean;

  PACKAGE Natural_IO IS NEW Ada.Text_IO.Integer_IO(Natural); USE Natural_IO;

BEGIN
  New_Line;
  Put_Line("Modbus Button and LED Test");
  New_Line;

  Put("Enter serial port:                      ");
  Get_Line(port, portlen);

  Put("Enter slave address:                    ");
  Get(slave);

  Put("Enter discrete input number for button: ");
  Get(input);

  Put("Enter coil number for LED:              ");
  Get(coil);

  New_Line;

  -- Configure button and LED GPIO's

  bus    := Modbus.Create(port(1 .. portlen));
  Button := Modbus.DiscreteInputs.Create(bus, slave, input);
  LED    := Modbus.Coils.Create(bus, slave, coil);

  -- Force initial detection

  oldstate := NOT Button.Get;

  LOOP
    newstate := Button.Get;

    IF newstate /= oldstate THEN
      IF newstate THEN
        Put_Line("PRESSED");
        LED.Put(True);
      ELSE
        Put_Line("RELEASED");
        LED.Put(False);
      END IF;

      oldstate := newstate;
    END IF;
  END LOOP;
END test_modbus_button_led;

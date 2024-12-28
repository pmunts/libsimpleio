-- Orange Pi Zero 2W GPIO Output Toggle Test

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
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH Device;
WITH GPIO.libsimpleio;
WITH OrangePiZero2W.RaspberryPi; USE OrangePiZero2W.RaspberryPi;

PROCEDURE test_gpio IS

  GPIOPins : CONSTANT ARRAY (Natural RANGE <>) OF Device.Designator :=
   (GPIO0,  GPIO1,  GPIO2,  GPIO3,  GPIO4,  GPIO5,  GPIO6,  GPIO7,
    GPIO8,  GPIO9,  GPIO10, GPIO11, GPIO12, GPIO13, GPIO14, GPIO15,
    GPIO16, GPIO17, GPIO18, GPIO19, GPIO20, GPIO21, GPIO22, GPIO23,
    GPIO24, GPIO25, GPIO26, GPIO27);

  num  : Natural;
  desg : Device.Designator;
  outp : GPIO.Pin;

BEGIN
  Put_Line("Orange Pi Zero 2W GPIO Output Toggle Test");
  New_Line;

  Put("Enter Raspberry Pi GPIO pin number (0 to 27): ");
  Get(num);

  -- Create GPIO output object

  desg := GPIOPins(num);
  outp := GPIO.libsimpleio.Create(desg, GPIO.Output);

  -- Toggle the GPIO output

  LOOP
    outp.Put(NOT outp.Get);
  END LOOP;
END test_gpio;

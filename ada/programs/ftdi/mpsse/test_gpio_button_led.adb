-- FTDI MPSSE GPIO Button and LED Test

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH FTDI.MPSSE.GPIO;
WITH GPIO;

PROCEDURE test_gpio_button_led IS

  dev      : FTDI.Device;
  name     : FTDI.MPSSE.GPIO.PinName;
  Button   : GPIO.Pin;
  LED      : GPIO.Pin;
  newstate : Boolean;
  oldstate : Boolean;

  PACKAGE PinNameIO IS NEW Enumeration_IO(FTDI.MPSSE.GPIO.PinName);

BEGIN
  New_Line;
  Put_Line("FTDI MPSSE GPIO Button and LED Test");
  New_Line;

  -- Create an FTDI device object

  dev := FTDI.MPSSE.Create(16#0403#, 16#6014#);

  -- Configure button and LED GPIO's

  Put("Enter button input GPIO pin name (D0-7, C0-7): ");
  PinNameIO.Get(name);
  New_Line;
  
  Button := FTDI.MPSSE.GPIO.Create(dev, name, GPIO.Input);

  Put("Enter LED output GPIO pin name (D0-7, C0-7):   ");
  PinNameIO.Get(name);
  New_Line;
  
  LED := FTDI.MPSSE.GPIO.Create(dev, name, GPIO.Output);

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
END test_gpio_button_led;

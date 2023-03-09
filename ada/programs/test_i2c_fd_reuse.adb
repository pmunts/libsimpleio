-- I2C Bus file descriptor reuse test

-- Copyright (C)2023, Philip Munts.
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

WITH I2C.libsimpleio;
WITH RaspberryPi;

PROCEDURE test_i2c_fd_reuse IS

  Iterations : CONSTANT Natural := 100;

  bus1  : I2C.libsimpleio.BusSubclass;
  bus2  : I2C.libsimpleio.BusSubclass;
  buses : ARRAY (1 .. Iterations) OF I2C.libsimpleio.BusSubclass;

BEGIN
  New_Line;
  Put_Line("I2C Bus file descriptor reuse test");
  New_Line;

  Put_Line("Initializing I2C1 bus object one time");

  bus1.Initialize(RaspberryPi.I2C1);
  bus2 := bus1;

  Put_Line("Initializing I2C1 bus object" & Natural'Image(Iterations) & " more times");

  FOR i IN Natural RANGE 1 .. Iterations LOOP
    buses(i).Initialize(RaspberryPi.I2C1);

    IF bus1.fd /= buses(i).fd THEN
      Put_Line("ERROR: fd mismatch: Expected =>" & Natural'Image(bus1.fd) &
        "  Got =>" & Natural'Image(buses(i).fd));
    END IF;
  END LOOP;

  Put_Line("Destroying I2C1 bus object" & Natural'Image(Iterations) & " times");

  FOR i IN Natural RANGE 1 .. Iterations LOOP
    buses(i).Destroy;
  END LOOP;

  Put_Line("Destroying I2C1 bus object one more time");

  bus1.Destroy;

  Put_Line("Attempting to destroy I2C1 bus object one time too many");

  bus2.Destroy; -- This should raise an exception
END test_i2c_fd_reuse;

-- Raspberry Pi LPC1114 I/O Processor Expansion Board LEGO Power Functions
-- Remote Control output test

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Integer_Text_IO;
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Interfaces;

WITH errno;
WITH libspiagent;
WITH GPIO.libspiagent;
WITH Motor;
WITH MOTOR.LEGORC;
WITH Motor.LEGORC.libspiagent;

USE TYPE Interfaces.Integer_32;

PROCEDURE test_libspiagent_legorc IS

  error  : Interfaces.Integer_32;
  motors : ARRAY (1 .. 2) OF Motor.Interfaces.Output;
  index  : Natural RANGE 0 .. 2;
  velo   : Motor.Velocity;

BEGIN
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board LEGO RC Test");
  New_Line;

  -- Open libspiagent

  libspiagent.Open(libspiagent.Localhost, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "spiagent_open() failed, " &
      errno.strerror(Integer(error));
  END IF;

  -- Configure two motor outputs

  motors(1) := Motor.LEGORC.libspiagent.Create(GPIO.libspiagent.GPIO7, 1,
    Motor.LEGORC.MotorA);

  motors(2) := Motor.LEGORC.libspiagent.Create(GPIO.libspiagent.GPIO7, 1,
    Motor.LEGORC.MotorB);

  LOOP
    Put("Enter motor index (1 or 2):          ");
    Ada.Integer_Text_IO.Get(index);

    EXIT WHEN index = 0;

    Put("Enter motor velocity (-1.0 to +1.0): ");
    Motor.Velocity_IO.Get(velo);

    motors(index).Put(velo);
  END LOOP;
END test_libspiagent_legorc;

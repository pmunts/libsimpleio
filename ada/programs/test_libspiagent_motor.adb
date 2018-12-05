-- Raspberry Pi LPC1114 I/O Processor Expansion Board motor output test

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
WITH PWM.libspiagent;
WITH Motor.PWM;

USE TYPE Interfaces.Integer_32;

PROCEDURE test_libspiagent_motor IS

  PulseFrequency : CONSTANT := 100; -- Hertz

  error  : Interfaces.Integer_32;
  motors : ARRAY (1 .. 2) OF Motor.Interfaces.Output;
  index  : Natural RANGE 0 .. 2;
  velo   : Motor.Velocity;

BEGIN
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board Motor Output Test");
  New_Line;

  -- Open libspiagent

  libspiagent.Open(libspiagent.Localhost, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "spiagent_open() failed, " &
      errno.strerror(Integer(error));
  END IF;

  -- Configure the PWM pulse frequency

  PWM.libspiagent.SetFrequency(PulseFrequency);

  -- Configure two motor outputs

  motors(1) := Motor.PWM.Create(PWM.libspiagent.Create(PWM.libspiagent.PWM1),
    GPIO.libspiagent.Create(GPIO.libspiagent.GPIO0, GPIO.Output));

  motors(2) := Motor.PWM.Create(PWM.libspiagent.Create(PWM.libspiagent.PWM2),
    GPIO.libspiagent.Create(GPIO.libspiagent.GPIO3, GPIO.Output));

  LOOP
    Put("Enter motor index (1 or 2):          ");
    Ada.Integer_Text_IO.Get(index);

    EXIT WHEN index = 0;

    Put("Enter motor velocity (-1.0 to +1.0): ");
    Motor.Velocity_IO.Get(velo);

    motors(index).Put(velo);
  END LOOP;
END test_libspiagent_motor;

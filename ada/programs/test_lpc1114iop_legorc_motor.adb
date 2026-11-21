-- Raspberry Pi LPC1114 I/O Processor LEGO® RC Motor Test

-- Copyright (C)2026, Philip Munts, President, Munts AM Corp.
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

WITH LPC1114IOP.LEGORC;
WITH LPC1114IOP.Pins;
WITH LPC1114IOP.Transport;
WITH Motor;

PROCEDURE test_lpc1114iop_legorc_motor IS

  VELOCITIES : CONSTANT Integer := 8;

  outp : Motor.Output;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor LEGO® RC Motor Test");
  New_Line;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Open("localhost" & ASCII.NUL);

  -- Initialize an IRED driver output

  LPC1114IOP.LEGORC.Initialize(LPC1114IOP.Pins.LPC1114_GPIO7);

  -- Create motor driver output object instance

  outp := LPC1114IOP.LEGORC.Create(LPC1114IOP.Pins.LPC1114_GPIO7, 1,
    LPC1114IOP.LEGORC.MotorA);

  -- Sweep the motor velocity up and down

  FOR v IN Integer RANGE 1 .. VELOCITIES - 1 LOOP
    outp.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 1.0;
  END LOOP;

  FOR v IN REVERSE Integer RANGE -VELOCITIES + 1 .. VELOCITIES - 2 LOOP
    outp.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 1.0;
  END LOOP;

  FOR v IN Integer RANGE -VELOCITIES + 2 .. 0 LOOP
    outp.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 1.0;
  END LOOP;

  -- Deinitialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_legorc_motor;

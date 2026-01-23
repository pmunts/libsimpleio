-- Test an RPV (Remotely Piloted Vehicle aka RC car)

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

-- Device Under Test:
--
-- New Bright Boing Nitro RC car with radio receiver removed
-- Raspberry Pi 1 Model A+
-- Grove TB6612 I2C Motor Driver

WITH Grove_TB6612.Motor;
WITH I2C.libsimpleio;
WITH Motor;
WITH RaspberryPi;
WITH ncurses.Keys;

USE TYPE Motor.Velocity;

PROCEDURE test_grove_tb6612_car IS

  -- This RC car has solenoids for steering rather than a servo, so there are
  -- only 3 distinct steering wheel positions, selected by +6V, +0V, and -6V
  -- to the steering solenoids.

  TYPE SteeringDirections IS (Left, Straight, Right);

  SteeringVelocities : CONSTANT ARRAY (SteeringDirections) OF Motor.Velocity :=
   (-1.0, 0.0, 1.0);

  bus           : I2C.Bus;
  dev           : Grove_TB6612.Device;

  SteeringWheel : Motor.Output;
  GasPedal      : Motor.Output;

  gas           : Motor.Velocity := 0.0;

  PROCEDURE ChangeSteering(dir : SteeringDirections) IS

  BEGIN
    SteeringWheel.Put(SteeringVelocities(dir));
    ncurses.mvprintw(4, 10, dir'Image & "    " & ASCII.Nul);
  END ChangeSteering;

  PROCEDURE ChangeThrottle(DeltaV : Motor.Velocity) IS

    outbuf : String(1 .. 5);

  BEGIN
    IF Float(gas) + Float(DeltaV) >  1.0 OR
       Float(gas) + Float(DeltaV) < -1.0 THEN
      RETURN;
    END IF;

    gas := gas + DeltaV;
    GasPedal.Put(gas);

    Motor.Velocity_IO.Put(outbuf, gas, 2, 0);
    ncurses.mvprintw(5, 10, outbuf & ASCII.Nul);
  END ChangeThrottle;

BEGIN
  ncurses.initscr;
  ncurses.raw;
  ncurses.noecho;
  ncurses.keypad(ncurses.stdscr, True);
  ncurses.timeout(0);

  ncurses.clear;
  ncurses.mvprintw(0, 0, "Grove TB6612 Remotely Piloted Vehicle Test" & ASCII.Nul);
  ncurses.mvprintw(2, 0, "Press CONTROL-C to quit" & ASCII.Nul);
  ncurses.mvprintw(4, 0, "Steering:" & ASCII.Nul);
  ncurses.mvprintw(5, 0, "Throttle:" & ASCII.Nul);
  ncurses.refresh;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);

  -- Create Grove TB6612 device object

  dev := Grove_TB6612.Create(bus);

  -- Create motor output objects

  SteeringWheel := Grove_TB6612.Motor.Create(dev, Grove_TB6612.Motor.ChannelA);
  GasPedal      := Grove_TB6612.Motor.Create(dev, Grove_TB6612.Motor.ChannelB);

  LOOP
    CASE ncurses.getch IS
      WHEN ncurses.Keys.KEY_CONTROL_C | Character'Pos('1') =>
        EXIT;

      WHEN Character'Pos('7') =>
        ChangeSteering(Straight);
        ChangeThrottle(-gas);

      WHEN Character'Pos('4') =>
        ChangeSteering(Left);

      WHEN Character'Pos('5') =>
        ChangeSteering(Straight);

      WHEN Character'Pos('6') =>
        ChangeSteering(Right);

      WHEN Character'Pos('8') =>
        ChangeThrottle(0.01);

      WHEN Character'Pos('2') =>
        ChangeThrottle(-0.01);

      WHEN Character'Pos('9') =>
        ChangeThrottle(0.1);

      WHEN Character'Pos('3') =>
        ChangeThrottle(-0.1);

      WHEN OTHERS =>
        NULL;
    END CASE;
  END LOOP;

  ncurses.endwin;
END test_grove_tb6612_car;

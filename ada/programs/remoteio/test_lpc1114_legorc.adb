-- LPC1114 I/O Processor LEGO Power Functions Remote Control Test

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

WITH LEGORC;
WITH Motor.LEGORC;
WITH RemoteIO.Client.hidapi;
WITH RemoteIO.LPC1114.LEGORC;

USE type Motor.LEGORC.Speed;

PROCEDURE test_lpc1114_legorc IS

  remdev : RemoteIO.Client.Device;
  absdev : RemoteIO.LPC1114.Abstract_Device.Device;
  ired   : LEGORC.Output;
  motors : ARRAY (Motor.LEGORC.MotorID) OF Motor.Output;

BEGIN
  New_Line;
  Put_Line("LPC1114 I/O Processor LEGO Power Functions Remote Control Test");
  New_Line;

  remdev := RemoteIO.Client.hidapi.Create;
  absdev := RemoteIO.LPC1114.Abstract_Device.Create(remdev, 0);
  ired   := RemoteIO.LPC1114.LEGORC.Create(absdev, RemoteIO.LPC1114.LPC1114_GPIO0);

  motors :=
   (Motor.LEGORC.Create(ired, 1, Motor.LEGORC.MotorA),
    Motor.LEGORC.Create(ired, 1, Motor.LEGORC.MotorB));

  LOOP
    FOR M OF motors LOOP
      FOR s IN Motor.LEGORC.Speed RANGE 1 .. 7 LOOP
        M.put(Motor.LEGORC.SpeedToVelocity(s));
        DELAY 1.0;
      END LOOP;

      FOR s IN REVERSE Motor.LEGORC.Speed RANGE -7 .. 6 LOOP
        M.put(Motor.LEGORC.SpeedToVelocity(s));
        DELAY 1.0;
      END LOOP;

      FOR s IN Motor.LEGORC.Speed RANGE -6 .. 0 LOOP
        M.put(Motor.LEGORC.SpeedToVelocity(s));
        DELAY 1.0;
      END LOOP;
    END LOOP;
  END LOOP;

END test_lpc1114_legorc;

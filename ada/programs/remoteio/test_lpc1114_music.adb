-- LPC1114 I/O Processor Musical Scale Test

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
WITH Interfaces;

WITH RemoteIO.Client.hidapi;
WITH RemoteIO.LPC1114.Timers;

USE TYPE Interfaces.Unsigned_32;

PROCEDURE test_lpc1114_music IS

  octaves : CONSTANT Natural := 9;

  TYPE Scale IS NEW Natural RANGE 1 .. 12*octaves;

  remdev  : RemoteIO.Client.Device;
  absdev  : RemoteIO.LPC1114.Abstract_Device.Device;
  CT32B1  : RemoteIO.LPC1114.Timers.Timer;
  freq    : Float := 16.35;

BEGIN
  New_Line;
  Put_Line("LPC1114 I/O Processor Musical Scale Test");
  New_Line;

  remdev := RemoteIO.Client.hidapi.Create;
  absdev := RemoteIO.LPC1114.Abstract_Device.Create(remdev, 0);
  CT32B1 := RemoteIO.LPC1114.Timers.Create(absdev,
    RemoteIO.LPC1114.LPC1114_CT32B1);

  -- Configure CT32B1 for square wave output

  CT32B1.Configure_Prescaler(1);

  CT32B1.Configure_Match_Action(RemoteIO.LPC1114.LPC1114_TIMER_MATCH1,
    RemoteIO.LPC1114.LPC1114_TIMER_MATCH_OUTPUT_TOGGLE, True, False);
  
  CT32B1.Configure_Mode(RemoteIO.LPC1114.LPC1114_TIMER_MODE_PCLK);

  -- Play scale from C0 to B8

  FOR i IN Scale LOOP
    CT32B1.Configure_Match_Value(RemoteIO.LPC1114.LPC1114_TIMER_MATCH1,
      RemoteIO.LPC1114.LPC1114_PCLK/Interfaces.Unsigned_32(freq)/2);
  
    DELAY 0.5;

    freq := freq*1.0595;  -- Equal tempered scale
  END LOOP;

  CT32B1.Reset;
END test_lpc1114_music;

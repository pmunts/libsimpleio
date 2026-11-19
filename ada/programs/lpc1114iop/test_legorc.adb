-- Raspberry Pi LPC1114 I/O Processor Ada PWM test program

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;

WITH LPC1114IOP.LEGORC;      USE LPC1114IOP.LEGORC;
WITH LPC1114IOP.Pins;        USE LPC1114IOP.Pins;
WITH LPC1114IOP.Transport;

PROCEDURE test_legorc IS

  servername : Unbounded_String;
  channel    : legorc_channel_t;
  motor      : legorc_motor_t;
  direction  : legorc_direction_t;
  speed      : legorc_speed_t;
  error      : Integer;
  IRED       : LEGORC;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor LEGO® RC Test");
  New_Line;

  -- Analyze command line parameters

  IF Argument_Count = 4 THEN
    servername := To_Unbounded_String("localhost");
    channel := legorc_channel_t'VALUE(Argument(1));
    motor := legorc_motor_t'VAL(Integer'VALUE(Argument(2)));
    direction := legorc_direction_t'VAL(Integer'VALUE(Argument(3)));
    speed := legorc_speed_t'VALUE(Argument(4));
  ELSIF Argument_Count = 5 THEN
    servername := To_Unbounded_String(Argument(1));
    channel := legorc_channel_t'VALUE(Argument(2));
    motor := legorc_motor_t'VAL(Integer'VALUE(Argument(3)));
    direction := legorc_direction_t'VAL(Integer'VALUE(Argument(4)));
    speed := legorc_speed_t'VALUE(Argument(5));
  ELSE
    Put_Line("Usage: " & Command_Name & " [hostname] <channel:1-4> <motor:0-2> <forward:0-1> <speed:0-7>");
    RETURN;
  END IF;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.open(To_String(servername) & ASCII.NUL, error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.SpiAgentError WITH
      "LPC1114IOP.Transport.open() failed, error:" & Integer'IMAGE(error);
  END IF;

  -- Configure the GPIO output pin

  IRED := Create(LPC1114_GPIO7);

  -- Send the command

  IRED.Put(channel, motor, direction, speed);

  -- Deinitialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.close(error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.SpiAgentError WITH
      "LPC1114IOP.Transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_legorc;

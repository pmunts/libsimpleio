-- Raspberry Pi LPC1114 I/O Processor Ada servo test program

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

WITH Servo;
WITH LPC1114IOP.Pins;
WITH LPC1114IOP.PWM;
WITH LPC1114IOP.Transport;

PROCEDURE test_lpc1114iop_servo IS

  servername : Unbounded_String;
  Outputs    : ARRAY (LPC1114IOP.Pins.PWM_PINS'Range) OF Servo.Output;
  Channel    : Integer;
  Position   : Servo.Position;

  PACKAGE Channel_IO  IS NEW Integer_IO(Integer);
  PACKAGE Position_IO IS NEW Float_IO(Servo.Position);

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Servo Output Test");
  New_Line;

  -- Analyze command line parameters

  IF Argument_Count = 0 THEN
    servername := To_Unbounded_String("localhost");
  ELSIF Argument_Count = 1 THEN
    servername := To_Unbounded_String(Argument(1));
  ELSE
    Put_Line("Usage: " & Command_Name & " [hostname]");
    RETURN;
  END IF;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Open(To_String(servername) & ASCII.NUL);

  -- Configure servo outputs

  FOR i IN Outputs'Range LOOP
    Outputs(i) := LPC1114IOP.PWM.Create(LPC1114IOP.Pins.PWM_PINS(i));
  END LOOP;

  -- Set servo positions

  Mainloop : LOOP
    Put("Enter servo channel number (1-4):      ");
    Channel_IO.Get(Channel, 0);

    IF Channel = 0 THEN
      EXIT Mainloop;
    ELSIF Channel >= 1 AND Channel <= 4 THEN
      Put("Enter servo position (-1.0 to +1.0): ");
      Position_IO.Get(Position, 0);
      Outputs(Channel).Put(Position);
    END IF;
  END LOOP Mainloop;

  -- Deinitialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_servo;

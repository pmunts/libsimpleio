-- Mikroelektronika mikroBUS PWM Output Test

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH PWM.libsimpleio;
WITH ClickBoard.SimpleIO;

PROCEDURE test_mikrobus_pwm IS

  socknum : Positive;
  socket  : ClickBoard.SimpleIO.Socket;
  outp    : PWM.Interfaces.Output;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika mikroBUS PWM Output Test");
  New_Line;

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 2 THEN
    Put_Line("Usage: test_mikrobus_pwm <sock num> <freq>");
    New_Line;
    RETURN;
  END IF;

  -- Configure the selected PWM output

  socknum := Positive'Value(Ada.Command_Line.Argument(1));
  socket  := ClickBoard.SimpleIO.Create(socknum);
  outp    := PWM.libsimpleio.Create(socket.PWM,
    Positive'Value(Ada.Command_Line.Argument(2)));

  -- Sweep PWM output duty cycle back and forth

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    FOR d IN Natural RANGE 0 .. 1000 LOOP
      outp.Put(PWM.DutyCycle(Float(d)/10.0));
      DELAY 0.005;
    END LOOP;

    FOR d IN Natural RANGE 0 .. 1000 LOOP
      outp.Put(PWM.DutyCycle(Float(1000 - d)/10.0));
      DELAY 0.005;
    END LOOP;
  END LOOP;
END test_mikrobus_pwm;

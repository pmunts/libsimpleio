-- Serial Port Receive Test

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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
WITH Ada.Streams;
WITH GNAT.Serial_Communications;

PROCEDURE test_serial_gnat_receive IS

  port  : GNAT.Serial_Communications.Serial_Port;
  inbuf : Ada.Streams.Stream_Element_Array(0 .. 0);
  last  : Ada.Streams.Stream_Element_Offset;

BEGIN
  New_Line;
  Put_Line("Serial Port Receive Test");
  New_Line;

  -- Customize the parameters to Open and Set as necessary for a particular
  -- test run.

  GNAT.Serial_Communications.Open(port, "/dev/ttyS0");
  GNAT.Serial_Communications.Set(port,
    Rate      => GNAT.Serial_Communications.B115200,
    Parity    => GNAT.Serial_Communications.None,
    Bits      => GNAT.Serial_Communications.CS8,
    Stop_Bits => GNAT.Serial_Communications.One);

  LOOP
    GNAT.Serial_Communications.Read(port, inbuf, last);
    Put_Line(Ada.Streams.Stream_Element'Image(inbuf(0)));
  END LOOP;
END test_serial_gnat_receive;

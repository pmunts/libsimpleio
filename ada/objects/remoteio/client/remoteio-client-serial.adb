-- Copyright (C)2021-2023, Philip Munts.
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

WITH GNAT.Serial_Communications;
WITH RemoteIO.Client.Stream;

PACKAGE BODY RemoteIO.Client.Serial IS

  FUNCTION Create
   (portname : String;
    baudrate : Natural := 115200;
    timeout  : Natural := 1000) RETURN Device IS

    PRAGMA Warnings(Off, "use of an anonymous access type allocator");

    port : CONSTANT ACCESS GNAT.Serial_Communications.Serial_Port :=
      NEW GNAT.Serial_Communications.Serial_Port;

    baud : GNAT.Serial_Communications.Data_Rate;

  BEGIN

    -- Convert baud rate

    CASE baudrate IS
      WHEN 75      => baud := GNAT.Serial_Communications.B75;
      WHEN 110     => baud := GNAT.Serial_Communications.B110;
      WHEN 150     => baud := GNAT.Serial_Communications.B150;
      WHEN 300     => baud := GNAT.Serial_Communications.B300;
      WHEN 600     => baud := GNAT.Serial_Communications.B600;
      WHEN 1200    => baud := GNAT.Serial_Communications.B1200;
      WHEN 2400    => baud := GNAT.Serial_Communications.B2400;
      WHEN 4800    => baud := GNAT.Serial_Communications.B4800;
      WHEN 9600    => baud := GNAT.Serial_Communications.B9600;
      WHEN 19200   => baud := GNAT.Serial_Communications.B19200;
      WHEN 38400   => baud := GNAT.Serial_Communications.B38400;
      WHEN 57600   => baud := GNAT.Serial_Communications.B57600;
      WHEN 115200  => baud := GNAT.Serial_Communications.B115200;
--    WHEN 230400  => baud := GNAT.Serial_Communications.B230400;
--    WHEN 460800  => baud := GNAT.Serial_Communications.B460800;
--    WHEN 500000  => baud := GNAT.Serial_Communications.B500000;
--    WHEN 576000  => baud := GNAT.Serial_Communications.B576000;
--    WHEN 921600  => baud := GNAT.Serial_Communications.B921600;
--    WHEN 1000000 => baud := GNAT.Serial_Communications.B1000000;
--    WHEN 1152000 => baud := GNAT.Serial_Communications.B1152000;
--    WHEN 1500000 => baud := GNAT.Serial_Communications.B1500000;
--    WHEN 2000000 => baud := GNAT.Serial_Communications.B2000000;
--    WHEN 2500000 => baud := GNAT.Serial_Communications.B2500000;
--    WHEN 3000000 => baud := GNAT.Serial_Communications.B3000000;
--    WHEN 3500000 => baud := GNAT.Serial_Communications.B3500000;
--    WHEN 4000000 => baud := GNAT.Serial_Communications.B4000000;

      WHEN OTHERS => RAISE GNAT.Serial_Communications.Serial_Error WITH
        "Unsupported baud rate";
    END CASE;

    GNAT.Serial_Communications.Open(port.ALL,
      GNAT.Serial_Communications.Port_Name(portname));

    GNAT.Serial_Communications.Set(port.ALL, baud,
      Timeout => Duration(timeout)/1000.0);

    RETURN RemoteIO.Client.Stream.Create(port.ALL'Access);
  END Create;

END RemoteIO.Client.Serial;

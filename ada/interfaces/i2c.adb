-- Abstract interface for I2C bus controllers

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

PACKAGE BODY I2C IS

  PACKAGE ByteIO IS NEW Ada.Text_IO.Modular_IO(Byte);

  -- Dump a command buffer in hexadecimal format

  PROCEDURE Dump
   (cmd     : Command;
    cmdlen  : Natural := Natural'Last) IS

    buf   : String(1 .. 6);
    count : Natural := cmdlen;

  BEGIN
    FOR b OF cmd LOOP
      EXIT WHEN count = 0;

      ByteIO.Put(buf, b, 16);

      IF buf(1) = ' ' THEN
        Ada.Strings.Fixed.Insert(buf, 5, "0", Ada.Strings.Left);
      END IF;

      Ada.Strings.Fixed.Replace_Slice(buf, 6, 6, " ");
      Ada.Strings.Fixed.Replace_Slice(buf, 1, 3, " ");

      Put(Ada.Strings.Fixed.Trim(buf, Ada.Strings.Both));
      Put(" ");

      count := count - 1;
    END LOOP;

    New_Line;
  END Dump;

  -- Dump a response buffer in hexadecimal format

  PROCEDURE Dump
   (resp    : Response;
    resplen : Natural := Natural'Last) IS

    buf   : String(1 .. 6);
    count : Natural := resplen;

  BEGIN
    FOR b OF resp LOOP
      EXIT WHEN count = 0;

      ByteIO.Put(buf, b, 16);

      IF buf(1) = ' ' THEN
        Ada.Strings.Fixed.Insert(buf, 5, "0", Ada.Strings.Left);
      END IF;

      Ada.Strings.Fixed.Replace_Slice(buf, 6, 6, " ");
      Ada.Strings.Fixed.Replace_Slice(buf, 1, 3, " ");

      Put(Ada.Strings.Fixed.Trim(buf, Ada.Strings.Both));
      Put(" ");

      count := count - 1;
    END LOOP;

    New_Line;
  END Dump;

END I2C;

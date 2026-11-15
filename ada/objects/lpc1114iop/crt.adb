-- Ada screen I/O support for ANSI terminals, inspired by the
-- Turbo Pascal CRT unit

-- Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY CRT IS

  PACKAGE int_io IS NEW Integer_IO(Integer);
  USE int_io;

  PROCEDURE ClrEol IS

  BEGIN
    Put(ASCII.ESC & "[K");
  END ClrEol;

  PROCEDURE ClrScr IS

  BEGIN
    Put(ASCII.ESC & "[2J");
  END ClrScr;

  PROCEDURE GotoXY(x : Integer; y : Integer) IS

  BEGIN
    Put(ASCII.ESC & "[");
    Put(y, 0, 10);
    Put(";");
    Put(x, 0, 10);
    Put("H");
  END GotoXY;

  FUNCTION KeyPressed RETURN Boolean IS

    ch    : Character;
    avail : Boolean;

  BEGIN
    Get_Immediate(ch, avail);
    RETURN avail;
  END KeyPressed;

END CRT;

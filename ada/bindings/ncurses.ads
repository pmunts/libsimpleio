-- Minimal Ada wrapper for GNU ncurses

-- Copyright (C)2020-2023, Philip Munts, President, Munts AM Corp.
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

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH System;

PACKAGE ncurses IS
  PRAGMA Link_With("-lncurses");
  PRAGMA Warnings(Off, """keypad.enable"" is an 8-bit Ada Boolean");

  -- Constants

  stdscr  : CONSTANT System.Address;
    PRAGMA Import(C, stdscr);

  Columns : CONSTANT Integer;
    PRAGMA Import(C, Columns, "COLS");

  Rows    : CONSTANT Integer;
    PRAGMA Import(C, Rows, "LINES");

  -- Subprograms

  PROCEDURE cbreak;
    PRAGMA Import(C, cbreak);

  PROCEDURE clear;
    PRAGMA Import(C, clear);

  PROCEDURE clrtobot;
    PRAGMA Import(C, clrtobot);

  PROCEDURE clrtoeol;
    PRAGMA Import(C, clrtoeol);

  PROCEDURE erase;
    PRAGMA Import(C, erase);

  PROCEDURE endwin;
    PRAGMA Import(C, endwin);

  FUNCTION getch RETURN Integer;
    PRAGMA Import(C, getch);

  PROCEDURE initscr;
    PRAGMA Import(C, initscr);

  PROCEDURE keypad
   (window : System.Address;
    enable : Boolean);
    PRAGMA Import(C, keypad);

  PROCEDURE move
   (row : Integer;
    col : Integer);
    PRAGMA Import(C, move);

  PROCEDURE mvprintw
   (row : Integer;
    col : Integer;
    s   : String);
    PRAGMA Import(C, mvprintw);

  PROCEDURE noecho;
    PRAGMA Import(C, noecho);

  PROCEDURE raw;
    PRAGMA Import(C, raw);

  PROCEDURE refresh;
    PRAGMA Import(C, refresh);

  PROCEDURE timeout(t : Integer);
    PRAGMA Import(C, timeout);

END ncurses;

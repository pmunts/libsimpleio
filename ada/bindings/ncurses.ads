-- Minimal Ada wrapper for GNU ncurses

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

WITH System;

PACKAGE ncurses IS
  PRAGMA Link_With("-lncurses");

  -- Constants

  stdscr  : CONSTANT System.Address;
    PRAGMA Import(C, stdscr);

  Columns : CONSTANT Integer;
    PRAGMA Import(C, Columns, "COLS");

  Rows    : CONSTANT Integer;
    PRAGMA Import(C, Rows, "LINES");

  -- Key codes

  KEY_CONTROL_A : CONSTANT Integer := 1;
  KEY_CONTROL_B : CONSTANT Integer := 2;
  KEY_CONTROL_C : CONSTANT Integer := 3;
  KEY_CONTROL_D : CONSTANT Integer := 4;
  KEY_CONTROL_E : CONSTANT Integer := 5;
  KEY_CONTROL_F : CONSTANT Integer := 6;
  KEY_CONTROL_G : CONSTANT Integer := 7;
  KEY_CONTROL_H : CONSTANT Integer := 8;
  KEY_CONTROL_I : CONSTANT Integer := 9;
  KEY_CONTROL_J : CONSTANT Integer := 10;
  KEY_CONTROL_K : CONSTANT Integer := 11;
  KEY_CONTROL_L : CONSTANT Integer := 12;
  KEY_CONTROL_M : CONSTANT Integer := 13;
  KEY_CONTROL_N : CONSTANT Integer := 14;
  KEY_CONTROL_O : CONSTANT Integer := 15;
  KEY_CONTROL_P : CONSTANT Integer := 16;
  KEY_CONTROL_Q : CONSTANT Integer := 17;
  KEY_CONTROL_R : CONSTANT Integer := 18;
  KEY_CONTROL_S : CONSTANT Integer := 19;
  KEY_CONTROL_T : CONSTANT Integer := 20;
  KEY_CONTROL_U : CONSTANT Integer := 21;
  KEY_CONTROL_V : CONSTANT Integer := 22;
  KEY_CONTROL_W : CONSTANT Integer := 23;
  KEY_CONTROL_X : CONSTANT Integer := 24;
  KEY_CONTROL_Y : CONSTANT Integer := 25;
  KEY_CONTROL_Z : CONSTANT Integer := 26;

  KEY_BACKSPACE	: CONSTANT Integer := 8#0407#;
  KEY_DELETE    : CONSTANT Integer := 8#0512#;
  KEY_ESC       : CONSTANT Integer := 27;
  KEY_INSERT    : CONSTANT Integer := 8#0513#;
  KEY_TAB       : CONSTANT Integer := 9;

  KEY_UP	: CONSTANT Integer := 8#0403#;
  KEY_DOWN	: CONSTANT Integer := 8#0402#;
  KEY_LEFT	: CONSTANT Integer := 8#0404#;
  KEY_RIGHT	: CONSTANT Integer := 8#0405#;
  KEY_HOME	: CONSTANT Integer := 8#0406#;
  KEY_END       : CONSTANT Integer := 8#0550#;
  KEY_PAGEUP    : CONSTANT Integer := 8#0523#;
  KEY_PAGEDOWN  : CONSTANT Integer := 8#0522#;

  KEY_F1	: CONSTANT Integer := 8#0411#;
  KEY_F2	: CONSTANT Integer := 8#0412#;
  KEY_F3	: CONSTANT Integer := 8#0413#;
  KEY_F4	: CONSTANT Integer := 8#0414#;
  KEY_F5	: CONSTANT Integer := 8#0415#;
  KEY_F6	: CONSTANT Integer := 8#0416#;
  KEY_F7	: CONSTANT Integer := 8#0417#;
  KEY_F8	: CONSTANT Integer := 8#0420#;
  KEY_F9	: CONSTANT Integer := 8#0421#;
  KEY_F10	: CONSTANT Integer := 8#0422#;
  KEY_F11	: CONSTANT Integer := 8#0423#;
  KEY_F12	: CONSTANT Integer := 8#0424#;

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

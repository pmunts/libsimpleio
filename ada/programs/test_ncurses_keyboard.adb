-- Test GNU ncurses keypress handling

-- Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

WITH ncurses;
WITH ncurses.Keys;

PROCEDURE test_ncurses_keyboard IS

  c : Integer;
  n : Positive := 1;

BEGIN
  ncurses.initscr;
  ncurses.raw;
  ncurses.noecho;
  ncurses.keypad(ncurses.stdscr, True);
  ncurses.timeout(0);
  ncurses.clear;

  ncurses.mvprintw(0, 0, "ncurses Library Test" & ASCII.NUL);
  ncurses.mvprintw(ncurses.rows - 1, 0, "Press CONTROL-C to quit" & ASCII.NUL);
  ncurses.refresh;

  LOOP
    c := ncurses.getch;

    CASE c IS
      WHEN -1 =>
        NULL;

      WHEN ncurses.Keys.KEY_CONTROL_C =>
        EXIT;

      WHEN OTHERS =>
        ncurses.move(2, 0);
        ncurses.clrtoeol;
        ncurses.mvprintw(2, 0, "You pressed " & ncurses.Keys.Name(c) & ASCII.NUL);
    END CASE;

    ncurses.mvprintw(10, 0, Positive'Image(n) & ASCII.NUL);
    ncurses.refresh;
    n := n + 1;
  END LOOP;

  ncurses.endwin;
END test_ncurses_keyboard;

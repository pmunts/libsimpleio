-- GNU ncurses keyboard key codes

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

WITH Ada.Strings.Fixed;

PACKAGE BODY ncurses.Keys IS

  FUNCTION Trim(s : String) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Trim(s, Ada.Strings.Both);
  END Trim;

  FUNCTION Name(c : Integer) RETURN String IS

  BEGIN
    IF c < 0 THEN
      RAISE Error WITH "Invalid key code";
    END IF;

    CASE c IS
      -- Control character keys
      WHEN 1       => RETURN "CONTROL_A";
      WHEN 2       => RETURN "CONTROL_B";
      WHEN 3       => RETURN "CONTROL_C";
      WHEN 4       => RETURN "CONTROL_D";
      WHEN 5       => RETURN "CONTROL_E";
      WHEN 6       => RETURN "CONTROL_F";
      WHEN 7       => RETURN "CONTROL_G";
      WHEN 8       => RETURN "CONTROL_H";
      WHEN 9       => RETURN "CONTROL_I";
      WHEN 10      => RETURN "CONTROL_J";
      WHEN 11      => RETURN "CONTROL_K";
      WHEN 12      => RETURN "CONTROL_L";
      WHEN 13      => RETURN "CONTROL_M";
      WHEN 14      => RETURN "CONTROL_N";
      WHEN 15      => RETURN "CONTROL_O";
      WHEN 16      => RETURN "CONTROL_P";
      WHEN 17      => RETURN "CONTROL_Q";
      WHEN 18      => RETURN "CONTROL_R";
      WHEN 19      => RETURN "CONTROL_S";
      WHEN 20      => RETURN "CONTROL_T";
      WHEN 21      => RETURN "CONTROL_U";
      WHEN 22      => RETURN "CONTROL_V";
      WHEN 23      => RETURN "CONTROL_W";
      WHEN 24      => RETURN "CONTROL_X";
      WHEN 25      => RETURN "CONTROL_Y";
      WHEN 26      => RETURN "CONTROL_Z";
      WHEN 27      => RETURN "ESC";

      -- Printable character keys
      WHEN 32 .. 126 | 160 .. 255 => RETURN Character'Val(c) & "";

      -- Other keys
      WHEN 8#0402# => RETURN "DOWN";
      WHEN 8#0403# => RETURN "UP";
      WHEN 8#0404# => RETURN "LEFT";
      WHEN 8#0405# => RETURN "RIGHT";
      WHEN 8#0406# => RETURN "HOME";
      WHEN 8#0407# => RETURN "BACKSPACE";
      WHEN 8#0411# => RETURN "F1";
      WHEN 8#0412# => RETURN "F2";
      WHEN 8#0413# => RETURN "F3";
      WHEN 8#0414# => RETURN "F4";
      WHEN 8#0415# => RETURN "F5";
      WHEN 8#0416# => RETURN "F6";
      WHEN 8#0417# => RETURN "F7";
      WHEN 8#0420# => RETURN "F8";
      WHEN 8#0421# => RETURN "F9";
      WHEN 8#0422# => RETURN "F10";
      WHEN 8#0423# => RETURN "F11";
      WHEN 8#0424# => RETURN "F12";
      WHEN 8#0512# => RETURN "DELETE";
      WHEN 8#0513# => RETURN "INSERT";
      WHEN 8#0522# => RETURN "PAGEDOWN";
      WHEN 8#0523# => RETURN "PAGEUP";
      WHEN 8#0550# => RETURN "END";

      -- Everything else
      WHEN OTHERS  => RETURN Trim(Integer'Image(c));
    END CASE;
  END Name;

END ncurses.Keys;

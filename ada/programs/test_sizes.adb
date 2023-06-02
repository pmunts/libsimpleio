-- Primitive Datatype Size Test

-- Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
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
WITH System;

PROCEDURE test_sizes IS

  a : CONSTANT Boolean          := True;
  b : CONSTANT Character        := ' ';
  c : CONSTANT Integer          := 0;
  d : CONSTANT Natural          := 0;
  e : CONSTANT ACCESS Character := NULL;

BEGIN
  New_Line;
  Put_Line("Primitive Datatype Size Test");
  New_Line;

  Put_Line("Boolean:             " & Natural'Image(a'Size));
  Put_Line("Character:           " & Natural'Image(b'Size));
  Put_Line("Integer:             " & Natural'Image(c'Size));
  Put_Line("Natural:             " & Natural'Image(d'Size));
  Put_Line("ACCESS:              " & Natural'Image(e'Size));
  Put_Line("System.Address:      " & Natural'Image(System.Address'Size));
  Put_Line("System.Storage_Unit: " & Natural'Image(System.Storage_Unit));
  Put_Line("System.Word_Size:    " & Natural'Image(System.Word_Size));
END test_sizes;

(* Useful byte array services *)

(* Copyright (C)2024, Philip Munts dba Munts Technologies.                     *)
(*                                                                             *)
(* Redistribution and use in source and binary forms, with or without          *)
(* modification, are permitted provided that the following conditions are met: *)
(*                                                                             *)
(* * Redistributions of source code must retain the above copyright notice,    *)
(*   this list of conditions and the following disclaimer.                     *)
(*                                                                             *)
(* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" *)
(* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   *)
(* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  *)
(* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   *)
(* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         *)
(* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        *)
(* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    *)
(* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     *)
(* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     *)
(* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  *)
(* POSSIBILITY OF SUCH DAMAGE.                                                 *)

IMPLEMENTATION MODULE ByteArray;

  FROM STextIO IMPORT WriteChar;
  FROM SYSTEM  IMPORT BYTE;

  PROCEDURE Fill
   (dst   : ARRAY OF BYTE;
    value : BYTE;
    count : CARDINAL);

  VAR
    i : CARDINAL;

  BEGIN
    FOR i := 0 TO count - 1 DO
      dst[i] := value;
    END;
  END Fill;

  PROCEDURE HexDump
   (src   : ARRAY OF BYTE;
    count : CARDINAL);

  VAR
    hexchars : ARRAY [0 .. 16] OF CHAR;
    i        : CARDINAL;

  BEGIN
    hexchars := "0123456789ABCDEF";

    FOR i := 0 TO count - 1 DO
      WriteChar(hexchars[VAL(CARDINAL, src[i]) DIV 16]);
      WriteChar(hexchars[VAL(CARDINAL, src[i]) MOD 16]);
      WriteChar(' ');
    END;
  END HexDump;

END ByteArray.


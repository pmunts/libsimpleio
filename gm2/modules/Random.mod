(* Minimal Standard Random Number Generator, from CACM October 1988 *)

(* Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  *)
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

IMPLEMENTATION MODULE Random;

  PROCEDURE rand(VAR seed : INTEGER) : REAL;

  CONST
    a = 16807;
    m = 2147483647;
    q = 127773;
    r = 2836;

  VAR
    lo   : INTEGER;
    hi   : INTEGER;
    test : INTEGER;

  BEGIN
    hi := seed DIV q;
    lo := seed MOD q;

    test := a*lo - r*hi;

    IF test > 0 THEN
      seed := test
    ELSE
      seed := test + m;
    END;

    RETURN FLOAT(seed)/FLOAT(m);
  END rand;

END Random.

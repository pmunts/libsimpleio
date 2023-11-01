(* Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                *)
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

IMPLEMENTATION MODULE ErrorHandling;

  FROM STextIO IMPORT WriteString, WriteLn;
  FROM FIO IMPORT FlushOutErr;
  FROM errno IMPORT strerror;

  PROCEDURE CheckCondition
   (condition : BOOLEAN;
    message   : ARRAY OF CHAR;
    [disp : Disposition = Abort]);

  BEGIN
    IF (disp <> Ignore) AND condition THEN
      WriteString("ERROR: ");
      WriteString(message);
      WriteLn;
      WriteLn;
      FlushOutErr;

      IF disp = Abort THEN
        HALT(1);
      END;
    END;
  END CheckCondition;

  PROCEDURE CheckError
   (error     : CARDINAL;
    message   : ARRAY OF CHAR;
    [disp : Disposition = Abort]);

  VAR
    errnomsg : ARRAY [0 .. 255] OF CHAR;

  BEGIN
    IF (disp <> Ignore) AND (error <> 0) THEN
      strerror(error, errnomsg, 256);

      WriteString("ERROR: ");
      WriteString(message);
      WriteString(", ");
      WriteString(errnomsg);
      WriteLn;
      WriteLn;
      FlushOutErr;

      IF disp = Abort THEN
        HALT(1);
      END;
    END;
  END CheckError;

END ErrorHandling.

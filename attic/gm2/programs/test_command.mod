(* Linux Shell Command Test *)

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

MODULE test_command;

FROM Args IMPORT Narg, GetArg;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;

FROM liblinux IMPORT Command;

VAR
  success : BOOLEAN;
  cmd     : ARRAY [0 .. 255] OF CHAR;
  status  : CARDINAL;
  error   : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Linux Shell Command Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Show usage *)

  IF Narg() <> 2 THEN
    WriteString("Usage: test_command <command string>");
    WriteLn;
    WriteLn;
    FlushOutErr;
    HALT(1);
  END;

  (* Extract command string from the command line *)

  success := GetArg(cmd, 1);

  (* Execute the command string *)

  Command(cmd, status, error);
  WriteLn;
  FlushOutErr;

  (* Display results *)

  WriteString("status => ");
  WriteCard(status, 0);
  WriteString(" error => ");
  WriteCard(error, 0);
  WriteLn;
  FlushOutErr;
END test_command.

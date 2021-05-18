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

MODULE test_ipv4_resolve;

FROM Args IMPORT Narg, GetArg;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT WriteString, WriteLn;
FROM ErrorHandling IMPORT CheckError;
FROM libipv4 IMPORT IPV4_resolve, IPV4_ntoa;

VAR
  success  : BOOLEAN;
  hostname : ARRAY [0 .. 255] OF CHAR;
  hostaddr : CARDINAL;
  hoststr  : ARRAY [0 .. 31] OF CHAR;
  error    : CARDINAL;

BEGIN
  WriteLn;
  WriteString("IPv4 Address Resolution Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  IF Narg() <> 2 THEN
    WriteString("Usage: test_ipv4 <host>");
    WriteLn;
    WriteLn;
    FlushOutErr;
    HALT(1);
  END;

  success := GetArg(hostname, 1);

  (* Resolve the host name to IP address *)

  IPV4_resolve(hostname, hostaddr, error);
  CheckError(error, "IPV4_resolve() failed");

  IPV4_ntoa(hostaddr, hoststr, 32, error);
  CheckError(error, "IPV4_ntoa() failed");

  WriteString("The Internet address of ");
  WriteString(hostname);
  WriteString(" is ");
  WriteString(hoststr);
  WriteLn;
  WriteLn;
  FlushOutErr;
END test_ipv4_resolve.

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

MODULE test_tcp4_accept;

IMPORT
  CharClass,
  Strings,
  errno;

FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM ErrorHandling IMPORT CheckError;
FROM libipv4 IMPORT INADDR_ANY, TCP4_accept, TCP4_send, TCP4_receive, TCP4_close;

VAR
  fd    : INTEGER;
  error : CARDINAL;
  buf   : ARRAY [0 .. 255] OF CHAR;
  count : CARDINAL;

BEGIN
  WriteLn;
  WriteString("TCP/IP Accept Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Wait for an incoming TCP connection request *)

  TCP4_accept(INADDR_ANY, 12345, fd, error);
  CheckError(error, "TCP4_accept() failed");

  WriteString("Client connected.");
  WriteLn;
  FlushOutErr;

  (* Message processing loop *)

  LOOP
    TCP4_receive(fd, buf, 254, count, error);

    (* Check for client disconnect *)

    IF error = errno.ECONNRESET THEN
      EXIT;
    END;

    CheckError(error, "TCP4_receive() failed");

    IF count = 0 THEN
      EXIT;
    END;

    (* Guarantee NUL termination *)

    buf[count] := CHR(0);

    (* Strip trailing whitespace *)

    WHILE (count > 0) AND CharClass.IsWhiteSpace(buf[count-1]) DO
      buf[count-1] := CHR(0);
      DEC(count);
    END;

    (* Display what we received *)

    WriteString("Received ");
    WriteCard(count, 0);
    WriteString(" bytes -- ");
    WriteString(buf);
    WriteLn;
    FlushOutErr;

    (* Check for QUIT command *)

    Strings.Capitalize(buf);

    IF Strings.Equal(buf, "QUIT") THEN
      EXIT;
    END;
  END;

  (* Close the connection *)

  TCP4_close(fd, error);
  CheckError(error, "TCP4_close() failed");
END test_tcp4_accept.

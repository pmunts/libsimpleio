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

MODULE test_tcp4_client;

IMPORT
  errno,
  libipv4;

FROM Args IMPORT Narg, GetArg;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT ReadString, SkipLine, WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM ErrorHandling IMPORT CheckError;

VAR
  success  : BOOLEAN;
  hostname : ARRAY [0 .. 255] OF CHAR;
  hostaddr : CARDINAL;
  buf      : ARRAY [0 .. 255] OF CHAR;
  fd       : INTEGER;
  count    : CARDINAL;
  error    : CARDINAL;

BEGIN
  WriteLn;
  WriteString("TCP4 Client Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  IF Narg() <> 2 THEN
    WriteString("Usage: test_tcp4_client <host>");
    WriteLn;
    WriteLn;
    FlushOutErr;
    HALT(1);
  END;

  success := GetArg(hostname, 1);

  (* Resolve the host name to IP address *)

  libipv4.IPV4_resolve(hostname, hostaddr, error);
  CheckError(error, "IPV4_resolve() failed");

  (* Open TCP stream *)

  libipv4.TCP4_connect(hostaddr, 12345, fd, error);
  CheckError(error, "TCP4_open() failed");

  (* Exchange messages with the server *)

  LOOP
    WriteString("Enter some text: ");
    FlushOutErr;
    ReadString(buf);
    SkipLine;

    IF LENGTH(buf) > 0 THEN
      libipv4.TCP4_send(fd, buf, LENGTH(buf), count, error);

      IF (error = errno.ECONNRESET) OR (error = errno.EPIPE) THEN
        EXIT;
      END;

      CheckError(error, "TCP4_send() failed");
    END;
  END;

  (* Close TCP stream *)

  libipv4.TCP4_close(fd, error);
  CheckError(error, "TCP4_close() failed");
END test_tcp4_client.

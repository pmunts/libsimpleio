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

MODULE test_udp4_client;

IMPORT
  libipv4;

FROM Args IMPORT Narg, GetArg;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM ErrorHandling IMPORT CheckError;

VAR
  success  : BOOLEAN;
  hostname : ARRAY [0 .. 255] OF CHAR;
  hostaddr : CARDINAL;
  hostport : CARDINAL;
  buf      : ARRAY [0 .. 255] OF CHAR;
  fd       : INTEGER;
  count    : CARDINAL;
  error    : CARDINAL;

BEGIN
  WriteLn;
  WriteString("UDP Initiator Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  IF Narg() <> 2 THEN
    WriteString("Usage: test_udp4_client <host>");
    WriteLn;
    WriteLn;
    FlushOutErr;
    HALT(1);
  END;

  success := GetArg(hostname, 1);

  (* Resolve the host name to IP address *)

  libipv4.IPV4_resolve(hostname, hostaddr, error);
  CheckError(error, "IPV4_resolve() failed");

  (* Open UDP socket *)

  libipv4.UDP4_open(libipv4.INADDR_ANY, 0, fd, error);
  CheckError(error, "UDP4_open() failed");

  (* Send a UDP datagram *)

  libipv4.UDP4_send(fd, hostaddr, 12345, "HELLO", 5, 0, count, error);
  CheckError(error, "UDP4_send() failed");

  (* Receive a UDP datagram *)

  libipv4.UDP4_receive(fd, hostaddr, hostport, buf, HIGH(buf), 0, count, error);
  CheckError(error, "UDP4_receive() failed");

  (* Guarantee NUL termination *)

  buf[count] := CHR(0);

  libipv4.IPV4_ntoa(hostaddr, hostname, HIGH(hostname), error);
  CheckError(error, "IPV4_ntoa() failed");

  (* Display the response *)

  WriteString("Received ");
  WriteCard(count, 0);
  WriteString(" bytes from ");
  WriteString(hostname);
  WriteString(":");
  WriteCard(hostport, 0);
  WriteString(" -- ");
  WriteString(buf);
  WriteLn;
  FlushOutErr;

  (* Close UDP socket *)

  libipv4.UDP4_close(fd, error);
  CheckError(error, "UDP4_close() failed");
END test_udp4_client.

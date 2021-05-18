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

MODULE test_tcp4_stream_sender;

IMPORT
  errno,
  libipv4,
  libstream,
  Strings;

FROM Args IMPORT Narg, GetArg;
FROM ErrorHandling IMPORT CheckError;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT ReadString, SkipLine, WriteString, WriteLn;
FROM SYSTEM IMPORT BYTE;

CONST
  MESSAGE_SIZE = 256;
  FRAME_SIZE   = 2*MESSAGE_SIZE + 8;

VAR
  success   : BOOLEAN;
  hostname  : ARRAY [0 .. 255] OF CHAR;
  hostaddr  : CARDINAL;
  fd        : INTEGER;
  error     : CARDINAL;
  msg       : ARRAY [0 .. MESSAGE_SIZE - 1] OF CHAR;
  msgsize   : CARDINAL;
  frame     : ARRAY [0 .. FRAME_SIZE - 1] OF BYTE;
  framesize : CARDINAL;
  count     : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Stream Framing Protocol over Serial Port Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  IF Narg() <> 2 THEN
    WriteString("Usage: test_tcp4_stream_sender <host>");
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

  LOOP
    (* Get message to send *)

    WriteString("Enter message:  ");
    FlushOutErr;
    ReadString(msg);
    SkipLine;

    IF Strings.Equal(msg, "quit") THEN
      EXIT;
    END;

    (* Encode the message *)

    libstream.STREAM_encode_frame(msg, LENGTH(msg), frame, FRAME_SIZE,
      framesize, error);
    CheckError(error, "STREAM_encode_frame() failed");

    (* Send the encoded message frame *)

    libstream.STREAM_send_frame(fd, frame, framesize, count, error);
    CheckError(error, "STREAM_send_frame() failed");

    (* Reset the frame buffer, to use it for the incoming reply frame *)

    frame[0] := 0;
    frame[1] := 0;
    framesize := 0;

    (* Receive the encoded reply frame *)

    LOOP
      libstream.STREAM_receive_frame(fd, frame, FRAME_SIZE, framesize, error);

      IF error = errno.EOK THEN
        EXIT;
      ELSIF error <> errno.EAGAIN THEN
        CheckError(error, "STREAM_receive_frame() failed");
      END;
    END;

    (* Decode the reply frame and extract the reply *)

    libstream.STREAM_decode_frame(frame, framesize, msg, MESSAGE_SIZE, msgsize,
      error);
    CheckError(error, "STREAM_decode_frame() failed");

    msg[msgsize] := CHR(0);

    (* Display the reply *)

    WriteString("Received reply: ");
    WriteString(msg);
    WriteLn;
    FlushOutErr;
  END;

  (* Close the TCP connection *)

  libipv4.TCP4_close(fd, error);
  CheckError(error, "TCP4_close() failed");
END test_tcp4_stream_sender.

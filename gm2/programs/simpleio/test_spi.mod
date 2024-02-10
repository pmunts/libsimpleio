(* SPI Test using libsimpleio *)

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

MODULE test_spi;

IMPORT Channel, SPI_libsimpleio;

FROM ByteArray     IMPORT Fill, HexDump;
FROM ErrorHandling IMPORT CheckError;
FROM FIO           IMPORT FlushOutErr;
FROM NumberIO      IMPORT ReadHex;
FROM STextIO       IMPORT WriteString, WriteLn;
FROM SWholeIO      IMPORT WriteCard;
FROM SYSTEM        IMPORT BYTE;

VAR
  desg  : Channel.Designator;
  dev   : SPI_libsimpleio.Device;
  error : CARDINAL;
  cmd   : ARRAY [0 .. 15] OF BYTE;
  resp  : ARRAY [0 .. 15] OF BYTE;

BEGIN
  WriteLn;
  WriteString("SPI Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter SPI slave device");
  WriteLn;
  FlushOutErr;

  (* Open SPI slave device *)

  SPI_libsimpleio.Open(desg, SPI_libsimpleio.AUTO_CS, 0, 8, 1000000, dev,
    error);
  CheckError(error, "SPI_libsimpleio.Open() failed");

  WriteString("fd   => ");
  WriteCard(SPI_libsimpleio.fd(dev), 0);
  WriteLn;
  FlushOutErr;

  (* Perform a simple loopback operation *)

  Fill(cmd,  0, SIZE(cmd));
  Fill(resp, 0, SIZE(resp));

  SPI_libsimpleio.Write(dev, cmd, SIZE(cmd), error);
  CheckError(error, "SPI_libsimpleio.Write() failed");

  SPI_libsimpleio.Read(dev, resp, SIZE(resp), error);
  CheckError(error, "SPI_libsimpleio.Read() failed");

  (* Display results *)

  WriteString("cmd  => ");
  HexDump(cmd, SIZE(cmd));
  WriteLn;

  WriteString("resp => ");
  HexDump(resp, SIZE(resp));
  WriteLn;

  (* Close SPI slave device *)

  SPI_libsimpleio.Close(dev, error);
  CheckError(error, "SPI_libsimpleio.Close() failed");

END test_spi.

(* I2C Bus Test using libsimpleio *)

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

MODULE test_i2c;

IMPORT Channel, I2C_libsimpleio;

FROM ByteArray     IMPORT Fill, HexDump;
FROM ErrorHandling IMPORT CheckError;
FROM FIO           IMPORT FlushOutErr;
FROM NumberIO      IMPORT ReadHex;
FROM STextIO       IMPORT SkipLine, WriteString, WriteLn;
FROM SWholeIO      IMPORT WriteCard;
FROM SYSTEM        IMPORT BYTE;

VAR
  desg  : Channel.Designator;
  addr  : CARDINAL;
  bus   : I2C_libsimpleio.Bus;
  error : CARDINAL;
  cmd   : ARRAY [0 .. 0] OF BYTE;
  resp  : ARRAY [0 .. 0] OF BYTE;

BEGIN
  WriteLn;
  WriteString("I2C Bus Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator1("Enter I2C bus number");

  WriteString("Enter I2C slave device address: ");
  ReadHex(addr);
  WriteLn;
  FlushOutErr;

  (* Open I2C bus master device *)

  I2C_libsimpleio.Open(desg, bus, error);
  CheckError(error, "I2C_libsimpleio.Open() failed");

  WriteString("fd   => ");
  WriteCard(I2C_libsimpleio.fd(bus), 0);
  WriteLn;
  FlushOutErr;

  (* Perform a simple loopback operation *)

  Fill(cmd, 55H, SIZE(cmd));
  Fill(resp, 0, SIZE(resp));

  cmd[0] := 55H;

  I2C_libsimpleio.Write(bus, addr, cmd, 1, error);
  CheckError(error, "I2C_libsimpleio.Write() failed");

  I2C_libsimpleio.Read(bus, addr, resp, 1, error);
  CheckError(error, "I2C_libsimpleio.Read() failed");

  (* Display results *)

  WriteString("cmd  => ");
  HexDump(cmd, SIZE(cmd));
  WriteLn;

  WriteString("resp => ");
  HexDump(resp, SIZE(resp));
  WriteLn;

  (* Close I2C bus master device *)

  I2C_libsimpleio.Close(bus, error);
  CheckError(error, "I2C_libsimpleio.Close() failed");

END test_i2c.

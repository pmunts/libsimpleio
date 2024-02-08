(* Analog Output Test using libsimpleio *)

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

MODULE test_dac;

IMPORT DAC_libsimpleio, Channel;

FROM STextIO       IMPORT WriteString, WriteLn, SkipLine;
FROM SRealIO       IMPORT ReadReal;
FROM SWholeIO      IMPORT ReadCard;
FROM FIO           IMPORT FlushOutErr;

FROM ErrorHandling IMPORT CheckError;
FROM libc          IMPORT sleep;

VAR
  desg  : Channel.Designator;
  res   : CARDINAL;
  Vref  : REAL;
  outp  : DAC_libsimpleio.Output;
  error : CARDINAL;
  V     : REAL;

BEGIN
  WriteLn;
  WriteString("Analog Output Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter D/A converter");

  WriteString("Enter D/A converter resolution (bits): ");
  ReadCard(res);
  SkipLine;

  WriteString("Enter D/A converter reference (volts): ");
  ReadReal(Vref);
  SkipLine;
  WriteLn;
  FlushOutErr;

  (* Open analog output *)

  DAC_libsimpleio.OpenChannel(desg, res, Vref, outp, error);
  CheckError(error, "DAC_libsimpleio.OpenChannel() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    V := 0.0;

    WHILE V < Vref DO
      DAC_libsimpleio.WriteVolts(outp, V, error);
      CheckError(error, "DAC_libsimpleio.WriteVolts() failed");

      V := V + 0.01;
    END;
  END;

END test_dac.

(* Analog Input Test using libsimpleio *)

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

MODULE test_adc;

IMPORT ADC_libsimpleio, Channel;

FROM STextIO       IMPORT WriteString, WriteLn, SkipLine;
FROM SRealIO       IMPORT ReadReal, WriteFixed;
FROM SWholeIO      IMPORT ReadCard;
FROM FIO           IMPORT FlushOutErr;

FROM ErrorHandling IMPORT CheckError;
FROM libc          IMPORT sleep;

VAR
  desg   : Channel.Designator;
  res    : CARDINAL;
  Vref   : REAL;
  inp    : ADC_libsimpleio.Input;
  error  : CARDINAL;
  V      : REAL;

BEGIN
  WriteLn;
  WriteString("Analog Input Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter A/D converter");

  WriteString("Enter A/D converter resolution (bits): ");
  ReadCard(res);
  SkipLine;

  WriteString("Enter A/D converter reference (volts): ");
  ReadReal(Vref);
  SkipLine;
  WriteLn;
  FlushOutErr;

  (* Open analog input *)

  ADC_libsimpleio.Open(desg, res, Vref, inp, error);
  CheckError(error, "ADC_libsimpleio.Open() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    ADC_libsimpleio.ReadVolts(inp, V, error);
    CheckError(error, "ADC_libsimpleio.ReadVolts() failed");

    WriteFixed(V, 2, 4);
    WriteString(" V");
    WriteLn;
    FlushOutErr;
    sleep(1);
  END;

END test_adc.

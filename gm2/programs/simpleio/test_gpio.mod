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

MODULE test_gpio;

IMPORT Channel, GPIO_libsimpleio;

FROM STextIO       IMPORT WriteString, WriteLn, WriteChar;
FROM FIO           IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;

VAR
  desg   : Channel.Designator;
  outp   : GPIO_libsimpleio.Pin;
  error  : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi GPIO Toggle Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter GPIO");
  WriteLn;
  FlushOutErr;

  GPIO_libsimpleio.OpenChannel(desg, GPIO_libsimpleio.Output, FALSE,
    GPIO_libsimpleio.PushPull, GPIO_libsimpleio.None,
    GPIO_libsimpleio.ActiveHigh, outp, error);
  CheckError(error, "GPIO_libsimpleio.OpenChannel() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    GPIO_libsimpleio.Write(outp, TRUE, error);
    CheckError(error, "GPIO_libsimpleio.Write() failed");

    GPIO_libsimpleio.Write(outp, FALSE, error);
    CheckError(error, "GPIO_libsimpleio.Write() failed");
  END;

END test_gpio.

(* Copyright (C)2018-2024, Philip Munts dba Munts Technologies.                *)
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

MODULE test_led;

IMPORT
  GPIO_libsimpleio,
  RaspberryPi;

FROM STextIO       IMPORT WriteString, WriteLn;
FROM FIO           IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux      IMPORT Sleep;

VAR
  LED      : GPIO_libsimpleio.Pin;
  error    : CARDINAL;
  state    : BOOLEAN;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Configure LED GPIO output *)

  GPIO_libsimpleio.Open(RaspberryPi.GPIO26, GPIO_libsimpleio.Output, FALSE,
    GPIO_libsimpleio.PushPull, GPIO_libsimpleio.None,
    GPIO_libsimpleio.ActiveHigh, LED, error);
  CheckError(error, "GPIO_libsimpleio.Open() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    GPIO_libsimpleio.Read(LED, state, error);
    CheckError(error, "GPIO_libsimpleio.Read() failed");

    GPIO_libsimpleio.Write(LED, NOT state, error);
    CheckError(error, "GPIO_libsimpleio.Write() failed");

    Sleep(500000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;
END test_led.

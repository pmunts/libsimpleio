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

MODULE test_gpio;

IMPORT
  gpio_libsimpleio,
  RaspberryPi;

FROM STextIO IMPORT WriteString, WriteLn;
FROM FIO IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;

VAR
  GPIO26 : gpio_libsimpleio.Pin;
  error  : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi GPIO Toggle Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  gpio_libsimpleio.OpenChannel(RaspberryPi.GPIO26,
    gpio_libsimpleio.Output, TRUE, gpio_libsimpleio.PushPull,
    gpio_libsimpleio.None, gpio_libsimpleio.ActiveHigh, GPIO26, error);
  CheckError(error, "gpio_libsimpleio.Open() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    gpio_libsimpleio.Write(GPIO26, TRUE, error);
    CheckError(error, "gpio_libsimpleio.Write() failed");

    gpio_libsimpleio.Write(GPIO26, FALSE, error);
    CheckError(error, "gpio_libsimpleio.Write() failed");
  END;

END test_gpio.

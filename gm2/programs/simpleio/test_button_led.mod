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

MODULE test_button_led;

IMPORT
  GPIO_libsimpleio,
  RaspberryPi;

FROM STextIO IMPORT WriteString, WriteLn;
FROM FIO IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;

VAR
  Button   : GPIO_libsimpleio.Pin;
  LED      : GPIO_libsimpleio.Pin;
  error    : CARDINAL;
  newstate : BOOLEAN;
  oldstate : BOOLEAN;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi GPIO Button and LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Configure button and LED GPIO's *)

  GPIO_libsimpleio.OpenChannel(RaspberryPi.GPIO6,
    GPIO_libsimpleio.Input, FALSE, GPIO_libsimpleio.PushPull,
    GPIO_libsimpleio.None, GPIO_libsimpleio.ActiveHigh, Button, error);
  CheckError(error, "GPIO_libsimpleio.Open() failed");

  GPIO_libsimpleio.OpenChannel(RaspberryPi.GPIO26,
    GPIO_libsimpleio.Output, FALSE, GPIO_libsimpleio.PushPull,
    GPIO_libsimpleio.None, GPIO_libsimpleio.ActiveHigh, LED, error);
  CheckError(error, "GPIO_libsimpleio.Open() failed");

  (* Force initial detection *)

  GPIO_libsimpleio.Read(Button, oldstate, error);
  CheckError(error, "GPIO_libsimpleio.Read() failed");

  oldstate := NOT oldstate;

  (* Process button press and release events *)

  LOOP
    GPIO_libsimpleio.Read(Button, newstate, error);
    CheckError(error, "GPIO_libsimpleio.Read() failed");

    IF newstate <> oldstate THEN
      IF newstate THEN
        WriteString("PRESSED");
      ELSE
        WriteString("RELEASED");
      END;

      WriteLn;
      FlushOutErr;

      GPIO_libsimpleio.Write(LED, newstate, error);
      CheckError(error, "GPIO_libsimpleio.Write() failed");

      oldstate := newstate;
    END;
  END;
END test_button_led.

(* Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.             *)
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

MODULE test_gpio_interrupt_button_led;

IMPORT
  gpio_libsimpleio,
  RaspberryPi;

FROM STextIO IMPORT WriteString, WriteLn;
FROM FIO IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;

VAR
  Button   : gpio_libsimpleio.Pin;
  LED      : gpio_libsimpleio.Pin;
  newstate : BOOLEAN;
  error    : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi GPIO Interrupt Button and LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Configure button and LED GPIO's *)

  gpio_libsimpleio.OpenChannel(RaspberryPi.GPIO6,
    gpio_libsimpleio.Input, FALSE, gpio_libsimpleio.PushPull,
    gpio_libsimpleio.Both, gpio_libsimpleio.ActiveHigh, Button, error);
  CheckError(error, "gpio_libsimpleio.Open() failed");

  gpio_libsimpleio.OpenChannel(RaspberryPi.GPIO26,
    gpio_libsimpleio.Output, FALSE, gpio_libsimpleio.PushPull,
    gpio_libsimpleio.None, gpio_libsimpleio.ActiveHigh, LED, error);
  CheckError(error, "gpio_libsimpleio.Open() failed");

  (* Process button press and release events *)

  LOOP
    gpio_libsimpleio.Read(Button, newstate, error);
    CheckError(error, "gpio_libsimpleio.Read() failed");

    IF newstate THEN
      WriteString("PRESSED");
    ELSE
      WriteString("RELEASED");
    END;

    WriteLn;
    FlushOutErr;

    gpio_libsimpleio.Write(LED, newstate, error);
    CheckError(error, "gpio_libsimpleio.Write() failed");
  END;
END test_gpio_interrupt_button_led.

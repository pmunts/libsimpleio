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

MODULE test_hidraw_led_toggle;

IMPORT
  message64,
  hid_munts,
  hid_libsimpleio;

FROM ErrorHandling IMPORT CheckError;
FROM FIO IMPORT FlushOutErr;
FROM STextIO IMPORT WriteString, WriteLn;

VAR
  dev         : hid_libsimpleio.Device;
  ButtonState : message64.Message;
  LEDCommand  : message64.Message;
  error       : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raw HID Button and LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  hid_munts.Open(dev, hid_libsimpleio.FOREVER, error);
  CheckError(error, "hid_munts.Open() failed");

  LOOP
    hid_libsimpleio.Receive(dev, ButtonState, error);
    CheckError(error, "hid_libsimpleio.Receive() failed");

    IF ButtonState[0] <> 0 THEN
      WriteString("PRESS");
      WriteLn;
      FlushOutErr;

      LEDCommand[0] := 1;
    ELSE
      WriteString("RELEASE");
      WriteLn;
      FlushOutErr;

      LEDCommand[0] := 0;
    END;

    hid_libsimpleio.Send(dev, LEDCommand, error);
    CheckError(error, "hid_libsimpleio.Send() failed");
  END;
END test_hidraw_led_toggle.

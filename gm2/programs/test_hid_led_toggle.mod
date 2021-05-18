(* Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.             *)
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
FROM liblinux IMPORT usleep;

VAR
  dev     : hid_libsimpleio.Device;
  cmd     : message64.Message;
  error   : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raw HID LED Toggle Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  hid_munts.Open(hid_libsimpleio.ANYSERIAL, hid_libsimpleio.FOREVER, dev, error);
  CheckError(error, "hid_munts.Open() failed");

  LOOP
    cmd[0] := 1;
    hid_libsimpleio.Send(dev, cmd, error);
    CheckError(error, "hid_libsimpleio.Send() failed");

    usleep(500000, error);

    cmd[0] := 0;
    hid_libsimpleio.Send(dev, cmd, error);
    CheckError(error, "hid_libsimpleio.Send() failed");

    usleep(500000, error);
  END;
END test_hidraw_led_toggle.

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

MODULE test_watchdog;

IMPORT
  watchdog_libsimpleio;

FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM FIO IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux IMPORT usleep;

VAR
  wdt     : watchdog_libsimpleio.Watchdog;
  error   : CARDINAL;
  timeout : CARDINAL;
  i       : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi Watchdog Timer Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  watchdog_libsimpleio.Open(watchdog_libsimpleio.DefaultDevice, wdt, error);
  CheckError(error, "watchdog_libsimpleio.Open() failed");

  watchdog_libsimpleio.GetTimeout(wdt, timeout, error);
  CheckError(error, "watchdog_libsimpleio.GetTimeout() failed");

  WriteString("Default Timeout => ");
  WriteCard(timeout, 0);
  WriteString(" seconds");
  WriteLn;
  FlushOutErr;

  watchdog_libsimpleio.SetTimeout(wdt, 5, error);
  CheckError(error, "watchdog_libsimpleio.SetTimeout() failed");

  watchdog_libsimpleio.GetTimeout(wdt, timeout, error);
  CheckError(error, "watchdog_libsimpleio.GetTimeout() failed");

  WriteString("New Timeout     => ");
  WriteCard(timeout, 0);
  WriteString(" seconds");
  WriteLn;
  WriteLn;
  FlushOutErr;

  WriteString("Kick the dog...");
  WriteLn;
  WriteLn;
  FlushOutErr;

  FOR i := 1 TO 10 DO
    WriteCard(i, 0);
    WriteLn;
    FlushOutErr;

    watchdog_libsimpleio.Kick(wdt, error);
    CheckError(error, "watchdog_libsimpleio.Kick() failed");

    usleep(1000000, error);
    CheckError(error, "usleep() failed");
  END;

  WriteLn;
  WriteString("Don't kick the dog...");
  WriteLn;
  WriteLn;
  FlushOutErr;

  FOR i := 1 TO 10 DO
    WriteCard(i, 0);
    WriteLn;
    FlushOutErr;

    usleep(1000000, error);
    CheckError(error, "usleep() failed");
  END;
END test_watchdog.

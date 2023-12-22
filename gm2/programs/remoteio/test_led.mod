(* Remote I/O Protocol LED Test *)

(* Copyright (C)2023, Philip Munts dba Munts Technologies.                     *)
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
    ErrorHandling,
    GPIO,
    GPIO_remoteio,
    libc,
    libremoteio;

  FROM STextIO IMPORT WriteString, WriteLn;
  FROM FIO     IMPORT FlushOutErr;

  VAR
    handle     : INTEGER;
    error      : INTEGER;
    outp       : GPIO_remoteio.Pin;
    state      : BOOLEAN;

BEGIN
  WriteLn;
  WriteString("Remote I/O Protocol LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  libremoteio.open_hid(016D0H, 00AFAH, "", libremoteio.TIMEOUT_DEFAULT, handle, error);
  ErrorHandling.CheckError(error, "open_hid() failed");

  GPIO_remoteio.Initialize(outp, handle, 0, GPIO.Output, TRUE, error);
  ErrorHandling.CheckError(error, "Initialize() failed");

  LOOP
    GPIO_remoteio.Read(outp, state, error);
    ErrorHandling.CheckError(error, "Read() failed");

    state := NOT state;

    GPIO_remoteio.Write(outp, state, error);
    ErrorHandling.CheckError(error, "Write() failed");

    libc.sleep(1);
  END;
END test_led.

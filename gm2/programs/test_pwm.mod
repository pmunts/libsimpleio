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

MODULE test_pwm;

IMPORT
  pwm_libsimpleio,
  RaspberryPi;

FROM STextIO IMPORT WriteString, WriteLn;
FROM FIO IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux IMPORT usleep;

VAR
  PWM0  : pwm_libsimpleio.Pin;
  error : CARDINAL;
  duty  : REAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi PWM Output Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Open the PWM output device *)

  pwm_libsimpleio.OpenChannel(RaspberryPi.PWM0, 1000,
    pwm_libsimpleio.DUTYCYCLE_MAX/2.0, PWM0, error);
  CheckError(error, "pwm_libsimpleio.Open() failed");

  (* Sweep the PWM output dutycycle from 0 to 100 percent *)

  duty := pwm_libsimpleio.DUTYCYCLE_MIN;

  WHILE duty <= pwm_libsimpleio.DUTYCYCLE_MAX DO
    pwm_libsimpleio.Write(PWM0, duty, error);
    CheckError(error, "pwm_libsimpleio.Write() failed");

    duty := duty + 1.0;

    usleep(100000, error);
    CheckError(error, "usleep() failed");
  END;

  (* Sweep the PWM output dutycycle from 100 to 0 percent *)

  duty := pwm_libsimpleio.DUTYCYCLE_MAX;

  WHILE duty >= pwm_libsimpleio.DUTYCYCLE_MIN DO
    pwm_libsimpleio.Write(PWM0, duty, error);
    CheckError(error, "pwm_libsimpleio.Write() failed");

    duty := duty - 1.0;

    usleep(100000, error);
    CheckError(error, "usleep() failed");
  END;

  (* Close the PWM output device *)

  pwm_libsimpleio.Close(PWM0, error);
  CheckError(error, "pwm_libsimpleio.Close() failed");
END test_pwm.

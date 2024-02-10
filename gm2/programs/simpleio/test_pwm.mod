(* PWM (Pulse Width Modulation) Test using libsimpleio *)

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

MODULE test_pwm;

IMPORT Channel, PWM_libsimpleio;

FROM STextIO       IMPORT WriteString, WriteLn;
FROM SWholeIO      IMPORT ReadCard;
FROM FIO           IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux      IMPORT LINUX_usleep;

VAR
  desg  : Channel.Designator;
  freq  : CARDINAL;
  outp  : PWM_libsimpleio.Output;
  error : CARDINAL;
  duty  : REAL;

BEGIN
  WriteLn;
  WriteString("PWM (Pulse Width Modulation) Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter PWM");

  WriteString("Enter frequency:   ");
  ReadCard(freq);
  WriteLn;
  FlushOutErr;

  (* Open the PWM output device *)

  PWM_libsimpleio.Open(desg, freq, PWM_libsimpleio.DUTYCYCLE_MAXIMUM/2.0,
    outp, error);
  CheckError(error, "PWM_libsimpleio.Open() failed");

  (* Sweep the PWM output dutycycle from 0 to 100 percent *)

  duty := PWM_libsimpleio.DUTYCYCLE_MINIMUM;

  WHILE duty <= PWM_libsimpleio.DUTYCYCLE_MAXIMUM DO
    PWM_libsimpleio.Write(outp, duty, error);
    CheckError(error, "PWM_libsimpleio.Write() failed");

    duty := duty + 1.0;

    LINUX_usleep(100000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;

  (* Sweep the PWM output dutycycle from 100 to 0 percent *)

  duty := PWM_libsimpleio.DUTYCYCLE_MAXIMUM;

  WHILE duty >= PWM_libsimpleio.DUTYCYCLE_MINIMUM DO
    PWM_libsimpleio.Write(outp, duty, error);
    CheckError(error, "PWM_libsimpleio.Write() failed");

    duty := duty - 1.0;

    LINUX_usleep(100000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;

  (* Close the PWM output device *)

  PWM_libsimpleio.Close(outp, error);
  CheckError(error, "PWM_libsimpleio.Close() failed");
END test_pwm.

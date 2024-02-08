(* Servo Test using libsimpleio *)

(* Copyright (C)2024, Philip Munts dba Munts Technologies.                     *)
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

MODULE test_servo;

IMPORT Channel, Servo_libsimpleio;

FROM STextIO       IMPORT WriteString, WriteLn;
FROM SWholeIO      IMPORT ReadCard;
FROM FIO           IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux      IMPORT LINUX_usleep;

VAR
  desg      : Channel.Designator;
  freq      : CARDINAL;
  outp      : Servo_libsimpleio.Output;
  error     : CARDINAL;
  position  : REAL;

BEGIN
  WriteLn;
  WriteString("Servo Test using libsimpleio");
  WriteLn;
  WriteLn;
  FlushOutErr;

  desg := Channel.GetDesignator2("Enter PWM");

  WriteString("Enter frequency:   ");
  ReadCard(freq);
  WriteLn;
  FlushOutErr;

  (* Open the servo output device *)

  Servo_libsimpleio.OpenChannel(desg, freq, Servo_libsimpleio.POSITION_NEUTRAL,
    outp, error);
  CheckError(error, "Servo_libsimpleio.OpenChannel() failed");

  (* Sweep the servo position from neutral to maximum *)

  position := Servo_libsimpleio.POSITION_NEUTRAL;

  WHILE position <= Servo_libsimpleio.POSITION_MAXIMUM DO
    Servo_libsimpleio.Write(outp, position, error);
    CheckError(error, "Servo_libsimpleio.Write() failed");

    position := position + 0.01;

    LINUX_usleep(100000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;

  (* Sweep the servo position from maximum to minimum *)

  position := Servo_libsimpleio.POSITION_MAXIMUM;

  WHILE position >= Servo_libsimpleio.POSITION_MINIMUM DO
    Servo_libsimpleio.Write(outp, position, error);
    CheckError(error, "Servo_libsimpleio.Write() failed");

    position := position - 0.01;

    LINUX_usleep(100000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;

  (* Sweep the servo position from minimum to neutral *)

  position := Servo_libsimpleio.POSITION_MINIMUM;

  WHILE position <= Servo_libsimpleio.POSITION_NEUTRAL DO
    Servo_libsimpleio.Write(outp, position, error);
    CheckError(error, "Servo_libsimpleio.Write() failed");

    position := position + 0.01;

    LINUX_usleep(100000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;

  (* Close the servo output device *)

  Servo_libsimpleio.Close(outp, error);
  CheckError(error, "Servo_libsimpleio.Close() failed");
END test_servo.

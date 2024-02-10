(* Servo output services using libsimpleio *)

(* Copyright (C)2024, Philip Munts dba Munts Technologies.                *)
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

IMPLEMENTATION MODULE Servo_libsimpleio;

  IMPORT
    errno,
    libpwm;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    OutputRec = RECORD
      period : CARDINAL;  (* nanoseconds *)
      fd     : INTEGER;
    END;

    Output = POINTER TO OutputRec;

  PROCEDURE Open
   (desg      : Channel.Designator;
    frequency : CARDINAL;
    position  : REAL;
    VAR outp  : Output;
    VAR error : CARDINAL);

  VAR
    period : CARDINAL;
    ontime : CARDINAL;
    fd     : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF outp <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    IF (position < POSITION_MINIMUM) OR (position > POSITION_MAXIMUM) THEN
      error := errno.EINVAL;
      RETURN;
    END;

    period := TRUNC(1.0E9/FLOAT(frequency) + 0.5);         (* nanoseconds *)
    ontime := TRUNC(1500000.0 + 500000.0*position + 0.5);  (* nanoseconds *)

    (* Configure the PWM output device *)

    libpwm.PWM_configure(desg.chip, desg.channel, period, ontime,
      libpwm.PWM_ACTIVEHIGH, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Open the PWM output device *)

    libpwm.PWM_open(desg.chip, desg.channel, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new Servo output object *)

    NEW(outp);
    outp^.fd     := fd;
    outp^.period := period;

    error := errno.EOK;
  END Open;

  PROCEDURE Close
   (VAR outp  : Output;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF outp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the PWM output device *)

    libpwm.PWM_close(outp^.fd, error);

    (* Destroy the Servo output object *)

    DISPOSE(outp);
    outp := NIL;
  END Close;

  PROCEDURE Write
   (outp      : Output;
    position  : REAL;
    VAR error : CARDINAL);

  VAR
    ontime : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF outp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    IF (position < POSITION_MINIMUM) OR (position > POSITION_MAXIMUM) THEN
      error := errno.EINVAL;
      RETURN;
    END;

    ontime := TRUNC(1500000.0 + 500000.0*position + 0.5);  (* nanoseconds *)

    libpwm.PWM_write(outp^.fd, ontime, error);
  END Write;

  PROCEDURE fd(outp : Output) : INTEGER;

  BEGIN
    RETURN outp^.fd;
  END fd;

END Servo_libsimpleio.

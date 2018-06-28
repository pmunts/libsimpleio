(* PWM output pin services using libsimpleio *)

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

IMPLEMENTATION MODULE pwm_libsimpleio;

  IMPORT
    errno,
    libpwm;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    PinRec = RECORD
      period : CARDINAL;
      fd     : INTEGER;
    END;

    Pin = POINTER TO PinRec;

  PROCEDURE Open
   (chip       : CARDINAL;
    channel    : CARDINAL;
    frequency  : CARDINAL;
    dutycycle  : REAL;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  VAR
    period : CARDINAL;
    ontime : CARDINAL;
    fd     : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF pin <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    IF (dutycycle < DUTYCYCLE_MIN) OR (dutycycle > DUTYCYCLE_MAX) THEN
      error := errno.EINVAL;
      RETURN;
    END;

    period := TRUNC(1.0E9/FLOAT(frequency) + 0.5);
    ontime := TRUNC(dutycycle/DUTYCYCLE_MAX*FLOAT(period) + 0.5);

    (* Configure the PWM output pin *)

    libpwm.PWM_configure(chip, channel, period, ontime, libpwm.PWM_ACTIVEHIGH,
      error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Open the PWM output pin device *)

    libpwm.PWM_open(chip, channel, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new analog input pin object *)

    NEW(pin);
    pin^.fd := fd;
    pin^.period := period;
    error := errno.EOK;
  END Open;

  PROCEDURE OpenChannel
   (channel    : Channel.Designator;
    frequency  : CARDINAL;
    dutycycle  : REAL;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  BEGIN
    Open(channel.chip, channel.channel, frequency, dutycycle, pin,
      error);
  END OpenChannel;

  PROCEDURE Close
   (VAR pin    : Pin;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF pin = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the analog input pin device *)

    libpwm.PWM_close(pin^.fd, error);

    (* Destroy the analog input pin object *)

    DISPOSE(pin);
    pin := NIL;
  END Close;

  PROCEDURE Write
   (pin        : Pin;
    dutycycle  : REAL;
    VAR error  : CARDINAL);

  VAR
    ontime : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF pin = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    IF (dutycycle < DUTYCYCLE_MIN) OR (dutycycle > DUTYCYCLE_MAX) THEN
      error := errno.EINVAL;
      RETURN;
    END;

    ontime := TRUNC(dutycycle/DUTYCYCLE_MAX*FLOAT(pin^.period) + 0.5);

    libpwm.PWM_write(pin^.fd, ontime, error);
  END Write;

  PROCEDURE fd(pin : Pin) : INTEGER;

  BEGIN
    RETURN pin^.fd;
  END fd;

END pwm_libsimpleio.

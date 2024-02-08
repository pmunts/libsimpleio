(* Analog input services using libsimpleio *)

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

IMPLEMENTATION MODULE adc_libsimpleio;

  IMPORT
    errno,
    libadc;

  FROM RealMath IMPORT power;
  FROM Storage  IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    InputRec = RECORD
      fd         : INTEGER;
      resolution : CARDINAL;
      stepsize   : REAL;
    END;

    Input = POINTER TO InputRec;

  PROCEDURE Open
   (chip       : CARDINAL;
    channel    : CARDINAL;
    resolution : CARDINAL;  (* Bits  *)
    reference  : REAL;      (* Volts *)
    VAR inp    : Input;
    VAR error  : CARDINAL);

  VAR
    fd : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF inp <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Open the analog input device *)

    libadc.ADC_open(chip, channel, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new analog input object *)

    NEW(inp);

    inp^.fd         := fd;
    inp^.resolution := resolution;

    IF (resolution = 0) OR (reference = 0.0) THEN
      (* Resolution and/or reference are undefined. *)
      (* ReadVolts() will always return 0.0V.       *)
      inp^.stepsize := 0.0;
    ELSE
      (* Calculate the ADC step size, in volts *)
      inp^.stepsize := reference/power(2.0, FLOAT(resolution));
    END;

    error           := errno.EOK;
  END Open;

  PROCEDURE OpenChannel
   (channel    : Channel.Designator;
    resolution : CARDINAL;  (* Bits  *)
    reference  : REAL;      (* Volts *)
    VAR inp    : Input;
    VAR error  : CARDINAL);

  BEGIN
    Open(channel.chip, channel.channel, resolution, reference, inp, error);
  END OpenChannel;

  PROCEDURE Close
   (VAR inp    : Input;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF inp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the analog input device *)

    libadc.ADC_close(inp^.fd, error);

    (* Destroy the analog input object *)

    DISPOSE(inp);
    inp := NIL;
  END Close;

  PROCEDURE ReadRaw
   (inp        : Input;
    VAR sample : INTEGER;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF inp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Read an analog input sample *)

    libadc.ADC_read(inp^.fd, sample, error);
  END ReadRaw;

  PROCEDURE ReadVolts
   (inp        : Input;
    VAR volts  : REAL;
    VAR error  : CARDINAL);

  VAR
    sample : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF inp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    ReadRaw(inp, sample, error);

    IF error = 0 THEN
      volts := FLOAT(sample)*inp^.stepsize;
    END;
  END ReadVolts;

  PROCEDURE fd(inp : Input) : INTEGER;

  BEGIN
    RETURN inp^.fd;
  END fd;

END adc_libsimpleio.

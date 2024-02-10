(* Analog output services using libsimpleio *)

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

IMPLEMENTATION MODULE DAC_libsimpleio;

  IMPORT
    errno,
    libdac;

  FROM RealMath IMPORT power;
  FROM Storage  IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    OutputRec = RECORD
      fd         : INTEGER;
      resolution : CARDINAL;
      stepsize   : REAL;
    END;

    Output = POINTER TO OutputRec;

  PROCEDURE Open
   (desg       : Channel.Designator;
    resolution : CARDINAL;  (* Bits  *)
    reference  : REAL;      (* Volts *)
    VAR outp   : Output;
    VAR error  : CARDINAL);

  VAR
    fd : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF outp <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Open the analog output device *)

    libdac.DAC_open(desg.chip, desg.channel, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new analog output object *)

    NEW(outp);

    outp^.fd         := fd;
    outp^.resolution := resolution;

    IF (resolution = 0) OR (reference = 0.0) THEN
      (* Resolution and/or reference are undefined. *)
      (* WriteVolts() will always return 0.0V.       *)
      outp^.stepsize := 0.0;
    ELSE
      (* Calculate the DAC step size, in volts *)
      outp^.stepsize := reference/power(2.0, FLOAT(resolution));
    END;

    error           := errno.EOK;
  END Open;

  PROCEDURE Close
   (VAR outp   : Output;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF outp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the analog output device *)

    libdac.DAC_close(outp^.fd, error);

    (* Destroy the analog output object *)

    DISPOSE(outp);
    outp := NIL;
  END Close;

  PROCEDURE WriteRaw
   (outp       : Output;
    sample     : INTEGER;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF outp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Write an analog output sample *)

    libdac.DAC_write(outp^.fd, sample, error);
  END WriteRaw;

  PROCEDURE WriteVolts
   (outp       : Output;
    volts      : REAL;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF outp = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    WriteRaw(outp, TRUNC(volts/outp^.stepsize), error);
  END WriteVolts;

  PROCEDURE fd(outp : Output) : INTEGER;

  BEGIN
    RETURN outp^.fd;
  END fd;

END DAC_libsimpleio.

(* Analog input pin services using libsimpleio *)

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

IMPLEMENTATION MODULE adc_libsimpleio;

  IMPORT
    errno,
    libadc;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    PinRec = RECORD
      fd : INTEGER;
    END;

    Pin = POINTER TO PinRec;

  PROCEDURE Open
   (chip       : CARDINAL;
    channel    : CARDINAL;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  VAR
    fd : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF pin <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Open the analog input pin device *)

    libadc.ADC_open(chip, channel, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new analog input pin object *)

    NEW(pin);
    pin^.fd := fd;
    error := errno.EOK;
  END Open;

  PROCEDURE OpenChannel
   (channel    : Channel.Designator;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  BEGIN
    Open(channel.chip, channel.channel, pin, error);
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

    libadc.ADC_close(pin^.fd, error);

    (* Destroy the analog input pin object *)

    DISPOSE(pin);
    pin := NIL;
  END Close;

  PROCEDURE Read
   (pin        : Pin;
    VAR sample : INTEGER;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF pin = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Read an analog input sample *)

    libadc.ADC_read(pin^.fd, sample, error);
  END Read;

  PROCEDURE fd(pin : Pin) : INTEGER;

  BEGIN
    RETURN pin^.fd;
  END fd;

END adc_libsimpleio.

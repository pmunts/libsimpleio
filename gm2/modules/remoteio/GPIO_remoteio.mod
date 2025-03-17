(* Remote I/O Protocol support for GNU Modula-2 programs running on Linux      *)
(* computers, using libremoteio.so and libsimpleio.so.                         *)
(*                                                                             *)
(* https://repo.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf                 *)

(* Copyright (C)2025, Philip Munts dba Munts Technologies.                     *)
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

IMPLEMENTATION MODULE GPIO_remoteio;

  IMPORT
    errno,
    libremoteio;

  FROM Storage IMPORT ALLOCATE;

  TYPE
    PinRec = RECORD
      handle  : INTEGER;
      channel : Channel.Number;
      dir     : GPIO.Direction;
    END;

    Pin = POINTER TO PinRec;

  (* Initialize a GPIO pin object *)

  PROCEDURE Initialize
   (VAR p     : Pin;
    handle    : INTEGER;          (* Remote I/O Protocol Server handle *)
    channel   : Channel.Number;   (* GPIO channel number *)
    dir       : GPIO.Direction;   (* Data direction *)
    state     : BOOLEAN;          (* Initial state for output pins *)
    VAR error : INTEGER);

  BEGIN
    libremoteio.gpio_configure(handle, channel, ORD(dir), ORD(state), error);

    IF error <> 0 THEN
      RETURN;
    END;

    NEW(p);
    p^.handle  := handle;
    p^.channel := channel;
    p^.dir     := dir;

    IF dir = GPIO.Output THEN
      Write(p, state, error);
    END;
  END Initialize;

  (* Read from a GPIO pin *)

  PROCEDURE Read
   (p         : Pin;              (* GPIO pin object *)
    VAR state : BOOLEAN;          (* current GPIO pin state *)
    VAR error : INTEGER);

  VAR
    istate : INTEGER;

  BEGIN
    libremoteio.gpio_read(p^.handle, p^.channel, istate, error);

    IF error <> 0 THEN
      state := FALSE;
      RETURN;
    END;

    state := istate <> 0;
  END Read;

  PROCEDURE Write
   (p         : Pin;              (* GPIO pin object *)
    state     : BOOLEAN;          (* new GPIO output pin state *)
    VAR error : INTEGER);

  BEGIN
    IF p^.dir = GPIO.Input THEN
      error := errno.EINVAL;
      RETURN;
    END;

    libremoteio.gpio_write(p^.handle, p^.channel, ORD(state), error);
  END Write;

END GPIO_remoteio.

(* GPIO pin services using libsimpleio *)

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

IMPLEMENTATION MODULE gpio_libsimpleio;

  IMPORT
    errno,
    libgpio;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    PinRec = RECORD
      fd  : INTEGER;
      int : BOOLEAN;
    END;

    Pin = POINTER TO PinRec;

  PROCEDURE Open
   (chip       : CARDINAL;
    line       : CARDINAL;
    dir        : Direction;
    state      : BOOLEAN;
    driver     : Driver;
    edge       : Edge;
    polarity   : Polarity;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  VAR
    flags  : CARDINAL;
    events : CARDINAL;
    fd     : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF pin <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Compute parameters *)

    CASE dir OF
      Input      : flags := libgpio.LINE_REQUEST_INPUT;               |
      Output     : flags := libgpio.LINE_REQUEST_OUTPUT;
    END;

    CASE driver OF
      PushPull   : flags := flags + libgpio.LINE_REQUEST_PUSH_PULL;  |
      OpenDrain  : flags := flags + libgpio.LINE_REQUEST_OPEN_DRAIN; |
      OpenSource : flags := flags + libgpio.LINE_REQUEST_OPEN_SOURCE;
    END;

    CASE polarity OF
      ActiveLow  : flags := flags + libgpio.LINE_REQUEST_ACTIVE_LOW; |
      ActiveHigh : flags := flags + libgpio.LINE_REQUEST_ACTIVE_HIGH;
    END;

    CASE edge OF
      None       : events := libgpio.EVENT_REQUEST_NONE;              |
      Rising     : events := libgpio.EVENT_REQUEST_RISING;            |
      Falling    : events := libgpio.EVENT_REQUEST_FALLING;           |
      Both       : events := libgpio.EVENT_REQUEST_BOTH;
    END;

    (* Open the GPIO pin device *)

    libgpio.GPIO_line_open(chip, line, flags, events, ORD(state), fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new GPIO pin object *)

    NEW(pin);

    pin^.fd := fd;

    IF edge = None THEN
      pin^.int := FALSE;
    ELSE
      pin^.int := TRUE;
    END;

    error := errno.EOK;
  END Open;

  PROCEDURE OpenChannel
   (channel    : Channel.Designator;
    dir        : Direction;
    state      : BOOLEAN;
    driver     : Driver;
    edge       : Edge;
    polarity   : Polarity;
    VAR pin    : Pin;
    VAR error  : CARDINAL);

  BEGIN
    Open(channel.chip, channel.channel, dir, state, driver, edge,
      polarity, pin, error);
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

    (* Close the GPIO pin device *)

    libgpio.GPIO_line_close(pin^.fd, error);

    (* Destroy the GPIO pin object *)

    DISPOSE(pin);
    pin := NIL;
  END Close;

  PROCEDURE Read
   (pin        : Pin;
    VAR state  : BOOLEAN;
    VAR error  : CARDINAL);

  VAR
    istate : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF pin = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Read from the GPIO pin *)

    IF pin^.int THEN
      libgpio.GPIO_line_event(pin^.fd, istate, error);
    ELSE
      libgpio.GPIO_line_read(pin^.fd, istate, error);
    END;

    state := VAL(BOOLEAN, istate);
  END Read;

  PROCEDURE Write
   (pin        : Pin;
    state      : BOOLEAN;
    VAR error  : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF pin = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    IF pin^.int THEN
      error := errno.EIO;
    END;

    (* Write to the GPIO pin *)

    libgpio.GPIO_line_write(pin^.fd, ORD(state), error);
  END Write;

  PROCEDURE fd(pin : Pin) : INTEGER;

  BEGIN
    RETURN pin^.fd;
  END fd;

END gpio_libsimpleio.

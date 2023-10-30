(* Watchdog timer services using libsimpleio *)

(* Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                *)
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

IMPLEMENTATION MODULE watchdog_libsimpleio;

  IMPORT
    errno,
    libwatchdog;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    WDTRec = RECORD
      fd : INTEGER;
    END;

    Watchdog = POINTER TO WDTRec;

  PROCEDURE Open
   (name        : ARRAY OF CHAR;
    VAR wdt     : Watchdog;
    VAR error   : CARDINAL);

  VAR
    fd : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF wdt <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Open the watchdog timer device *)

    libwatchdog.WATCHDOG_open(name, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a watchdog timer object *)

    NEW(wdt);
    wdt^.fd := fd;
    error := errno.EOK;
  END Open;

  PROCEDURE Close
   (VAR wdt     : Watchdog;
    VAR error   : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF wdt = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the watchdog timer device *)

    libwatchdog.WATCHDOG_close(wdt^.fd, error);

    (* Destroy the watchdog timer object *)

    DISPOSE(wdt);
    wdt := NIL;
  END Close;

  PROCEDURE GetTimeout
   (wdt         : Watchdog;
    VAR timeout : CARDINAL;
    VAR error   : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF wdt = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Query the watchdog timer period *)

    libwatchdog.WATCHDOG_get_timeout(wdt^.fd, timeout, error);
  END GetTimeout;

  PROCEDURE SetTimeout
   (wdt         : Watchdog;
    timeout     : CARDINAL;
    VAR error   : CARDINAL);

  VAR
    oldtimeout : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF wdt = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Configure the watchdog timer period *)

    libwatchdog.WATCHDOG_set_timeout(wdt^.fd, timeout, oldtimeout, error);
  END SetTimeout;

  PROCEDURE Kick
   (wdt         : Watchdog;
    VAR error   : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF wdt = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Reset the watchdog timer *)

    libwatchdog.WATCHDOG_kick(wdt^.fd, error);
  END Kick;

  PROCEDURE fd(wdt : Watchdog) : INTEGER;

  BEGIN
    RETURN wdt^.fd;
  END fd;

END watchdog_libsimpleio.

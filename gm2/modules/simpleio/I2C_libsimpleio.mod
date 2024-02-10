(* I2C bus master services using libsimpleio *)

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

IMPLEMENTATION MODULE I2C_libsimpleio;

  IMPORT errno, libi2c;

  FROM SYSTEM   IMPORT ADR, BYTE;
  FROM Storage  IMPORT ALLOCATE, DEALLOCATE;
  FROM Strings  IMPORT Concat;
  FROM WholeStr IMPORT CardToStr;

  TYPE
    BusRec = RECORD
      fd : INTEGER;
    END;

    Bus = POINTER TO BusRec;

  PROCEDURE Open
   (desg      : Channel.Designator;
    VAR bus   : Bus;
    VAR error : CARDINAL);

  VAR
    busname : ARRAY [0 .. 15] OF CHAR;
    devname : ARRAY [0 .. 15] OF CHAR;
    fd      : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF bus  <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    IF desg.chip <> 0 THEN
      error := errno.EINVAL;
      RETURN;
    END;

    (* Open the I2C bus device *)

    CardToStr(desg.channel, busname);
    Concat("/dev/i2c-", busname, devname);

    libi2c.I2C_open(devname, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new I2C bus object *)

    NEW(bus);
    bus^.fd     := fd;

    error := errno.EOK;
  END Open;

  PROCEDURE Close
   (VAR bus    : Bus;
    VAR error  : CARDINAL);

  VAR i : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF bus  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the I2C bus device *)

    libi2c.I2C_close(bus^.fd, error);

    (* Destroy the I2C bus object *)

    DISPOSE(bus);
    bus  := NIL;
  END Close;

  PROCEDURE Transaction
   (bus       : Bus;
    addr      : CARDINAL;
    cmd       : ARRAY OF BYTE;
    cmdlen    : CARDINAL;
    VAR resp  : ARRAY OF BYTE;
    resplen   : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF bus  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libi2c.I2C_transaction(bus^.fd, addr, ADR(cmd), cmdlen, ADR(resp),
      resplen, error);
  END Transaction;

  PROCEDURE Read
   (bus       : Bus;
    addr      : CARDINAL;
    VAR resp  : ARRAY OF BYTE;
    resplen   : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF bus  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libi2c.I2C_transaction(bus^.fd, addr, NIL, 0, ADR(resp), resplen, error);
  END Read;

  PROCEDURE Write
   (bus       : Bus;
    addr      : CARDINAL;
    cmd       : ARRAY OF BYTE;
    cmdlen    : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF bus  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libi2c.I2C_transaction(bus^.fd, addr, ADR(cmd), cmdlen, NIL, 0, error);
  END Write;

  PROCEDURE fd(bus : Bus) : INTEGER;

  BEGIN
    RETURN bus^.fd;
  END fd;

END I2C_libsimpleio.

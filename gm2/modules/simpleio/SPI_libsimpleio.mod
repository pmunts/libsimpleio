(* SPI slave device services using libsimpleio *)

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

IMPLEMENTATION MODULE SPI_libsimpleio;

  IMPORT errno, libspi, libgpio;

  FROM SYSTEM   IMPORT ADR, BYTE;
  FROM Storage  IMPORT ALLOCATE, DEALLOCATE;
  FROM Strings  IMPORT Append;
  FROM WholeStr IMPORT CardToStr;

  TYPE
    DeviceRec = RECORD
      fd   : INTEGER;
      csfd : INTEGER;
    END;

    Device = POINTER TO DeviceRec;

  PROCEDURE Open
   (desg      : Channel.Designator;
    csdesg    : Channel.Designator;
    mode      : CARDINAL;
    wordsize  : CARDINAL;
    speed     : CARDINAL;
    VAR dev   : Device;
    VAR error : CARDINAL);

  VAR
    devname : ARRAY [0 .. 31] OF CHAR;
    chipstr : ARRAY [0 .. 15] OF CHAR;
    chanstr : ARRAY [0 .. 15] OF CHAR;
    fd      : INTEGER;
    csfd    : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF dev  <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    IF desg.chip <> 0 THEN
      error := errno.EINVAL;
      RETURN;
    END;

    (* Open the SPI dev device *)

    CardToStr(desg.chip, chipstr);
    CardToStr(desg.channel, chanstr);

    devname := "/dev/spidev";
    Append(chipstr, devname);
    Append(".", devname);
    Append(chanstr, devname);

    libspi.SPI_open(devname, mode, wordsize, speed, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Configure slave select *)

    IF (csdesg.chip <> AUTO_CS.chip) OR (csdesg.channel <> AUTO_CS.channel) THEN
      libgpio.GPIO_line_open(csdesg.chip, csdesg.channel,
        libgpio.LINE_REQUEST_OUTPUT, 0, 1, csfd, error);

      IF error <> 0 THEN
        RETURN;
      END;
    ELSE
      csfd := libspi.AUTO_CS;
    END;

    (* Create a new SPI dev object *)

    NEW(dev);
    dev^.fd     := fd;
    dev^.csfd   := csfd;

    error := errno.EOK;
  END Open;

  PROCEDURE Close
   (VAR dev    : Device;
    VAR error  : CARDINAL);

  VAR i : CARDINAL;

  BEGIN
    (* Validate parameters *)

    IF dev  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the SPI slave device *)

    libspi.SPI_close(dev^.fd, error);

    (* Close the slave select GPIO pin *)

    IF dev^.csfd <> libspi.AUTO_CS THEN
      libgpio.GPIO_line_close(dev^.csfd, error);
    END;

    (* Destroy the SPI dev object *)

    DISPOSE(dev);
    dev  := NIL;
  END Close;

  PROCEDURE Transaction
   (dev       : Device;
    cmd       : ARRAY OF BYTE;
    cmdlen    : CARDINAL;
    delayus   : CARDINAL;
    VAR resp  : ARRAY OF BYTE;
    resplen   : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF dev  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libspi.SPI_transaction(dev^.fd, dev^.csfd, ADR(cmd), cmdlen, delayus,
      ADR(resp), resplen, error);
  END Transaction;

  PROCEDURE Read
   (dev       : Device;
    VAR resp  : ARRAY OF BYTE;
    resplen   : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF dev  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libspi.SPI_transaction(dev^.fd, dev^.csfd, NIL, 0, 0, ADR(resp), resplen,
      error);
  END Read;

  PROCEDURE Write
   (dev       : Device;
    cmd       : ARRAY OF BYTE;
    cmdlen    : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF dev  = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libspi.SPI_transaction(dev^.fd, dev^.csfd, ADR(cmd), cmdlen, 0, NIL, 0,
      error);
  END Write;

  PROCEDURE fd(dev : Device) : INTEGER;

  BEGIN
    RETURN dev^.fd;
  END fd;

END SPI_libsimpleio.

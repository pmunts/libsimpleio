(* Raw HID services using libsimpleio *)

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

IMPLEMENTATION MODULE HID_libsimpleio;

  IMPORT
    Message64,
    errno,
    libhidraw,
    liblinux;

  FROM Storage IMPORT ALLOCATE, DEALLOCATE;

  TYPE
    DeviceRec = RECORD
      fd      : INTEGER;
      timeout : CARDINAL;
    END;

    Device = POINTER TO DeviceRec;

  (* Open raw HID device given vendor, product, and serial number  *)

  PROCEDURE Open
   (vendor    : CARDINAL;
    product   : CARDINAL;
    serial    : ARRAY OF CHAR;
    timeoutms : CARDINAL;
    VAR dev   : Device;
    VAR error : CARDINAL);

  VAR
    fd : INTEGER;

  BEGIN
    (* Validate parameters *)

    IF dev <> NIL THEN
      error := errno.EBUSY;
      RETURN;
    END;

    (* Open the raw HID device *)

    libhidraw.HIDRAW_open3(vendor, product, serial, fd, error);

    IF error <> 0 THEN
      RETURN;
    END;

    (* Create a new raw HID device object *)

    NEW(dev);
    dev^.fd := fd;
    dev^.timeout := timeoutms;
    error := errno.EOK;
  END Open;

  (* Close raw HID device *)

  PROCEDURE Close
   (VAR dev   : Device;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF dev = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    (* Close the raw HID device *)

    libhidraw.HIDRAW_close(dev^.fd, error);

    (* Destroy the raw HID device object *)

    DISPOSE(dev);
    dev := NIL;
  END Close;

  (* Get device name/info string *)

  PROCEDURE GetName
   (dev       : Device;
    VAR name  : ARRAY OF CHAR;
    length    : CARDINAL;
    VAR error : CARDINAL);

  BEGIN
    (* Validate parameters *)

    IF dev = NIL THEN
      error := errno.EBADF;
      RETURN;
    END;

    libhidraw.HIDRAW_get_name(dev^.fd, name, length, error);
  END GetName;

  (* Send 64-byte message to raw HID device *)

  PROCEDURE Send
   (dev       : Device;
    msg       : Message64.Message;
    VAR error : CARDINAL);

  VAR
    count : CARDINAL;

  BEGIN
    libhidraw.HIDRAW_send(dev^.fd, msg, Message64.MessageSize, count, error);

    IF (error = 0) AND (count <> Message64.MessageSize) THEN
      error := errno.EIO;
    END;
  END Send;

  (* Receive 64-byte message from raw HID device *)

  PROCEDURE Receive
   (dev       : Device;
    VAR msg   : Message64.Message;
    VAR error : CARDINAL);

  VAR
    files   : ARRAY [0 .. 0] OF INTEGER;
    events  : ARRAY [0 .. 0] OF CARDINAL;
    results : ARRAY [0 .. 0] OF CARDINAL;
    count : CARDINAL;

  BEGIN
    IF (dev^.timeout <> FOREVER) THEN
      files[0]   := dev^.fd;
      events[0]  := liblinux.POLLIN;
      results[0] := 0;

      liblinux.LINUX_poll(1, files, events, results, dev^.timeout, error);

      IF error <> 0 THEN
        RETURN;
      END;
    END;

    libhidraw.HIDRAW_receive(dev^.fd, msg, Message64.MessageSize, count, error);

    IF (error = 0) AND (count <> Message64.MessageSize) THEN
      error := errno.EIO;
    END;
  END Receive;

  (* Perform command/response transaction *)

  PROCEDURE Transaction
   (dev       : Device;
    cmd       : Message64.Message;
    VAR resp  : Message64.Message;
    VAR error : CARDINAL);

  BEGIN
    Send(dev, cmd, error);
    Receive(dev, resp, error);
  END Transaction;

  (* Retrieve the underlying Linux file descriptor *)

  PROCEDURE fd(dev : Device) : INTEGER;

  BEGIN
    RETURN dev^.fd;
  END fd;

END HID_libsimpleio.

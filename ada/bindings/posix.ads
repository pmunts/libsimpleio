-- Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH Interfaces.C;
WITH System;

PACKAGE Posix IS

  -- Direct bindings to Posix library functions

  TYPE ssize_t IS NEW Long_Integer;

  TYPE pollfd IS RECORD
    fd      : Interfaces.C.int;
    events  : Interfaces.C.short;
    revents : Interfaces.C.short;
  END RECORD;

  O_RDONLY : CONSTANT := 16#00000000#;
  O_WRONLY : CONSTANT := 16#00000001#;
  O_RDWR   : CONSTANT := 16#00000002#;
  O_CREAT  : CONSTANT := 16#00000200#;
  O_TRUNC  : CONSTANT := 16#00001000#;
  O_APPEND : CONSTANT := 16#00002000#;

  POLLIN   : CONSTANT := 16#0001#;
  POLLOUT  : CONSTANT := 16#0004#;
  POLLERR  : CONSTANT := 16#0008#;
  POLLHUP  : CONSTANT := 16#0010#;
  POLLNVAL : CONSTANT := 16#0020#;

  ETIMEOUT : CONSTANT := 100000;

  FUNCTION C_open
   (path      : Interfaces.C.char_array;
    flags     : Interfaces.C.int;
    mode      : Interfaces.C.int := 0) RETURN Interfaces.C.int;

  FUNCTION C_close(fd : Interfaces.C.int) RETURN Interfaces.C.int;

  FUNCTION C_read
   (fd        : Interfaces.C.int;
    src       : System.Address;
    len       : Interfaces.C.size_t) RETURN ssize_t;

  FUNCTION C_write
   (fd        : Interfaces.C.int;
    dst       : System.Address;
    len       : Interfaces.C.size_t) RETURN ssize_t;

  FUNCTION C_poll
   (fds       : System.Address;
    nfds      : Interfaces.C.int;
    timeoutms : Interfaces.C.int) RETURN Interfaces.C.int;

  PROCEDURE C_strerror_r
   (err       : Interfaces.C.int;
    dst       : IN OUT Interfaces.C.char_array;
    len       : Interfaces.C.size_t);

  FUNCTION C_errno RETURN Interfaces.C.int;

  PRAGMA Import(C, C_open,       "open");
  PRAGMA Import(C, C_close,      "close");
  PRAGMA Import(C, C_read,       "read");
  PRAGMA Import(C, C_write,      "write");
  PRAGMA Import(C, C_poll,       "poll");
  PRAGMA Import(C, C_errno,      "__get_errno"); -- From GNAT runtime library
  PRAGMA Import(C, C_strerror_r, "strerror_r");  -- __xpg_strerror_r for Linux

  -- Nicer Ada wrappers

  PROCEDURE Open
   (filename  : String;
    flags     : Natural;
    mode      : Natural;
    fd        : OUT Integer;
    error     : OUT Integer);

  PROCEDURE Open_Read
   (filename  : String;
    fd        : OUT Integer;
    error     : OUT Integer);

  PROCEDURE Open_Write
   (filename  : String;
    fd        : OUT Integer;
    error     : OUT Integer);

  PROCEDURE Open_ReadWrite
   (filename  : String;
    fd        : OUT Integer;
    error     : OUT Integer);

  PROCEDURE Close
   (fd        : Integer;
    error     : OUT Integer);

  PROCEDURE Read
   (fd        : Integer;
    buf       : System.Address;
    len       : Integer;
    count     : OUT Natural;
    error     : OUT Integer);

  PROCEDURE Write
   (fd        : Integer;
    buf       : System.Address;
    len       : Integer;
    count     : OUT Natural;
    error     : OUT Integer);

  TYPE fds_array    IS ARRAY (Positive RANGE <>) OF Natural;
  TYPE events_array IS ARRAY (Positive RANGE <>) OF Natural;

  PROCEDURE Poll
   (files     : fds_array;
    events    : events_array;
    revents   : OUT events_array;
    timeoutms : Natural;
    error     : OUT Integer);

  PROCEDURE Poll
   (fd        : Integer;
    events    : Natural;
    revents   : OUT Natural;
    timeoutms : Natural;
    error     : OUT Integer);

  PROCEDURE Poll
   (fd        : Integer;
    timeoutms : Natural;
    error     : OUT Integer);

  FUNCTION errno RETURN Integer;

  FUNCTION strerror(err : Integer) RETURN String;

END Posix;

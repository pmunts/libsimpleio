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

USE TYPE Interfaces.C.int;

PACKAGE BODY Posix IS

  PROCEDURE Open
   (filename : String;
    flags    : Natural;
    mode     : Natural;
    fd       : OUT Integer;
    error    : OUT Integer) IS

  BEGIN
    fd := Integer(C_open(Interfaces.C.To_C(filename), Interfaces.C.int(flags),
            Interfaces.C.int(mode)));

    IF fd < 0 THEN
      error := Posix.errno;
    ELSE
      error := 0;
    END IF;
  END Open;

  PROCEDURE Open_Read
   (filename : String;
    fd       : OUT Integer;
    error    : OUT Integer) IS

  BEGIN
    Open(filename, Posix.O_RDONLY, 0, fd, error);
  END Open_Read;

  PROCEDURE Open_Write
   (filename : String;
    fd       : OUT Integer;
    error    : OUT Integer) IS

  BEGIN
    Open(filename, Posix.O_WRONLY, 0, fd, error);
  END Open_Write;

  PROCEDURE Open_ReadWrite
   (filename : String;
    fd       : OUT Integer;
    error    : OUT Integer) IS

  BEGIN
    Open(filename, Posix.O_RDWR, 0, fd, error);
  END Open_ReadWrite;

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer) IS

  BEGIN
    IF C_close(Interfaces.C.int(fd)) = 0 THEN
      error := 0;
    ELSE
      error := errno;
    END IF;
  END Close;

  PROCEDURE Read
   (fd       : Integer;
    buf      : System.Address;
    len      : Integer;
    count    : OUT Natural;
    error    : OUT Integer) IS

    status : Posix.ssize_t;

  BEGIN
    status := C_read(Interfaces.C.int(fd), buf, Interfaces.C.size_t(len));

    IF status < 0 THEN
      count := 0;
      error := Posix.errno;
    ELSE
      count := Natural(status);
      error := 0;
    END IF;
  END Read;

  PROCEDURE Write
   (fd       : Integer;
    buf      : System.Address;
    len      : Integer;
    count    : OUT Natural;
    error    : OUT Integer) IS

    status : Posix.ssize_t;

  BEGIN
    status := C_write(Interfaces.C.int(fd), buf, Interfaces.C.size_t(len));

    IF status < 0 THEN
      count := 0;
      error := Posix.errno;
    ELSE
      count := Natural(status);
      error := 0;
    END IF;
  END Write;

  PROCEDURE Poll
   (files     : fds_array;
    events    : events_array;
    revents   : OUT events_array;
    timeoutms : Natural;
    error     : OUT Integer) IS

    pollfds : ARRAY (1 .. files'Length) OF Posix.pollfd;
    status  : Interfaces.C.int;

  BEGIN
    FOR i IN pollfds'Range LOOP
      pollfds(i).fd      := Interfaces.C.int(files(i));
      pollfds(i).events  := Interfaces.C.short(events(i));
      pollfds(i).revents := 0;
    END LOOP;

    status := Posix.C_poll(pollfds'Address, pollfds'Length, Interfaces.C.int(timeoutms));

    IF status < 0 THEN
      revents := (OTHERS => 0);
      error   := errno;
    ELSIF status = 0 THEN
      revents := (OTHERS => 0);
      error   := ETIMEOUT;
    ELSE
      FOR i IN pollfds'Range LOOP
        revents(i) := Natural(pollfds(i).revents);
      END LOOP;

      error := 0;
    END IF;
  END Poll;

  PROCEDURE Poll
   (fd        : Integer;
    events    : Natural;
    revents   : OUT Natural;
    timeoutms : Natural;
    error     : OUT Integer) IS

    pollfds : ARRAY (1 .. 1) OF Posix.pollfd;
    status  : Interfaces.C.int;

  BEGIN
    pollfds(1).fd      := Interfaces.C.int(fd);
    pollfds(1).events  := Interfaces.C.short(events);
    pollfds(1).revents := 0;

    status := Posix.C_poll(pollfds'Address, pollfds'Length, Interfaces.C.int(timeoutms));

    IF status < 0 THEN
      revents := 0;
      error   := errno;
    ELSIF status = 0 THEN
      revents := 0;
      error   := ETIMEOUT;
    ELSE
      revents := Natural(pollfds(1).revents);
      error   := 0;
    END IF;
  END Poll;

  PROCEDURE Poll
   (fd        : Integer;
    timeoutms : Natural;
    error     : OUT Integer) IS

    revents : Natural := 0;

  BEGIN
    Poll(fd, POLLIN, revents, timeoutms, error);
  END Poll;

  FUNCTION errno RETURN Integer IS

  BEGIN
    RETURN Integer(C_errno);
  END errno;

  FUNCTION strerror(err : Integer) RETURN String IS

    msg : Interfaces.C.char_array(0 .. 255);

  BEGIN
    C_strerror_r(Interfaces.C.int(err), msg, msg'Length);
    RETURN Interfaces.C.To_Ada(msg);
  END strerror;

END Posix;

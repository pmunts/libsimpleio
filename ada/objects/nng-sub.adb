-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Interfaces.C.Pointers;
WITH System;

PACKAGE BODY NNG.Sub IS

  PACKAGE BytePointers IS NEW Interfaces.C.Pointers(Natural, Messaging.Byte,
    Messaging.Buffer, 0);

  NNG_OPT_SUB_SUBSCRIBE : CONSTANT String := "sub:subscribe" & ASCII.Nul;

  NNG_FLAG_ALLOC : CONSTANT Interfaces.C.int := 1;

  FUNCTION nng_sub0_open(s : OUT nng_socket) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION nng_setopt
   (s     : nng_socket;
    what  : String;
    value : String;
    len   : Interfaces.C.size_t) RETURN Interfaces.C.int
    WITH IMPORT => True, Convention => C;

  FUNCTION nng_dial
   (s     : nng_socket;
    URL   : String;
    db    : System.Address   := System.Null_Address;
    flags : Interfaces.C.int := 0) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION nng_recv
   (s     : nng_socket;
    data  : OUT BytePointers.Pointer;
    size  : OUT Interfaces.C.size_t;
    flags : Interfaces.C.int := NNG_FLAG_ALLOC) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  PROCEDURE nng_free
   (data  : BytePointers.Pointer;
    size  : Interfaces.C.size_t)
    WITH Import => True, Convention => C;

  -- Initialize a client object instance

  PROCEDURE Initialize
   (Self  : OUT Client;
    URL   : String;
    topic : String := ALL_TOPICS) IS

  BEGIN
    ErrorCheck(nng_sub0_open(Self.socket));
    ErrorCheck(nng_setopt(Self.socket,  NNG_OPT_SUB_SUBSCRIBE,
      topic & ASCII.Nul, topic'Length));
    ErrorCheck(nng_dial(Self.socket, URL & ASCII.Nul));
  END Initialize;

  -- Get a text message

  FUNCTION Get(Self : Client) RETURN String IS

    bufptr : BytePointers.Pointer;
    count  : Interfaces.C.size_t;

  BEGIN
    ErrorCheck(nng_recv(Self.socket, bufptr, count));

    DECLARE
      buf : Messaging.Buffer := BytePointers.Value(bufptr, Interfaces.C.ptrdiff_t(count));
      s   : String(1 .. Positive(count));
    BEGIN
      FOR i IN s'Range LOOP
        s(i) := Character'Val(buf(i-1));
      END LOOP;

      nng_free(bufptr, count);

      RETURN s;
    END;
  END Get;

  -- Get a binary message

  PROCEDURE Get
   (Self    : Client;
    buf     : OUT Messaging.Buffer;
    bufsize : Positive;
    len     : OUT Positive) IS

    bufptr : BytePointers.Pointer;
    count  : Interfaces.C.size_t;

  BEGIN
    ErrorCheck(nng_recv(Self.socket, bufptr, count));
    buf := BytePointers.Value(bufptr, Interfaces.C.ptrdiff_t(count));
    len := Positive(count);
    nng_free(bufptr, count);
  END Get;

END NNG.Sub;

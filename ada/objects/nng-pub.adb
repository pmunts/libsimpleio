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

WITH System;

PACKAGE BODY NNG.Pub IS

  FUNCTION nng_pub0_open
   (s : OUT nng_socket) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION nng_listen
   (s     : nng_socket;
    URL   : String;
    lp    : System.Address   := System.Null_Address;
    flags : Interfaces.C.int := 0) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION nng_send
   (s     : nng_socket;
    data  : Messaging.Buffer;
    size  : Interfaces.C.size_t;
    flags : Interfaces.C.int := 0) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  -- Initialize a server object instance

  PROCEDURE Initialize(Self : OUT Server; URL : String) IS

  BEGIN
    ErrorCheck(nng_pub0_open(Self.socket));
    ErrorCheck(nng_listen(Self.socket, URL & ASCII.Nul));
  END Initialize;

  -- Put a text message

  PROCEDURE Put(Self : Server ; s : String) IS

    outbuf : Messaging.Buffer(s'Range);

  BEGIN
    FOR i IN s'Range LOOP
      outbuf(i) := Character'Pos(s(i));
    END LOOP;

    Self.Put(outbuf, outbuf'Length);
  END Put;

  -- Put a binary message

  PROCEDURE Put(Self : Server; outbuf : Messaging.Buffer; len : Positive) IS

  BEGIN
    ErrorCheck(nng_send(Self.socket, outbuf, Interfaces.C.size_t(len)));
  END Put;

END NNG.Pub;

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces.C;
WITH Interfaces.C.Strings;
WITH System;

PACKAGE libzmq IS
  PRAGMA Link_With("-lzmq");

  -- Direct binding to C functions in libzmq

  TYPE zmq_poller_event_t IS RECORD
    socket : System.Address;
    fd     : Interfaces.C.int;
    data   : System.Address;
    events : Interfaces.C.short;
  END RECORD WITH Convention => C;

  FUNCTION zmq_ctx_new RETURN System.Address
    WITH Import => True, Convention => C;

  FUNCTION zmq_ctx_destroy
   (ctx        : System.Address) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_socket
   (ctx        : System.Address;
    SocketType : Interfaces.C.int) RETURN System.Address
    WITH Import => True, Convention => C;

  FUNCTION zmq_bind
   (socket     : System.Address;
    endpoint   : String) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_connect
   (socket     : System.Address;
    endpoint   : String) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_close
   (socket : System.Address) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_recv
   (socket : System.Address;
    buf    : System.Address;
    len    : Interfaces.C.size_t;
    flags  : Interfaces.C.int) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_send
   (socket : System.Address;
    buf    : System.Address;
    len    : Interfaces.C.size_t;
    flags  : Interfaces.C.int) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_poller_new RETURN System.Address
    WITH Import => True, Convention => C;

  FUNCTION zmq_poller_destroy
   (poller : System.Address) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_poller_add
   (poller : System.Address;
    socket : System.Address;
    data   : System.Address;
    events : Interfaces.C.short) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION zmq_poller_wait
   (poller  : System.Address;
    event   : IN OUT zmq_poller_event_t;
    timeout : Interfaces.C.long) RETURN Interfaces.C.Int
    WITH Import => True, Convention => C;

  FUNCTION zmq_strerror
   (errnum  : Interfaces.C.Int) RETURN Interfaces.C.Strings.chars_ptr
    WITH Import => True, Convention => C;

END libzmq;

-- ZeroMQ (https://zeromq.org) Messaging Services

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
WITH System;

WITH libzmq;

USE TYPE Interfaces.C.int;
USE TYPE System.Address;

PACKAGE BODY ZeroMQ IS

  -- Initialize an existing ZeroMQ context object

  PROCEDURE Initialize(ctx : IN OUT Context) IS

  BEGIN
    IF ctx.addr /= System.Null_Address THEN
      ctx.Destroy;
    END IF;

    ctx.addr := libzmq.zmq_ctx_new;

    IF ctx.addr = System.Null_Address THEN
      RAISE Error WITH "zmq_ctx_new() failed, " & libzmq.strerror;
    END IF;
  END Initialize;

  -- Destroy an existing ZeroMQ context object

  PROCEDURE Finalize(ctx : IN OUT Context) IS

  BEGIN
    IF ctx.addr = System.Null_Address THEN
      RETURN;
    END IF;

    IF libzmq.zmq_ctx_term(ctx.addr) /= 0 THEN
      RAISE Error WITH "zmq_ctx_term() failed, " & libzmq.strerror;
    END IF;

    ctx.addr := System.Null_Address;
  END Finalize;

END ZeroMQ;

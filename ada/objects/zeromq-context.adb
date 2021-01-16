-- ZeroMQ (https://zeromq.org) Messaging Services

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

WITH Interfaces.C;
WITH System;

WITH libzmq;

USE TYPE Interfaces.C.int;
USE TYPE System.Address;

PACKAGE BODY ZeroMQ.Context IS

  -- Initialize an existing ZeroMQ context object

  PROCEDURE Initialize(Self : IN OUT Context) IS

  BEGIN
    IF Self /= Null_Context THEN
      Self.Destroy;
    END IF;

    Self.addr := libzmq.zmq_ctx_new;

    IF Self = Null_Context THEN
      RAISE Error WITH "zmq_ctx_new() failed, " & libzmq.strerror;
    END IF;
  END Initialize;

  -- Destroy an existing ZeroMQ context object

  PROCEDURE Destroy(Self : IN OUT Context) IS

  BEGIN
    IF Self = Null_Context THEN
      RETURN;
    END IF;

    IF libzmq.zmq_ctx_term(Self.addr) /= 0 THEN
      RAISE Error WITH "zmq_ctx_term() failed, " & libzmq.strerror;
    END IF;

    Self := Null_Context;
  END Destroy;

  -- Fetch underlying ZeroMQ context pointer

  FUNCTION Pointer(Self : Context) RETURN System.Address IS

  BEGIN
    RETURN Self.addr;
  END;

  -- Accessors for the private default context object

  Default_Context : Context;

  PROCEDURE Initialize IS

  BEGIN
    Default_Context.Initialize;
  END Initialize;

  PROCEDURE Destroy IS

  BEGIN
    Default_Context.Destroy;
  END Destroy;

  FUNCTION Default RETURN Context IS

  BEGIN
    RETURN Default_Context;
  END Default;

BEGIN
  Default_Context.Initialize;
END ZeroMQ.Context;

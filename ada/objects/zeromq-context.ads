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

WITH System;

PACKAGE ZeroMQ.Context IS

  TYPE Context IS TAGGED PRIVATE;

  Null_Context : CONSTANT Context;

  -- Initialize a ZeroMQ context object

  PROCEDURE Initialize(Self : IN OUT Context);

  -- Destroy a ZeroMQ context object

  PROCEDURE Destroy(Self : IN OUT Context);

  -- Fetch underlying ZeroMQ context pointer

  FUNCTION Pointer(Self : Context) RETURN System.Address;

  -- Accessors for the private default context object

  PROCEDURE Initialize;

  PROCEDURE Destroy;

  FUNCTION Default RETURN Context;

PRIVATE

  TYPE Context IS TAGGED RECORD
    addr : System.Address := System.Null_Address;
  END RECORD;

  Null_Context : CONSTANT Context := Context'(addr => System.Null_Address);

END ZeroMQ.Context;

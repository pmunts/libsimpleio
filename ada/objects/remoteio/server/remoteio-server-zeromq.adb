-- Remote I/O Server Services using Message64.ZMQ transport

-- Copyright (C)2020-2023, Philip Munts.
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

WITH Message64.ZMQ;
WITH RemoteIO.Server.Message64;
WITH ZeroMQ.Sockets;
WITH libLinux;

PACKAGE BODY RemoteIO.Server.ZeroMQ IS

  FUNCTION Create
   (exec      : NOT NULL RemoteIO.Executive.Executor;
    name      : String;
    ctx       : Standard.ZeroMQ.Context.Context := Standard.ZeroMQ.Context.Default;
    addr      : String   := "*";
    port      : Positive := 8088;
    timeoutms : Natural  := 1000) RETURN Instance IS

    s      : Standard.ZeroMQ.Sockets.Socket;
    m      : Standard.Message64.Messenger;
    status : Integer;
    error  : Integer;

  BEGIN
    s := Standard.ZeroMQ.Sockets.Create(ctx, Standard.ZeroMQ.Sockets.Rep, timeoutms);

    s.Bind(Standard.ZeroMQ.Sockets.To_Endpoint(addr, port));

    m := Standard.Message64.ZMQ.Create(s);

    libLinux.Command("iptables -A INPUT -p tcp -m conntrack --ctstate NEW " &
      "--dport" & Positive'Image(port) & " -j ACCEPT" & ASCII.NUL, status, error);

    RETURN RemoteIO.Server.Message64.Create(exec, name, m);
  END Create;

END RemoteIO.Server.ZeroMQ;

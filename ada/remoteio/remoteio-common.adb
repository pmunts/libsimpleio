-- Remote I/O Server Dispatcher for common commands

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH errno;
WITH Message64;
WITH RemoteIO.Server;

USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.Common IS

  FUNCTION Create
   (executor     : IN OUT RemoteIO.Executive.Executor;
    version      : RemoteIO.Server.ResponseString;
    capabilities : RemoteIO.Server.ResponseString)
    RETURN DispatcherSubclass IS

    Self : ACCESS DispatcherSubclass;

  BEGIN
    Self := NEW DispatcherSubclass'(version, capabilities);

    executor.Register(LOOPBACK_REQUEST, Self);
    executor.Register(VERSION_REQUEST, Self);
    executor.Register(CAPABILITY_REQUEST, Self);

    RETURN Self.ALL;
  END Create;

  PROCEDURE Dispatch
   (Self : DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

  BEGIN
    CASE MessageTypes'Val(cmd(0)) IS
      WHEN LOOPBACK_REQUEST =>
        resp(0) := cmd(0) + 1;
        resp(1) := cmd(1);
        resp(2) := 0;
        resp(3 .. 63) := cmd(2 .. 62);

      WHEN VERSION_REQUEST =>
        resp(0) := cmd(0) + 1;
        resp(1) := cmd(1);
        resp(2) := 0;

        FOR i IN RemoteIO.Server.ResponseString'Range LOOP
          resp(i + 2) := Character'Pos(Self.version(i));
        END LOOP;

      WHEN CAPABILITY_REQUEST =>
        resp(0) := cmd(0) + 1;
        resp(1) := cmd(1);
        resp(2) := 0;

        FOR i IN RemoteIO.Server.ResponseString'Range LOOP
          resp(i + 2) := Character'Pos(Self.capabilities(i));
        END LOOP;

      WHEN OTHERS =>
        NULL;
    END CASE;
  END Dispatch;

END RemoteIO.Common;

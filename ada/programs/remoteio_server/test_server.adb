-- Minimal Remote I/O Device Server

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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Strings.Fixed;

WITH Message64.libsimpleio;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

PROCEDURE test_server IS

  title : CONSTANT String := "Minimal Remote I/O Device Server";

  vers  : RemoteIO.Server.ResponseString;
  caps  : RemoteIO.Server.ResponseString;
  msg   : Message64.Messenger;
  exec  : RemoteIO.Executive.Executor;
  serv  : RemoteIO.Server.Device;

BEGIN
  New_Line;
  Put_Line(title);
  New_Line;

  Ada.Strings.Fixed.Move(title, vers, Pad => ASCII.NUL);
  Ada.Strings.Fixed.Move("NONE", caps, Pad => ASCII.NUL);

  msg  := Message64.libsimpleio.Create("/dev/hidg0", 0);
  exec := RemoteIO.Executive.Create;
  serv := RemoteIO.Server.Create(msg, vers, caps, exec);
END test_server;

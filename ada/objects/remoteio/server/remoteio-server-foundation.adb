-- Foundation for a Remote I/O Server

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

WITH Ada.Strings.Fixed;

WITH libLinux;
WITH Logging.libsimpleio;
WITH RemoteIO.Common;
WITH RemoteIO.Server;

PACKAGE BODY RemoteIO.Server.Foundation IS
  PRAGMA Warnings(Off, "variable ""disp"" is assigned but never read");

  -- Persistent variables

  exec : RemoteIO.Executive.Executor;
  disp : RemoteIO.Common.Dispatcher;

  PROCEDURE Initialize(title : String; capabilities : String) IS

    error  : Integer;
    vers   : RemoteIO.Server.ResponseString;
    caps   : RemoteIO.Server.ResponseString;

  BEGIN
    PRAGMA Warnings(Off, """error"" modified by call, but value overwritten *");

    libLinux.OpenLog(title, liblinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR, libLinux.LOG_DAEMON, error);

    -- Switch to background execution

    libLinux.Detach(error);

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Detach() failed", error);
      RETURN;
    END IF;

    -- Pad response strings

    Ada.Strings.Fixed.Move(title, vers, Pad => ASCII.NUL);
    Ada.Strings.Fixed.Move(capabilities, caps, Pad => ASCII.NUL);

    -- Create an Executor instance

    exec := RemoteIO.Executive.Create;

    -- Create a common command dispatcher instance

    disp := RemoteIO.Common.Create(exec, vers, caps);
  END Initialize;

  FUNCTION Executor RETURN Remoteio.Executive.Executor IS

  BEGIN
    RETURN exec;
  END Executor;

END RemoteIO.Server.Foundation;

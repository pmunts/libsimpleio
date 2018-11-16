-- Foundation for a Remote I/O Server for UDP and USB Gadget Services

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

WITH Ada.Directories;
WITH Ada.Strings.Fixed;

WITH errno;
WITH libLinux;
WITH libSerial;
WITH Logging.libsimpleio;
WITH Message64.Datagram;
WITH Message64.Stream;
WITH Message64.UDP;
WITH RemoteIO.Executive;
WITH RemoteIO.Common;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Server.UDP;

PACKAGE BODY RemoteIO.Server.Foundation IS

  -- Filename constants

  Gadget_Device_HID    : CONSTANT String := "/dev/hidg0";
  Gadget_Device_Serial : CONSTANT String := "/dev/ttyGS0";

  log   : CONSTANT Logging.Logger := Logging.libsimpleio.Create;
  vers  : RemoteIO.Server.ResponseString;
  caps  : RemoteIO.Server.ResponseString;
  exec  : RemoteIO.Executive.Executor;
  comm  : RemoteIO.Common.Dispatcher;
  fd    : Integer;
  error : Integer;
  msg1  : Message64.Messenger;
  serv1 : RemoteIO.Server.Device;
  msg2  : Message64.UDP.Messenger;
  serv2 : RemoteIO.Server.UDP.Device;

  PROCEDURE Start
   (title        : String;
    capabilities : String) IS

  BEGIN
    logger.Note(title);

    -- Switch to background execution

    libLinux.Detach(error);

    IF error /= 0 THEN
      logger.Error("libLinux.Detach() failed", error);
      RETURN;
    END IF;

    -- Pad response strings

    Ada.Strings.Fixed.Move(title, vers, Pad => ASCII.NUL);
    Ada.Strings.Fixed.Move(capabilities, caps, Pad => ASCII.NUL);

    -- Create an Executor instance

    exec := RemoteIO.Executive.Create;

    -- Create a common command dispatcher instance

    comm := RemoteIO.Common.Create(logger, exec, vers, caps);

    -- Try to create a Message64.Messenger instance

    IF Ada.Directories.Exists(Gadget_Device_HID) THEN
      -- Open USB raw HID gadget device

      libLinux.Open(Gadget_Device_HID & ASCII.NUL, fd, error);

      IF error /= 0 THEN
        logger.Error("libLinux.Open() for " & Gadget_Device_HID & " failed",
          error);
        RETURN;
      END IF;

      msg1  := Message64.Datagram.Create(fd);
      serv1 := RemoteIO.Server.Create("USB Raw HID Gadget", msg1, exec, logger);
    ELSIF Ada.Directories.Exists(Gadget_Device_Serial) THEN
      -- Open USB serial gadget device

      libSerial.Open(Gadget_Device_Serial & ASCII.NUL, 115200, 0, 8, 1, fd, error);

      IF error /= 0 THEN
        logger.Error("libSerial.Open() for " & Gadget_Device_Serial & " failed",
          error);
        RETURN;
      END IF;

      msg1  := Message64.Stream.Create(fd);
      serv1 := RemoteIO.Server.Create("USB Serial Port Gadget", msg1, exec, logger);
    END IF;

    -- Start UDP server

    msg2  := Message64.UDP.Create_Server(port => 8087, timeoutms => 0);
    serv2 := RemoteIO.Server.UDP.Create("UDP", msg2, exec, logger);
  END Start;

  FUNCTION Logger RETURN Logging.Logger IS

  BEGIN
    RETURN log;
  END Logger;

  FUNCTION Executor RETURN Remoteio.Executive.Executor IS

  BEGIN
    RETURN exec;
  END Executor;

END RemoteIO.Server.Foundation;

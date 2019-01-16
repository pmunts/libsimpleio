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

WITH libLinux;
WITH libSerial;
WITH Logging.libsimpleio;
WITH Message64.Datagram;
WITH Message64.Stream;
WITH Message64.UDP;
WITH RemoteIO.Common;
WITH RemoteIO.Server.UDP;

PACKAGE BODY RemoteIO.Server.Foundation IS

  -- Filename constants

  Gadget_Device_HID    : CONSTANT String := "/dev/hidg0";
  Gadget_Device_Serial : CONSTANT String := "/dev/ttyGS0";

  -- Persistent variables

  log   : CONSTANT Logging.Logger := Logging.libsimpleio.Create;
  exec  : RemoteIO.Executive.Executor;
  comm  : RemoteIO.Common.Dispatcher;
  msgH  : Message64.Messenger;
  msgS  : Message64.Messenger;
  msgU  : Message64.UDP.Messenger;
  servH : RemoteIO.Server.Device;
  servS : RemoteIO.Server.Device;
  servU : RemoteIO.Server.UDP.Device;

  PROCEDURE Start
   (title        : String;
    capabilities : String;
    EnableHID    : Boolean := True;
    EnableSerial : Boolean := True;
    EnableUDP    : Boolean := True) IS

    error  : Integer;
    vers   : RemoteIO.Server.ResponseString;
    caps   : RemoteIO.Server.ResponseString;
    fd     : Integer;
    status : Integer;

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

    exec := RemoteIO.Executive.Create(logger);

    -- Create a common command dispatcher instance

    comm := RemoteIO.Common.Create(logger, exec, vers, caps);

    -- USB Raw HID Gadget Server

    IF EnableHID AND Ada.Directories.Exists(Gadget_Device_HID) THEN
      libLinux.Open(Gadget_Device_HID & ASCII.NUL, fd, error);

      IF error /= 0 THEN
        logger.Error("libLinux.Open() for " & Gadget_Device_HID & " failed",
          error);
        RETURN;
      END IF;

      msgH  := Message64.Datagram.Create(fd);
      servH := RemoteIO.Server.Create("USB Raw HID Gadget", msgH, exec, logger);
    END IF;

    -- USB Serial Port Gadget Server, using Stream Framing Protocol

    IF EnableSerial AND Ada.Directories.Exists(Gadget_Device_Serial) THEN
      libSerial.Open(Gadget_Device_Serial & ASCII.NUL, 115200, 0, 8, 1, fd, error);

      IF error /= 0 THEN
        logger.Error("libSerial.Open() for " & Gadget_Device_Serial & " failed",
          error);
        RETURN;
      END IF;

      msgS  := Message64.Stream.Create(fd);
      servS := RemoteIO.Server.Create("USB Serial Port Gadget", msgS, exec, logger);
    END IF;

    -- UDP Server

    IF EnableUDP THEN
      msgU  := Message64.UDP.Create_Server(port => 8087, timeoutms => 0);
      servU := RemoteIO.Server.UDP.Create("UDP", msgU, exec, logger);

      libLinux.Command("iptables -A INPUT -p udp -m conntrack --ctstate NEW --dport 8087 -j ACCEPT",
        status, error);
    END IF;
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

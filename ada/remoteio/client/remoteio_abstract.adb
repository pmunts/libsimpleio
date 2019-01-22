-- Abstract device services using the Remote I/O Protocol

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH Message64;

USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO_Abstract IS

  -- Abstract device object constructor

  FUNCTION Create
   (remdev  : RemoteIO.Client.Device;
    channel : RemoteIO.ChannelNumber) RETURN Device IS

    dev : Device := NEW DeviceClass'(remdev, channel);

  BEGIN
    RETURN dev;
  END Create;

  -- Get abstract device information string

  FUNCTION GetInfo
   (Self    : IN OUT DeviceClass) RETURN String IS

    rcmd  : Message64.Message;
    rresp : Message64.Message;
    info  : String(1 .. 61);

  BEGIN
    rcmd := (OTHERS => 0);
    rcmd(0) := Message64.Byte(RemoteIO.MessageTypes'Pos(
      RemoteIO.DEVICE_INFO_REQUEST));
    rcmd(2) := Message64.Byte(Self.channel);

    Self.remdev.Transaction(rcmd, rresp);

    info := (OTHERS => ' ');

    FOR i IN info'Range LOOP
      EXIT WHEN rresp(2 + i) = 0;
      info(i) := Character'Val(rresp(2 + i));
    END LOOP;

    RETURN Ada.Strings.Fixed.Trim(info, Ada.Strings.Right);
  END GetInfo;

  -- Perform abstract device operation

  PROCEDURE Operation
   (Self    : DeviceClass;
    cmd     : Command;
    resp    : OUT Response) IS

    rcmd  : Message64.Message;
    rresp : Message64.Message;

  BEGIN
    rcmd := (OTHERS => 0);
    rcmd(0) := Message64.Byte(RemoteIO.MessageTypes'Pos(
      RemoteIO.DEVICE_OPERATION_REQUEST));
    rcmd(2) := Message64.Byte(Self.channel);

    FOR i IN cmd'Range LOOP
      rcmd(i) := Message64.Byte(cmd(i));
    END LOOP;

    Self.remdev.Transaction(rcmd, rresp);

    FOR i in resp'Range LOOP
      resp(i) := Byte(rresp(i));
    END LOOP;
  END Operation;

END RemoteIO_Abstract;

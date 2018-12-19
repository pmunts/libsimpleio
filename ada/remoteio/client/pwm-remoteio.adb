-- PWM output services using the Remote I/O Protocol

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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
WITH Messaging;
WITH Message64;
WITH RemoteIO.Client;

USE TYPE Message64.Byte;

PACKAGE BODY PWM.RemoteIO IS

  TYPE Unsigned32 IS MOD 2**32;

  -- PWM output pin object constructor

  FUNCTION Create
   (dev  : Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber) RETURN PWM.Interfaces.Output IS

    cmd         : Message64.Message;
    resp        : Message64.Message;
    resolution  : Positive;
    scalefactor : PWM.DutyCycle;

  BEGIN

    -- Configure the PWM output channel

    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_CONFIGURE_REQUEST));
    cmd(2) := Message64.Byte(num);

    dev.Transaction(cmd, resp);

    resolution  := Positive(resp(3));
    scalefactor := (2.0**resolution - 1.0)/100.0;

    RETURN NEW OutputSubclass'(dev, num, resolution, scalefactor);
  END Create;

  -- Write PWM output pin

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    duty : PWM.DutyCycle) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

    data : Unsigned32;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_WRITE_REQUEST));
    cmd(2) := Message64.Byte(Self.num);

    data := Unsigned32(duty*Self.scalefactor);
    
    cmd(3) := Message64.Byte(data / 2**24);
    cmd(4) := Message64.Byte(data / 2**16 MOD 2**8);
    cmd(5) := Message64.Byte(data / 2**8 MOD 2**8);
    cmd(6) := Message64.Byte(data MOD 2**8);

    Self.dev.Transaction(cmd, resp);
  END Put;

  -- Retrieve the PWM output resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive IS

  BEGIN
    RETURN Self.resolution;
  END GetResolution;

END PWM.RemoteIO;

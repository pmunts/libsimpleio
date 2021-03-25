-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces.C.Strings;
WITH RemoteIO.Client;

PRIVATE WITH Ada.Strings.Unbounded;

PACKAGE libRemoteIO IS

  TYPE ChannelArray IS ARRAY (RemoteIO.ChannelNumber) OF Boolean;

  -- errno values

  EOK    : CONSTANT := 0;
  EIO    : CONSTANT := 5;
  ENOMEM : CONSTANT := 12;
  ENODEV : CONSTANT := 19;
  EINVAL : CONSTANT := 22;

  -- Open a connection to a USB Raw HID Remote I/O Protocol Server

  PROCEDURE Open
   (VID       : Interfaces.C.int;
    PID       : Interfaces.C.int;
    serial    : Interfaces.C.Strings.chars_ptr;
    timeout   : Interfaces.C.int;
    handle    : OUT Interfaces.C.int;
    error     : OUT Interfaces.C.int);

PRIVATE

  TYPE AdapterItem IS RECORD
    dev           : RemoteIO.Client.Device := Null;
    version       : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    capability    : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    ADC_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    DAC_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    GPIO_channels : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    I2C_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    PWM_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    SPI_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
  END RECORD;

  SUBTYPE AdapterRange IS Interfaces.C.int RANGE 0 .. 15;

  AdapterTable : ARRAY (AdapterRange) OF AdapterItem;

  PRAGMA Export(Convention => C, Entity => Open, External_Name => "open");

END libRemoteIO;

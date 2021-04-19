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
WITH Message64;
WITH RemoteIO.Client;

PRIVATE WITH Ada.Strings.Unbounded;

PACKAGE libRemoteIO IS

  TYPE ChannelArray IS ARRAY (RemoteIO.ChannelNumber) OF Boolean;
  TYPE PeriodArray  IS ARRAY (RemoteIO.ChannelNumber) OF Integer;

  -- errno values

  EOK    : CONSTANT := 0;
  EIO    : CONSTANT := 5;
  ENOMEM : CONSTANT := 12;
  ENODEV : CONSTANT := 19;
  EINVAL : CONSTANT := 22;

  -- Open a connection to a USB Raw HID Remote I/O Protocol Server

  PROCEDURE OpenHID
   (VID      : Integer;
    PID      : Integer;
    serial   : Interfaces.C.Strings.chars_ptr;
    timeout  : Integer;
    handle   : OUT Integer;
    error    : OUT Integer);

  -- Open a connection to a serial port Remote I/O Protocol Server

  PROCEDURE OpenSerial
   (portname : Interfaces.C.Strings.chars_ptr;
    baudrate : Integer;
    timeout  : Integer;
    handle   : OUT Integer;
    error    : OUT Integer);

  -- Open a connection to a UDP Remote I/O Protocol Server

  PROCEDURE OpenUDP
   (server   : Interfaces.C.Strings.chars_ptr;
    port     : Integer;
    timeout  : Integer;
    handle   : OUT Integer;
    error    : OUT Integer);

  -- Send a 64-byte message (aka report) to a USB Raw HID device.

  PROCEDURE Send
   (handle   : Integer;
    cmd      : IN Message64.Message;
    error    : OUT Integer);

  -- Receive a 64-byte message (aka report) from a USB Raw HID device.

  PROCEDURE Receive
   (handle   : Integer;
    resp     : OUT Message64.Message;
    error    : OUT Integer);

  -- Fetch the version information string

  PROCEDURE GetVersion
   (handle   : Integer;
    buf      : OUT String;
    bufsize  : Integer;
    error    : OUT Integer);

  -- Fetch the capability string

  PROCEDURE GetCapability
   (handle   : Integer;
    buf      : OUT String;
    bufsize  : Integer;
    error    : OUT Integer);

PRIVATE

  -- This record contains all of the persistent state necessary for each
  -- Remote I/O Protocol adapter.

  TYPE AdapterItem IS RECORD
    dev           : RemoteIO.Client.Device := Null;
    version       : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    capability    : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
    ADC_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    ADC_config    : ChannelArray := (OTHERS => False);
    DAC_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    DAC_config    : ChannelArray := (OTHERS => False);
    GPIO_channels : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    GPIO_config   : ChannelArray := (OTHERS => False);
    I2C_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    I2C_config    : ChannelArray := (OTHERS => False);
    PWM_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    PWM_config    : ChannelArray := (OTHERS => False);
    PWM_periods   : PeriodArray  := (OTHERS => 0);
    SPI_channels  : RemoteIO.ChannelSets.Set := RemoteIO.ChannelSets.Empty_Set;
    SPI_config    : ChannelArray := (OTHERS => False);
  END RECORD;

  SUBTYPE AdapterRange IS Natural RANGE 0 .. 15;

  AdapterTable : ARRAY (AdapterRange) OF AdapterItem;

  PRAGMA Export(Convention => C, Entity => OpenHID,       External_Name => "open_hid");
  PRAGMA Export(Convention => C, Entity => OpenSerial,    External_Name => "open_serial");
  PRAGMA Export(Convention => C, Entity => OpenUDP,       External_Name => "open_udp");
  PRAGMA Export(Convention => C, Entity => Send,          External_Name => "send");
  PRAGMA Export(Convention => C, Entity => Receive,       External_Name => "receive");
  PRAGMA Export(Convention => C, Entity => GetVersion,    External_Name => "get_version");
  PRAGMA Export(Convention => C, Entity => GetCapability, External_Name => "get_capability");

END libRemoteIO;

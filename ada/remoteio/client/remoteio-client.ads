-- Remote I/O Client Services using Message64 transport (e.g. raw HID)

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

WITH Analog;
WITH GPIO;
WITH I2C;
WITH Message64;
WITH PWM;
WITH SPI;

PACKAGE RemoteIO.Client IS

  -- Define a tagged type for remote I/O server devices

  TYPE DeviceClass IS TAGGED PRIVATE;

  -- Define an access type compatible with any subclass implementing
  -- DeviceClass

  TYPE Device IS ACCESS ALL DeviceClass'Class;

  -- Constructors

  FUNCTION Create(msg : Message64.Messenger) RETURN Device;

  -- Perform a Remote I/O operation

  PROCEDURE Transaction
   (Self : IN OUT DeviceClass;
    cmd  : IN OUT Message64.Message;
    resp : OUT Message64.Message);

  -- Get the remote device version string

  FUNCTION GetVersion(Self : IN OUT DeviceClass) RETURN String;

  -- Get the remote device capability string

  FUNCTION GetCapability(Self : IN OUT DeviceClass) RETURN String;

  -- Get the available channels for a given service type

  FUNCTION GetAvailableChannels
   (Self    : IN OUT DeviceClass;
    service : ChannelTypes) RETURN ChannelSets.Set;

  -- I/O object constructors, provided for convenience

  FUNCTION Create
   (Self  : IN OUT DeviceClass;
    num   : ChannelNumber) RETURN Analog.Input;

  FUNCTION Create
   (Self  : IN OUT DeviceClass;
    num   : ChannelNumber) RETURN Analog.Output;

  FUNCTION Create
   (Self  : IN OUT DeviceClass;
    num   : ChannelNumber;
    dir   : GPIO.Direction;
    state : Boolean := False) RETURN GPIO.Pin;

  FUNCTION Create
   (Self  : IN OUT DeviceClass;
    num   : ChannelNumber;
    speed : Positive := I2C.SpeedStandard) RETURN I2C.Bus;

  FUNCTION Create
   (Self  : IN OUT DeviceClass;
    num   : ChannelNumber;
    freq  : Positive := 50;
    duty  : PWM.DutyCycle := PWM.MinimumDutyCycle) RETURN PWM.Interfaces.Output;

  FUNCTION Create
   (Self     : IN OUT DeviceClass;
    num      : Standard.RemoteIO.ChannelNumber;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural) RETURN SPI.Device;

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    msg : Message64.Messenger;
    num : Message64.Byte;
  END RECORD;

END RemoteIO.Client;

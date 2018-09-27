-- Remote I/O Services using Message64 transport (e.g. raw HID)

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

WITH Ada.Containers.Ordered_Sets;
WITH Message64;

PACKAGE RemoteIO IS

  RemoteIO_Error : EXCEPTION;

  TYPE ChannelTypes IS
   (ADC,
    GPIO,
    I2C,
    SPI);

  TYPE MessageTypes IS
   (LOOPBACK_REQUEST,
    LOOPBACK_RESPONSE,
    VERSION_REQUEST,
    VERSION_RESPONSE,
    CAPABILITY_REQUEST,
    CAPABILITY_RESPONSE,
    GPIO_PRESENT_REQUEST,
    GPIO_PRESENT_RESPONSE,
    GPIO_CONFIGURE_REQUEST,
    GPIO_CONFIGURE_RESPONSE,
    GPIO_READ_REQUEST,
    GPIO_READ_RESPONSE,
    GPIO_WRITE_REQUEST,
    GPIO_WRITE_RESPONSE,
    I2C_PRESENT_REQUEST,
    I2C_PRESENT_RESPONSE,
    I2C_CONFIGURE_REQUEST,
    I2C_CONFIGURE_RESPONSE,
    I2C_TRANSACTION_REQUEST,
    I2C_TRANSACTION_RESPONSE,
    SPI_PRESENT_REQUEST,
    SPI_PRESENT_RESPONSE,
    SPI_CONFIGURE_REQUEST,
    SPI_CONFIGURE_RESPONSE,
    SPI_TRANSACTION_REQUEST,
    SPI_TRANSACTION_RESPONSE,
    ADC_PRESENT_REQUEST,
    ADC_PRESENT_RESPONSE,
    ADC_CONFIGURE_REQUEST,
    ADC_CONFIGURE_RESPONSE,
    ADC_READ_REQUEST,
    ADC_READ_RESPONSE);

  SUBTYPE ChannelNumber IS Natural RANGE 0 .. 127;

  PACKAGE ChannelSets IS NEW Ada.Containers.Ordered_Sets(ChannelNumber);

  -- Define a tagged type for remote I/O devices

  TYPE DeviceRecord IS TAGGED PRIVATE;

  -- Define an access type compatible with any subclass implementing
  -- DeviceRecord

  TYPE Device IS ACCESS ALL DeviceRecord'Class;

  -- Constructors

  FUNCTION Create(msg : Message64.Messenger) RETURN Device;

  PROCEDURE Transaction
   (self : IN OUT DeviceRecord;
    cmd  : IN OUT Message64.Message;
    resp : OUT Message64.Message);

  -- Get the remote device version string

  FUNCTION GetVersion(self : IN OUT DeviceRecord) RETURN String;

  -- Get the remote device capability string

  FUNCTION GetCapability(self : IN OUT DeviceRecord) RETURN String;

  -- Get the available channels for a given service type

  FUNCTION GetAvailableChannels
   (self    : IN OUT DeviceRecord;
    service : ChannelTypes) RETURN ChannelSets.Set;

PRIVATE

  TYPE DeviceRecord IS TAGGED RECORD
    msg : Message64.Messenger;
    num : Message64.Byte;
  END RECORD;

END RemoteIO;

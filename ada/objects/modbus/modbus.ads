-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

PRIVATE WITH libModbus;

PACKAGE Modbus IS

  Error : EXCEPTION;

  TYPE Bus           IS TAGGED PRIVATE;
  TYPE SerialMode    IS (RS232, RS485);
  TYPE ParitySetting IS (None, Even, Odd);

  TYPE ShortFloatByteOrder IS (ABCD, BADC, CDAB, DCBA);

  Destroyed : CONSTANT Bus;

  -- Constructor for an RTU (serial port) bus object

  FUNCTION Create
   (port     : String;
    mode     : SerialMode := RS232;
    baudrate : Natural := 115200;
    parity   : ParitySetting := None;
    databits : Natural := 8;
    stopbits : Natural := 1;
    debug    : Boolean := False) RETURN Bus;

  -- Initializer for an RTU (serial port) bus object

  PROCEDURE Initialize
   (Self     : IN OUT Bus;
    port     : String;
    mode     : SerialMode := RS232;
    baudrate : Natural := 115200;
    parity   : ParitySetting := None;
    databits : Natural := 8;
    stopbits : Natural := 1;
    debug    : Boolean := False);

  -- Constructor for a TCP bus object

  FUNCTION Create
   (host    : String;
    service : String;
    debug   : Boolean := False) RETURN Bus;

  -- Initializer for a TCP bus object

  PROCEDURE Initialize
   (Self    : IN OUT Bus;
    host    : String;
    service : String;
    debug   : Boolean := False);

  -- Bus object destructor

  PROCEDURE Destroy(Self : IN OUT Bus);

PRIVATE

  TYPE Bus IS TAGGED RECORD
    ctx : libModbus.Context := libModbus.Null_Context;
  END RECORD;

  Destroyed : CONSTANT Bus := Bus'(ctx => libModbus.Null_Context);

  -- Select which slave device to communicate with

  PROCEDURE SelectSlave
   (ctx   : libModbus.Context;
    slave : Natural);

END ModBus;

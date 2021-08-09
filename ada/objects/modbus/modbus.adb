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

WITH libModbus;

USE TYPE libModbus.Context;

PACKAGE BODY Modbus IS

  -- Map enumerations to libmodbus constants

  SerialModes : CONSTANT ARRAY (SerialMode) OF Integer :=
   (libModbus.MODBUS_RTU_RS232,
    libModbus.MODBUS_RTU_RS485);

  ParityChars : CONSTANT ARRAY (ParitySetting) OF Character :=
   (libModbus.MODBUS_RTU_PARITY_NONE,
    libModbus.MODBUS_RTU_PARITY_EVEN,
    libModbus.MODBUS_RTU_PARITY_ODD);

  DebugModes : CONSTANT ARRAY (Boolean) OF Integer :=
   (libModbus.MODBUS_DEBUG_DISABLE,
    libModbus.MODBUS_DEBUG_ENABLE);

  -- Constructor for an RTU (serial port) bus object

  FUNCTION Create
   (port     : String;
    mode     : SerialMode := RS232;
    baudrate : Natural := 115200;
    parity   : ParitySetting := None;
    databits : Natural := 8;
    stopbits : Natural := 1;
    debug    : Boolean := False) RETURN Bus IS

    ctx : libModbus.Context;

  BEGIN
    ctx := libModbus.modbus_new_rtu(port & ASCII.NUL, baudrate,
      ParityChars(parity), databits, stopbits);

    IF ctx = libModbus.Null_Context THEN
      RAISE Error WITH "modbus_new_rtu() failed, " &
        libmodbus.error_message;
    END IF;

    IF libModbus.modbus_set_debug(ctx, DebugModes(debug)) /= 0 THEN
      RAISE Error WITH "modbus_set_debug() failed, " &
        libmodbus.error_message;
    END IF;

    IF libModbus.modbus_rtu_set_serial_mode(ctx, SerialModes(mode)) /= 0 THEN
      RAISE Error WITH "modbus_rtu_set_serial_mode() failed, " &
        libmodbus.error_message;
    END IF;

    IF libModbus.modbus_connect(ctx) /= 0 THEN
      RAISE Error WITH "modbus_connect() failed, " &
        libmodbus.error_message;
    END IF;

    RETURN Bus'(ctx => ctx);
  END Create;

  -- Initializer for an RTU (serial port) bus object

  PROCEDURE Initialize
   (Self     : IN OUT Bus;
    port     : String;
    mode     : SerialMode := RS232;
    baudrate : Natural := 115200;
    parity   : ParitySetting := None;
    databits : Natural := 8;
    stopbits : Natural := 1;
    debug    : Boolean := False) IS

  BEGIN
    Self.Destroy;
    Self := Create(port, mode, baudrate, parity, databits, stopbits, debug);
  END Initialize;

  -- Constructor for a TCP bus object

  FUNCTION Create
   (host    : String;
    service : String;
    debug   : Boolean := False) RETURN Bus IS

    ctx : libModbus.Context;

  BEGIN
    ctx := libModbus.modbus_new_tcp_pi(host, service);

    IF ctx = libModbus.Null_Context THEN
      RAISE Error WITH "modbus_new_tcp_pi() failed, " &
        libmodbus.error_message;
    END IF;

    IF libModbus.modbus_set_debug(ctx, DebugModes(debug)) /= 0 THEN
      RAISE Error WITH "modbus_set_debug() failed, " &
        libmodbus.error_message;
    END IF;

    IF libModbus.modbus_connect(ctx) /= 0 THEN
      RAISE Error WITH "modbus_connect() failed, " &
        libmodbus.error_message;
    END IF;

    RETURN Bus'(ctx => ctx);
  END Create;

  -- Initializer for a TCP bus object

  PROCEDURE Initialize
   (Self    : IN OUT Bus;
    host    : String;
    service : String;
    debug   : Boolean := False) IS

  BEGIN
    Self.Destroy;
    Self := Create(host, service, debug);
  END Initialize;

  -- Bus object destructor

  PROCEDURE Destroy(Self : IN OUT Bus) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libModbus.modbus_close(Self.ctx);
    libModbus.modbus_free(Self.ctx);

    Self := Destroyed;
  END Destroy;

  -- Select which slave device to communicate with

  PROCEDURE SelectSlave
   (ctx   : libModbus.Context;
    slave : Natural) IS

  BEGIN
    IF libModbus.modbus_set_slave(ctx, slave) /= 0 THEN
      RAISE Error WITH "modbus_set_slave() failed, " & libModbus.error_message;
    END IF;
  END SelectSlave;

END ModBus;

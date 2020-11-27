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

-- Modbus (output) holding registers are READ/WRITE or possibly WRITE ONLY

PACKAGE BODY Modbus.HoldingRegisters IS

  -- (Outout) holding register constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : RegisterData) RETURN Register IS

    Self : RegisterClass;

  BEGIN
    Self.Initialize(cont, slave, addr, state);
    RETURN NEW RegisterClass'(Self);
  END Create;

  -- (Outout) holding register initializer

  PROCEDURE Initialize
   (Self  : IN OUT RegisterClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : RegisterData) IS

  BEGIN
    Self.Destroy;
    Self := RegisterClass'(cont.ctx, slave, addr);
    Self.Put(state);
  EXCEPTION
    WHEN OTHERS =>
      Self.Destroy;
      RAISE;
  END Initialize;

  -- (Outout) holding register destructor

  PROCEDURE Destroy(Self : IN OUT RegisterClass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- (Outout) holding register methods

  FUNCTION Get(Self : IN OUT RegisterClass) RETURN RegisterData IS

    buf : libModbus.wordarray(0 .. 0);

  BEGIN
    Self.CheckDestroyed;
    SelectSlave(Self.ctx, Self.slave);

    IF libModbus.modbus_read_registers(Self.ctx, Self.addr, 1, buf) /= 1 THEN
      RAISE Error WITH "modbus_read_registers() failed, " &
        libModbus.error_message;
    END IF;

    RETURN RegisterData(buf(0));
  END Get;

  PROCEDURE Put
   (Self : IN OUT RegisterClass;
    item : RegisterData) IS

  BEGIN
    Self.CheckDestroyed;
    SelectSlave(Self.ctx, Self.slave);

    IF libModbus.modbus_write_register(Self.ctx, Self.addr,
      libModbus.word(item)) /= 1 THEN
      RAISE Error WITH "modbus_write_register() failed, " &
        libModbus.error_message;
    END IF;
  END Put;

  -- Check whether holding register has been destroyed

  PROCEDURE CheckDestroyed(Self : RegisterClass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "Holding register has been destroyed";
    END IF;
  END CheckDestroyed;

END ModBus.HoldingRegisters;

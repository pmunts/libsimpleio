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

PACKAGE BODY Modbus.OutputShortFloat IS

  -- Analog output constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : Quantity;
    order : ShortFloatByteOrder := ABCD) RETURN Output IS

    Self : OutputClass;

  BEGIN
    Self.Initialize(cont, slave, addr, state, order);
    RETURN NEW OutputClass'(Self);
  END Create;

  -- Analog output initializer

  PROCEDURE Initialize
   (Self  : IN OUT OutputClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : Quantity;
    order : ShortFloatByteOrder := ABCD) IS

  BEGIN
    Self.Destroy;
    Self := OutputClass'(cont.ctx, slave, addr, order);
    Self.Put(state);
  EXCEPTION
    WHEN OTHERS =>
      Self.Destroy;
      RAISE;
  END Initialize;

  -- Analog output destructor

  PROCEDURE Destroy(Self : IN OUT OutputClass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- Analog output methods

  FUNCTION Get(Self : IN OUT OutputClass) RETURN Quantity IS

    buf : libModbus.wordarray(0 .. 1);

  BEGIN
    Self.CheckDestroyed;
    SelectSlave(Self.ctx, Self.slave);

    IF libModbus.modbus_read_registers(Self.ctx, Self.addr, 2, buf) /= 2 THEN
      RAISE Error WITH "modbus_read_registers() failed, " &
        libModbus.error_message;
    END IF;

    CASE Self.order IS
      WHEN ABCD =>
        RETURN Quantity(libModbus.modbus_get_float_badc(buf));

      WHEN BADC =>
        RETURN Quantity(libModbus.modbus_get_float_abcd(buf));

      WHEN CDAB =>
        RETURN Quantity(libModbus.modbus_get_float_dcba(buf));

      WHEN DCBA =>
        RETURN Quantity(libModbus.modbus_get_float_cdab(buf));
    END CASE;
  END Get;

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    state : Quantity) IS

    buf : libModbus.wordarray(0 .. 1);

  BEGIN
    Self.CheckDestroyed;
    SelectSlave(Self.ctx, Self.slave);

    CASE Self.order IS
      WHEN ABCD =>
        libModbus.modbus_set_float_abcd(Short_Float(state), buf);

      WHEN BADC =>
        libModbus.modbus_set_float_badc(Short_Float(state), buf);

      WHEN CDAB =>
        libModbus.modbus_set_float_cdab(Short_Float(state), buf);

      WHEN DCBA =>
        libModbus.modbus_set_float_dcba(Short_Float(state), buf);
    END CASE;

    IF libModbus.modbus_write_registers(Self.ctx, Self.addr, 2, buf) /= 2 THEN
      RAISE Error WITH "modbus_write_registers() failed, " &
        libModbus.error_message;
    END IF;
  END Put;

  -- Check whether analog output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputClass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "Analog output has been destroyed";
    END IF;
  END CheckDestroyed;

END ModBus.OutputShortFloat;

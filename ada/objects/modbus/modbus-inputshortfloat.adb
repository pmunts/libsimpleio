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

-- Modbus input registers are READ ONLY

PACKAGE BODY Modbus.InputShortFloat IS

  -- Analog input constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural;
    order : ShortFloatByteOrder := ABCD) RETURN Input IS

    Self : InputClass;

  BEGIN
    Self.Initialize(cont, slave, addr, order);
    RETURN NEW InputClass'(Self);
  END Create;

  -- Analog input initializer

  PROCEDURE Initialize
   (Self  : IN OUT InputClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural;
    order : ShortFloatByteOrder := ABCD) IS

    dummy : Quantity;

  BEGIN
    Self.Destroy;
    Self := InputClass'(cont.ctx, slave, addr, order);
    dummy := Self.Get;
  EXCEPTION
    WHEN OTHERS =>
      Self.Destroy;
      RAISE;
  END Initialize;

  -- Analog input destructor

  PROCEDURE Destroy(Self : IN OUT InputClass) IS

  BEGIN
    Self := Destroyed;
  END Destroy;

  -- Analog input methods

  FUNCTION Get(Self : IN OUT InputClass) RETURN Quantity IS

    buf    : libModbus.wordarray(0 .. 1);

  BEGIN
    Self.CheckDestroyed;
    SelectSlave(Self.ctx, Self.slave);

    IF libModbus.modbus_read_input_registers(Self.ctx, Self.addr, 2, buf) /= 2 THEN
      RAISE Error WITH "modbus_read_input_registers() failed, " &
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

  -- Check whether analog input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputClass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "Analog input has been destroyed";
    END IF;
  END CheckDestroyed;

END ModBus.InputShortFloat;

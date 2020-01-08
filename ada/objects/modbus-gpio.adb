-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Modbus.GPIO IS

  -- GPIO pin constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    kind  : Kinds;
    addr  : Natural) RETURN Standard.GPIO.Pin IS

    Self  : PinSubclass;
    state : Boolean;

  BEGIN
    Self  := PinSubclass'(cont.ctx, slave, kind, addr);
    state := Self.Get;
    RETURN NEW PinSubclass'(Self);
  END Create;

  -- GPIO pin initializer

  PROCEDURE Initialize
   (Self  : IN OUT PinSubclass;
    cont  : Bus;
    slave : Natural;
    kind  : Kinds;
    addr  : Natural) IS

    state : Boolean;

  BEGIN
    IF Self /= Destroyed THEN
      Self.Destroy;
    END IF;

    Self := PinSubclass'(cont.ctx, slave, kind, addr);
    state := Self.get;
  END Initialize;

  -- GPIO pin object destructor

  PROCEDURE Destroy(Self : IN OUT PinSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Self := Destroyed;    
  END Destroy;

  -- Helper to select which slave to communicate with

  PROCEDURE SelectSlave(Self : IN OUT PinSubclass) IS

  BEGIN
    IF libModbus.modbus_set_slave(Self.ctx, Self.slave) /= 0 THEN
      RAISE Error WITH "modbus_set_slave() failed, " & libModbus.error_message;
    END IF;
  END SelectSlave;

  -- GPIO pin read method

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    buf : libModbus.bytearray(0 .. 0);

  BEGIN
    CASE Self.kind IS
      WHEN Unconfigured =>
        RAISE Error WITH "I/O pin has not been configured";

      WHEN Coil =>
        Self.SelectSlave;

        IF libModbus.modbus_read_bits(Self.ctx, Self.addr, 1, buf) /= 1 THEN
          RAISE Error WITH "modbus_read_bits() failed, " &
            libModbus.error_message;
        END IF;

      WHEN Input =>
        Self.SelectSlave;

        IF libModbus.modbus_read_input_bits(Self.ctx, Self.addr, 1, buf) /= 1 THEN
          RAISE Error WITH "modbus_read_input_bits() failed, " &
            libModbus.error_message;
        END IF;
    END CASE;

    RETURN Boolean'Val(buf(0));
  END Get;

  -- GPIO pin write method

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

  BEGIN
    CASE Self.kind IS
      WHEN Unconfigured =>
        RAISE Error WITH "I/O pin has not been configured";

      WHEN Input =>
        RAISE Error WITH "Cannot write to discrete input";

      WHEN Coil =>
        Self.SelectSlave;

        IF libModbus.modbus_write_bit(Self.ctx, Self.addr, Boolean'Pos(state)) /= 1 THEN
          RAISE Error WITH "modbus_write_bit() failed, " & libModbus.error_message;
        END IF;
    END CASE;
  END Put;

END ModBus.GPIO;

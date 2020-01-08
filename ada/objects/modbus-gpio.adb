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

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    kind  : Kinds;
    addr  : Natural) RETURN Standard.GPIO.Pin IS

    p     : PinSubclass;
    state : Boolean;

  BEGIN
    p     := PinSubclass'(cont.ctx, slave, kind, addr);
    state := p.Get;
    RETURN NEW PinSubclass'(p);
  END Create;

  PROCEDURE SelectSlave(Self : IN OUT PinSubclass) IS

  BEGIN
    IF libModbus.modbus_set_slave(Self.ctx, Self.slave) /= 0 THEN
      RAISE Error WITH "modbus_set_slave() failed, " & libModbus.error_message;
    END IF;
  END SelectSlave;

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    buf : libModbus.bytearray(0 .. 0);

  BEGIN
    Self.SelectSlave;

    CASE Self.kind IS
      WHEN Coil =>
        IF libModbus.modbus_read_bits(Self.ctx, Self.addr, 1, buf) /= 1 THEN
          RAISE Error WITH "modbus_read_bits() failed, " &
            libModbus.error_message;
        END IF;

      WHEN Input =>
        IF libModbus.modbus_read_input_bits(Self.ctx, Self.addr, 1, buf) /= 1 THEN
          RAISE Error WITH "modbus_read_input_bits() failed, " &
            libModbus.error_message;
        END IF;
    END CASE;

    RETURN Boolean'Val(buf(0));
  END Get;

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    ret : Integer;

  BEGIN
    IF Self.kind = Input THEN
      RAISE Error WITH "Cannot write to discrete input";
    END IF;

    Self.SelectSlave;

    ret := libModbus.modbus_write_bit(Self.ctx, Self.addr, Boolean'Pos(state));

    IF ret /= 1 THEN
      RAISE Error WITH "modbus_write_bit() failed, " & libModbus.error_message;
    END IF;
  END Put;

END ModBus.GPIO;

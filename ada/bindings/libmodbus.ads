-- Ada subprogram bindings for Linux libmodbus library (https://libmodbus.org)

-- Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
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

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH Interfaces.C.Strings;
WITH libLinux;

PACKAGE libModbus IS
  MODBUS_BROADCAST_ADDRESS : CONSTANT :=  0;

  MODBUS_RTU_RS232         : CONSTANT :=  0;
  MODBUS_RTU_RS485         : CONSTANT :=  1;

  MODBUS_RTU_PARITY_NONE   : CONSTANT Character :=  'N';
  MODBUS_RTU_PARITY_EVEN   : CONSTANT Character :=  'E';
  MODBUS_RTU_PARITY_ODD    : CONSTANT Character :=  'O';

  MODBUS_RTU_RTS_NONE      : CONSTANT :=  0;
  MODBUS_RTU_RTS_UP        : CONSTANT :=  1;
  MODBUS_RTU_RTS_DOWN      : CONSTANT :=  2;

  MODBUS_DEBUG_DISABLE     : CONSTANT := 0;
  MODBUS_DEBUG_ENABLE      : CONSTANT := 1;

  TYPE Context IS NEW Interfaces.C.Strings.chars_ptr;
  TYPE byte IS MOD 2**8;
  TYPE word IS MOD 2**16;
  TYPE bytearray IS ARRAY (Natural RANGE <>) OF byte;
  TYPE wordarray IS ARRAY (Natural RANGE <>) OF word;

  Null_Context : CONSTANT Context := Context(Interfaces.C.Strings.Null_Ptr);

  FUNCTION modbus_new_rtu
   (device   : String;
    baud     : Integer;
    parity   : Character;
    data_bit : Integer;
    stop_bit : Integer) RETURN context;

  FUNCTION modbus_new_tcp
   (addr : String;
    port : Integer) RETURN context;

  FUNCTION modbus_new_tcp_pi
   (node    : String;
    service : String) RETURN context;

  PROCEDURE modbus_free
   (ctx : Context);

  FUNCTION modbus_rtu_get_serial_mode
   (ctx : Context) RETURN Integer;

  FUNCTION modbus_rtu_set_serial_mode
   (ctx  : Context;
    mode : Integer) RETURN Integer;

  FUNCTION modbus_rtu_get_rts
   (ctx : Context) RETURN Integer;

  FUNCTION modbus_rtu_set_rts
   (ctx  : Context;
    mode : Integer) RETURN Integer;

  FUNCTION modbus_rtu_get_rts_delay
   (ctx : Context) RETURN Integer;

  FUNCTION modbus_rtu_set_rts_Delay
   (ctx : Context;
    us  : Integer) RETURN Integer;

  FUNCTION modbus_set_slave
   (ctx   : Context;
    slave : Integer) RETURN Integer;

  FUNCTION modbus_set_debug
   (ctx  : Context;
    flag : Integer) RETURN Integer;

  FUNCTION modbus_connect
   (ctx : Context) RETURN Integer;

  PROCEDURE modbus_close
   (ctx : Context);

  FUNCTION modbus_flush
   (ctx : Context) RETURN Integer;

  FUNCTION modbus_report_slave_id
   (ctx      : Context;
    max_dest : Integer;
    dest     : OUT bytearray) RETURN Integer;

  -- Read data from modbus slave

  FUNCTION modbus_read_bits -- aka coils
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    dest : OUT bytearray) RETURN Integer;

  FUNCTION modbus_read_input_bits -- aka discrete inputs
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    dest : OUT bytearray) RETURN Integer;

  FUNCTION modbus_read_registers -- aka holding registers
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    dest : OUT wordarray) RETURN Integer;

  FUNCTION modbus_read_input_registers
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    dest : OUT wordarray) RETURN Integer;

  -- Write data to modbus slave

  FUNCTION modbus_write_bit -- aka coil
   (ctx    : Context;
    addr   : Integer;
    status : Integer) RETURN Integer;

  FUNCTION modbus_write_bits -- aka coils
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    src  : bytearray) RETURN Integer;

  FUNCTION modbus_write_register -- aka holding register
   (ctx   : Context;
    addr  : Integer;
    value : word) RETURN Integer;

  FUNCTION modbus_write_registers -- aka holding registers
   (ctx  : Context;
    addr : Integer;
    nb   : Integer;
    src  : wordarray) RETURN Integer;

  FUNCTION modbus_write_and_read_registers -- aka holding registers
   (ctx        : Context;
    write_addr : Integer;
    write_nb   : Integer;
    src        : wordarray;
    read_addr  : Integer;
    read_nb    : Integer;
    dest       : OUT wordarray) RETURN Integer;

  -- Old deprecated floating point conversions

  PROCEDURE modbus_set_float
   (f    : Short_Float;
    dest : OUT wordarray);
    Pragma Obsolescent;

  FUNCTION modbus_get_float
   (src : wordarray) RETURN Short_Float;
    Pragma Obsolescent;

  -- New floating point conversions with explicit byte ordering

  -- BEWARE: The following floating point conversions are NOT symmetric!
  --
  --     modbus_set_float_abcd pairs with modbus_get_float_badc
  --     modbus_set_float_badc pairs with modbus_get_float_abcd
  --     modbus_set_float_cdab pairs with modbus_get_float_dcba
  --     modbus_set_float_dcba pairs with modbus_get_float_cdab
  --
  -- As verified on Linux x86-64 and Linux ARM 32-bit systems.

  PROCEDURE modbus_set_float_abcd
   (f    : Short_Float;
    dest : OUT wordarray);

  PROCEDURE modbus_set_float_badc
   (f    : Short_Float;
    dest : OUT wordarray);

  PROCEDURE modbus_set_float_cdab
   (f    : Short_Float;
    dest : OUT wordarray);

  PROCEDURE modbus_set_float_dcba
   (f    : Short_Float;
    dest : OUT wordarray);

  FUNCTION modbus_get_float_abcd
   (src : wordarray) RETURN Short_Float;

  FUNCTION modbus_get_float_badc
   (src : wordarray) RETURN Short_Float;

  FUNCTION modbus_get_float_cdab
   (src : wordarray) RETURN Short_Float;

  FUNCTION modbus_get_float_dcba
   (src : wordarray) RETURN Short_Float;

  FUNCTION modbus_strerror
   (errnum : Integer) RETURN Interfaces.C.Strings.chars_ptr;

  FUNCTION error_message RETURN String IS
   (Interfaces.C.Strings.Value(modbus_strerror(libLinux.ErrNo)));

  PRAGMA Import(C, modbus_close);
  PRAGMA Import(C, modbus_connect);
  PRAGMA Import(C, modbus_flush);
  PRAGMA Import(C, modbus_free);
  PRAGMA Import(C, modbus_get_float);
  PRAGMA Import(C, modbus_get_float_abcd);
  PRAGMA Import(C, modbus_get_float_badc);
  PRAGMA Import(C, modbus_get_float_cdab);
  PRAGMA Import(C, modbus_get_float_dcba);
  PRAGMA Import(C, modbus_new_rtu);
  PRAGMA Import(C, modbus_new_tcp);
  PRAGMA Import(C, modbus_new_tcp_pi);
  PRAGMA Import(C, modbus_read_bits);
  PRAGMA Import(C, modbus_read_input_bits);
  PRAGMA Import(C, modbus_read_input_registers);
  PRAGMA Import(C, modbus_read_registers);
  PRAGMA Import(C, modbus_report_slave_id);
  PRAGMA Import(C, modbus_rtu_get_rts);
  PRAGMA Import(C, modbus_rtu_get_rts_delay);
  PRAGMA Import(C, modbus_rtu_get_serial_mode);
  PRAGMA Import(C, modbus_rtu_set_rts);
  PRAGMA Import(C, modbus_rtu_set_rts_Delay);
  PRAGMA Import(C, modbus_rtu_set_serial_mode);
  PRAGMA Import(C, modbus_set_debug);
  PRAGMA Import(C, modbus_set_float);
  PRAGMA Import(C, modbus_set_float_abcd);
  PRAGMA Import(C, modbus_set_float_badc);
  PRAGMA Import(C, modbus_set_float_cdab);
  PRAGMA Import(C, modbus_set_float_dcba);
  PRAGMA Import(C, modbus_set_slave);
  PRAGMA Import(C, modbus_write_and_read_registers);
  PRAGMA Import(C, modbus_write_bit);
  PRAGMA Import(C, modbus_write_bits);
  PRAGMA Import(C, modbus_write_register);
  PRAGMA Import(C, modbus_write_registers);
  PRAGMA IMport(C, modbus_strerror);
  PRAGMA Link_With("-lmodbus");
END libModbus;

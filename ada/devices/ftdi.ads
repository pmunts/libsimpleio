-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

PRIVATE WITH Interfaces.C.Strings;
PRIVATE WITH System;

PACKAGE FTDI IS

  Error : EXCEPTION;

  TYPE Byte            IS MOD 256;
  TYPE Data            IS ARRAY (Natural RANGE <>) OF Byte;
  TYPE DeviceBaseClass IS TAGGED PRIVATE;
  TYPE Device          IS ACCESS ALL DeviceBaseClass'Class;

  -- Query FTDI library (libftdi1) version

  FUNCTION LibraryVersion RETURN String;

  -- FTDI Device object constructor

  FUNCTION Create
   (Vendor  : Integer;
    Product : Integer) RETURN Device;

  -- Read data from a FTDI device

  PROCEDURE Read
   (Self    : IN OUT DeviceBaseClass;
    inbuf   : OUT Data;
    len     : Positive);

  -- Write data to a FTDI device

  PROCEDURE Write
   (Self    : IN OUT DeviceBaseClass;
    outbuf  : Data;
    len     : Positive);

  -- Get FTDI device chip ID as hexadecimal string

  FUNCTION ChipID(Self : IN OUT DeviceBaseClass) RETURN String;

  -- Dump a data buffer in hexadecimal format

  PROCEDURE Dump(src : Data);

PRIVATE

  TYPE Context IS NEW System.Address;

  NullContext : CONSTANT Context := Context(System.Null_Address);

  TYPE DeviceBaseClass IS TAGGED RECORD
    ctx : Context := NullContext;
  END RECORD;

  -- Fetch last error message string

  FUNCTION ErrorString(ctx : Context) RETURN String;

  -- Minimal thin binding to libftdi1.so follows

  PRAGMA Link_With("-lftdi1");

  TYPE ftdi_version_info IS RECORD
    major        : Interfaces.C.int;
    minor        : Interfaces.C.int;
    micro        : Interfaces.C.int;
    version_str  : Interfaces.C.Strings.chars_ptr;
    snatshot_str : Interfaces.C.Strings.chars_ptr;
  END RECORD WITH Convention => C;

  TYPE ftdi_interface IS
   (INTERFACE_ANY,
    INTERFACE_A,
    INTERFACE_B,
    INTERFACE_C,
    INTERFACE_D) WITH Convention => C;

  FUNCTION ftdi_get_library_version RETURN ftdi_version_info
    WITH Import => True, Convention => C;

  FUNCTION ftdi_new RETURN Context
    WITH Import => True, Convention => C;

  PROCEDURE ftdi_free(ctx : Context)
    WITH Import => True, Convention => C;

  FUNCTION ftdi_get_error_string(ctx : Context) RETURN Interfaces.C.Strings.chars_ptr
    WITH Import => True, Convention => C;

  FUNCTION ftdi_usb_open
   (ctx     : Context;
    vendor  : Interfaces.C.int;
    product : Interfaces.C.int) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_usb_close(ctx : Context) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_usb_reset(ctx : Context) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_set_interface
   (ctx     : Context;
    iface   : ftdi_interface) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_set_bitmode
   (ctx     : Context;
    bitmask : Interfaces.C.unsigned_char;
    mode    : Interfaces.C.unsigned_char) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_read_chipid
   (ctx     : Context;
    chipid  : OUT Interfaces.C.unsigned) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_read_data
   (ctx     : Context;
    buf     : System.Address;
    size    : Interfaces.C.int) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION ftdi_write_data
   (ctx     : Context;
    buf     : System.Address;
    size    : Interfaces.C.int) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

END FTDI;

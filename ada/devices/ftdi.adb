-- Copyright (C)2021-2023, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;
WITH Ada.Text_IO;
WITH Interfaces.C;

USE TYPE Interfaces.C.int;
USE TYPE Interfaces.C.unsigned;

PACKAGE BODY FTDI IS

  -- Fetch last error message string

  FUNCTION ErrorString(ctx : Context) RETURN String IS

  BEGIN
    RETURN Interfaces.C.Strings.Value(ftdi_get_error_string(ctx));
  END ErrorString;

  -- FTDI Device object constructor

  FUNCTION Create
   (Vendor  : Integer;
    Product : Integer) RETURN Device IS

    ctx : CONSTANT Context := ftdi_new;

  BEGIN
    IF ctx = NullContext THEN
      RAISE Error WITH "ftdi_new() failed";
    END IF;

    IF ftdi_usb_open(ctx, Interfaces.C.int(Vendor), Interfaces.C.int(Product)) /= 0 THEN
      DECLARE
        msg : CONSTANT String := ErrorString(ctx);

      BEGIN
        ftdi_free(ctx);
        RAISE Error WITH "ftdi_usb_open() failed, " & msg;
      END;
    END IF;

    RETURN NEW DeviceBaseClass'(ctx => ctx);
  END Create;

  -- Read data from a FTDI device

  PROCEDURE Read
   (Self    : IN OUT DeviceBaseClass;
    inbuf   : OUT Data;
    len     : Positive) IS

    ret : Interfaces.C.int;

  BEGIN
    IF Self.ctx = NullContext THEN
      RAISE Error WITH "This object instance has not been created properly";
    END IF;

    LOOP
      -- For some reason and on some targets, ftdi_read_data() sometimes
      -- returns a zero byte count.  So keep reading until we get a nonzero
      -- byte count.
      ret := ftdi_read_data(Self.ctx, inbuf'Address, Interfaces.C.int(len));
      EXIT WHEN ret /= 0;
    END LOOP;

    IF ret /= Interfaces.C.int(len) THEN
      Ada.Text_IO.Put_Line("DEBUG: ret =>" & Interfaces.C.int'Image(ret));
      RAISE Error WITH "ftdi_read_data() failed, " & ErrorString(Self.ctx);
    END IF;
  END Read;

  -- Write data to a FTDI device

  PROCEDURE Write
   (Self    : IN OUT DeviceBaseClass;
    outbuf  : Data;
    len     : Positive) IS

  BEGIN
    IF Self.ctx = NullContext THEN
      RAISE Error WITH "This object instance has not been created properly";
    END IF;

    IF ftdi_write_data(Self.ctx, outbuf'Address, Interfaces.C.int(len)) /= Interfaces.C.int(len) THEN
      RAISE Error WITH "ftdi_write_data() failed, " & ErrorString(Self.ctx);
    END IF;
  END Write;

  -- Get FTDI device chip ID as hexadecimal string

  FUNCTION ChipID(Self : IN OUT DeviceBaseClass) RETURN String IS

    id       : Interfaces.C.unsigned;
    hexchars : CONSTANT String := "0123456789ABCDEF";

  BEGIN
    IF Self.ctx = NullContext THEN
      RAISE Error WITH "This object instance has not been created properly";
    END IF;

    IF ftdi_read_chipid(Self.ctx, id) /= 0 THEN
      RAISE Error WITH "ftdi_read_chipid() failed, " & ErrorString(Self.ctx);
    END IF;

    RETURN hexchars(Natural(id / 2**28 MOD 16) + 1) &
	   hexchars(Natural(id / 2**24 MOD 16) + 1) &
	   hexchars(Natural(id / 2**20 MOD 16) + 1) &
	   hexchars(Natural(id / 2**16 MOD 16) + 1) &
           hexchars(Natural(id / 2**12 MOD 16) + 1) &
	   hexchars(Natural(id / 2**8  MOD 16) + 1) &
	   hexchars(Natural(id / 2**4  MOD 16) + 1) &
	   hexchars(Natural(id / 2**0  MOD 16) + 1);
  END ChipID;

  -- Query FTDI library (libftdi1) version

  FUNCTION LibraryVersion RETURN String IS

  BEGIN
    RETURN Interfaces.C.Strings.Value(ftdi_get_library_version.version_str);
  END LibraryVersion;

  -- Dump a data buffer in hexadecimal format

  PROCEDURE Dump(src : Data) IS

    PACKAGE ByteIO IS NEW Ada.Text_IO.Modular_IO(Byte);

    buf : String(1 .. 6);

  BEGIN
    FOR b OF src LOOP
      ByteIO.Put(buf, b, 16);

      IF buf(1) = ' ' THEN
        Ada.Strings.Fixed.Insert(buf, 5, "0", Ada.Strings.Left);
      END IF;

      Ada.Strings.Fixed.Replace_Slice(buf, 6, 6, " ");
      Ada.Strings.Fixed.Replace_Slice(buf, 1, 3, " ");

      Ada.Text_IO.Put(Ada.Strings.Fixed.Trim(buf, Ada.Strings.Both));
      Ada.Text_IO.Put(" ");
    END LOOP;

    Ada.Text_IO.New_Line;
  END Dump;

END FTDI;

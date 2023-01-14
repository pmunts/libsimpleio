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

WITH Interfaces.C;

USE TYPE Interfaces.C.int;
USE TYPE Interfaces.C.unsigned;

PACKAGE BODY FTDI.MPSSE IS

  -- FTDI Device object constructor

  FUNCTION Create
   (Vendor  : Integer;
    Product : Integer) RETURN Device IS

    ctx : Context;

  BEGIN
    ctx := ftdi_new;

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

    IF ftdi_usb_reset(ctx) /= 0 THEN
      DECLARE
        msg : CONSTANT String := ErrorString(ctx);

      BEGIN
        ftdi_free(ctx);
        RAISE Error WITH "ftdi_usb_reset() failed, " & msg;
      END;
    END IF;

    IF ftdi_set_interface(ctx, INTERFACE_ANY) /= 0 THEN
      DECLARE
        msg : CONSTANT String := ErrorString(ctx);

      BEGIN
        ftdi_free(ctx);
        RAISE Error WITH "ftdi_set_interface() failed, " & msg;
      END;
    END IF;

    IF ftdi_set_bitmode(ctx, 0, 0) /= 0 THEN
      DECLARE
        msg : CONSTANT String := ErrorString(ctx);

      BEGIN
        ftdi_free(ctx);
        RAISE Error WITH "ftdi_set_bitmode() failed, " & msg;
      END;
    END IF;

    IF ftdi_set_bitmode(ctx, 0, 2) /= 0 THEN
      DECLARE
        msg : CONSTANT String := ErrorString(ctx);

      BEGIN
        ftdi_free(ctx);
        RAISE Error WITH "ftdi_set_bitmode() failed, " & msg;
      END;
    END IF;

    DELAY 0.05;  -- Sleep 50 ms for setup to complete
    RETURN NEW DeviceSubclass'(ctx, 0, 0, 0, 0);
  END Create;

END FTDI.MPSSE;

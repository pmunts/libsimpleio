-- Top level definitions for raw Human Interface Devices

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY HID IS

  FUNCTION ToString
   (VID : Vendor;
    PID : Product;
    cap : Capitalization := Upper) RETURN String IS

    hexchars_lower : CONSTANT String := "0123456789abcdef";
    hexchars_upper : CONSTANT String := "0123456789ABCDEF";

  BEGIN
    CASE cap IS
      WHEN Lower =>
	RETURN
          hexchars_lower(Natural(VID / 4096 MOD 16) + 1) &
	  hexchars_lower(Natural(VID / 256 MOD 16) + 1)  &
	  hexchars_lower(Natural(VID / 16 MOD 16) + 1)   &
	  hexchars_lower(Natural(VID MOD 16) + 1) & ":"  &
          hexchars_lower(Natural(PID / 4096 MOD 16) + 1) &
	  hexchars_lower(Natural(PID / 256 MOD 16) + 1)  &
	  hexchars_lower(Natural(PID / 16 MOD 16) + 1)   &
	  hexchars_lower(Natural(PID MOD 16) + 1);

      WHEN Upper =>
	RETURN
          hexchars_upper(Natural(VID / 4096 MOD 16) + 1) &
	  hexchars_upper(Natural(VID / 256 MOD 16) + 1)  &
	  hexchars_upper(Natural(VID / 16 MOD 16) + 1)   &
	  hexchars_upper(Natural(VID MOD 16) + 1) & ":"  &
          hexchars_upper(Natural(PID / 4096 MOD 16) + 1) &
	  hexchars_upper(Natural(PID / 256 MOD 16) + 1)  &
	  hexchars_upper(Natural(PID / 16 MOD 16) + 1)   &
	  hexchars_upper(Natural(PID MOD 16) + 1);
    END CASE;
  END ToString;

END HID;

-- MCP2221 Device Services using HID.libusb

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

WITH HID.libusb;

PACKAGE BODY MCP2221.libusb IS

  FUNCTION Create
   (vid       : HID.Vendor   := MCP2221.VendorID;
    pid       : HID.Product  := MCP2221.ProductID;
    serial    : String       := "";
    timeoutms : Natural      := 1000;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device IS

    dev : DeviceClass :=
      DeviceClass'(msg => HID.libusb.Create(vid, pid, serial, timeoutms, 2,
        16#83#, 16#03#));

  BEGIN
    dev.SetPinModes(pinmodes);

    RETURN NEW DeviceClass'(dev);
  END Create;

END MCP2221.libusb;

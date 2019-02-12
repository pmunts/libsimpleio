-- 64-byte message services using the raw HID services from libusb
-- without heap

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

WITH Ada.Characters.Handling;
WITH System;

USE TYPE System.Address;

PACKAGE BODY HID.libusb.Static IS

  -- Constructor using HID vendor and product ID's

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    iface     : Natural := 0;
    timeoutms : Integer := 1000) IS

    error   : Integer;
    context : System.Address;
    handle  : System.Address;

  BEGIN
    Self := Destroyed;

    IF timeoutms < 0 THEN
      RAISE HID_Error WITH "timeoutms parameter is out of range";
    END IF;

    error := libusb_init(context);

    IF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_init() failed, error " &
        Integer'Image(error);
    END IF;

    handle := libusb_open_device_with_vid_pid(context,
      Interfaces.C.unsigned_short(vid), Interfaces.C.unsigned_short(pid));

    IF handle = System.Null_Address THEN
      RAISE HID_Error WITH "libusb_open_device_with_vid_pid() failed";
    END IF;

    error := libusb_set_auto_detach_kernel_driver(handle, 1);

    IF (error /= LIBUSB_SUCCESS) AND (error /= LIBUSB_ERROR_NOT_SUPPORTED) THEN
      RAISE HID_Error WITH "libusb_set_auto_detach_kernel() failed, error " &
        Integer'Image(error);
    END IF;

    error := libusb_claim_interface(handle, iface);

    IF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_claim_interface() failed, error " &
        Integer'Image(error);
    END IF;

    Self := MessengerSubclass'(handle, timeoutms);
  END Initialize;

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libusb_close(Self.handle);

    Self := Destroyed;
  END Destroy;

END HID.libusb.Static;

-- 64-byte message services using the raw HID services from liblibusb

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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
WITH System;

WITH Messaging;

USE TYPE System.Address;

PACKAGE BODY HID.libusb IS

  -- Constructor

  FUNCTION Create
   (vid       : Standard.HID.Vendor  := 16#16D0#; -- Munts Technologies USB raw HID
    pid       : Standard.HID.Product := 16#0AFA#; -- Munts Technologies USB raw HID
    timeoutms : Natural := 1000) RETURN Message64.Messenger IS

    error   : Integer;
    context : System.Address;
    handle  : System.Address;

  BEGIN
    error := libusb_init(context);

    IF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_init() failed, error " &
        Integer'Image(error);
    END IF;

    handle := libusb_open_device_with_vid_pid(context,
      Interfaces.C.unsigned_short(vid), Interfaces.C.unsigned_short(pid));

    IF handle = System.Null_Address THEN
      RAISE HID_Error WITH "hid_open() failed";
    END IF;

    error := libusb_set_auto_detach_kernel_driver(handle, 1);

    IF (error /= LIBUSB_SUCCESS) AND (error /= LIBUSB_ERROR_NOT_SUPPORTED) THEN
      RAISE HID_Error WITH "libusb_set_auto_detach_kernel() failed, error " &
        Integer'Image(error);
    END IF;

    error := libusb_claim_interface(handle, 0);

    IF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_claim_interface() failed, error " &
        Integer'Image(error);
    END IF;

    RETURN NEW MessengerSubclass'(handle, timeoutms);
  END Create;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message) IS

    error  : Integer;
    count  : Integer;

  BEGIN
    error := libusb_interrupt_transfer(Self.handle, 16#01#, msg'Address,
      msg'Length, count, Interfaces.C.unsigned(Self.timeout));

    -- Handle error conditions

    IF error = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Messaging.Timeout_Error WITH "libusb_interrupt_transfer() timed out";
    ELSIF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_interrupt_transfer() failed, error " &
        Integer'Image(error);
    ELSIF (count /= msg'Length) AND (count /= msg'Length + 1) THEN
      RAISE HID_Error WITH "incorrect send byte count," & Integer'Image(count);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message) IS

    error  : Integer;
    count  : Integer;

  BEGIN
    error := libusb_interrupt_transfer(Self.handle, 16#81#, msg'Address,
      msg'Length, count, Interfaces.C.unsigned(Self.timeout));

    -- Handle error conditions

    IF error = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Messaging.Timeout_Error WITH "libusb_interrupt_transfer() timed out";
    ELSIF error /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_interrupt_transfer() failed, error " &
        Integer'Image(error);
    END IF;

    IF count /= msg'Length THEN
      RAISE HID_Error WITH "Incorrect receive byte count," &
        Integer'Image(count);
    END IF;
  END Receive;

END HID.libusb;

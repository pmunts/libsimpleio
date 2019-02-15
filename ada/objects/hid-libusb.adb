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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Interfaces.C;
WITH System;

WITH Messaging;

USE TYPE Interfaces.C.unsigned_char;
USE TYPE System.Address;

PACKAGE BODY HID.libusb IS

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    iface     : Natural := 0;
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    error   : Integer;
    context : System.Address;
    handle  : System.Address;

  BEGIN

    -- Validate parameters

    IF timeoutms < 0 THEN
      RAISE HID_Error WITH "timeoutms parameter is out of range";
    END IF;

    error := libusb_init(context);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_init() failed, error " &
        Integer'Image(error);
    END IF;

    handle := libusb_open_device_with_vid_pid(context,
      Interfaces.C.unsigned_short(vid), Interfaces.C.unsigned_short(pid));

    IF handle = System.Null_Address THEN
      RAISE HID_Error WITH "libusb_open_device_with_vid_pid() failed";
    END IF;

    error := libusb_set_auto_detach_kernel_driver(handle, 1);

    IF (error < LIBUSB_SUCCESS) AND (error /= LIBUSB_ERROR_NOT_SUPPORTED) THEN
      RAISE HID_Error WITH "libusb_set_auto_detach_kernel() failed, error " &
        Integer'Image(error);
    END IF;

    error := libusb_claim_interface(handle, iface);

    IF error < LIBUSB_SUCCESS THEN
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
    ELSIF error < LIBUSB_SUCCESS THEN
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
    ELSIF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_interrupt_transfer() failed, error " &
        Integer'Image(error);
    ELSIF count /= msg'Length THEN
      RAISE HID_Error WITH "Incorrect receive byte count," &
        Integer'Image(count);
    END IF;
  END Receive;

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String IS

  BEGIN
    RETURN Self.Manufacturer & " " & Self.Product;
  END Name;

  -- Get HID device manufacturer string

  FUNCTION Manufacturer
   (Self : MessengerSubclass) RETURN String IS

    error : Integer;
    desc  : DeviceDescriptor;
    data  : Interfaces.c.char_array(0 .. 255);

  BEGIN
    error := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed, error " &
        Integer'Image(error);
    END IF;

    IF desc(iManufacturer) = 0 THEN
      RETURN "";
    END IF;

    error := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iManufacturer), data, data'Length);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed, error " &
        Integer'Image(error);
    END IF;

    IF error = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END Manufacturer;

  -- Get HID device product string

  FUNCTION Product
   (Self : MessengerSubclass) RETURN String IS

    error : Integer;
    desc  : DeviceDescriptor;
    data  : Interfaces.c.char_array(0 .. 255);

  BEGIN
    error := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed, error " &
        Integer'Image(error);
    END IF;

    IF desc(iProduct) = 0 THEN
      RETURN "";
    END IF;

    error := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iProduct), data, data'Length);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed, error " &
        Integer'Image(error);
    END IF;

    IF error = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END Product;

  -- Get HID device serial number string

  FUNCTION SerialNumber
   (Self : MessengerSubclass) RETURN String IS

    error : Integer;
    desc  : DeviceDescriptor;
    data  : Interfaces.c.char_array(0 .. 255);

  BEGIN
    error := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed, error " &
        Integer'Image(error);
    END IF;

    IF desc(iSerialNumber) = 0 THEN
      RETURN "";
    END IF;

    error := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iSerialNumber), data, data'Length);

    IF error < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed, error " &
        Integer'Image(error);
    END IF;

    IF error = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END SerialNumber;

END HID.libusb;

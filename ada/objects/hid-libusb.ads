-- 64-byte message services using the raw HID services from libusb

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

-- Allowed values for the timeout parameter:
--
--  0 => Send or receive operation blocks forever
-- >0 => Send or receive operation blocks for the indicated number of milliseconds

WITH Message64;

PRIVATE WITH Interfaces.C;
PRIVATE WITH System;

PACKAGE HID.libusb IS

  -- Type definitions

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  Destroyed : CONSTANT MessengerSubclass;

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000;
    iface     : Natural := 0;
    epin      : Natural := 16#81#;
    epout     : Natural := 16#01#) RETURN Message64.Messenger;

  -- Initializer

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000;
    iface     : Natural := 0;
    epin      : Natural := 16#81#;
    epout     : Natural := 16#01#);

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass);

  -- Send a message

  PROCEDURE Send
   (Self      : MessengerSubclass;
    msg       : Message64.Message);

  -- Receive a message

  PROCEDURE Receive
   (Self      : MessengerSubclass;
    msg       : OUT Message64.Message);

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String;

  -- Get HID device manufacturer string

  FUNCTION Manufacturer
   (Self : MessengerSubclass) RETURN String;

  -- Get HID device product string

  FUNCTION Product
   (Self : MessengerSubclass) RETURN String;

  -- Get HID device serial number string

  FUNCTION SerialNumber
   (Self : MessengerSubclass) RETURN String;

PRIVATE

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass);

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    handle  : System.Address := System.Null_Address;
    epin    : Interfaces.C.unsigned_char := 0;
    epout   : Interfaces.C.unsigned_char := 0;
    timeout : Interfaces.C.unsigned := 0;
  END RECORD;

  Destroyed : CONSTANT MessengerSubclass :=
    MessengerSubclass'(System.Null_Address, 0, 0, 0);

  -- Minimal Ada thin binding to libusb

  LIBUSB_SUCCESS             : CONSTANT Integer := 0;
  LIBUSB_ERROR_IO            : CONSTANT Integer := -1;
  LIBUSB_ERROR_INVALID_PARAM : CONSTANT Integer := -2;
  LIBUSB_ERROR_ACCESS        : CONSTANT Integer := -3;
  LIBUSB_ERROR_NO_DEVICE     : CONSTANT Integer := -4;
  LIBUSB_ERROR_NOT_FOUND     : CONSTANT Integer := -5;
  LIBUSB_ERROR_BUSY          : CONSTANT Integer := -6;
  LIBUSB_ERROR_TIMEOUT       : CONSTANT Integer := -7;
  LIBUSB_ERROR_OVERFLOW      : CONSTANT Integer := -8;
  LIBUSB_ERROR_PIPE          : CONSTANT Integer := -9;
  LIBUSB_ERROR_INTERRUPTED   : CONSTANT Integer := -10;
  LIBUSB_ERROR_NO_MEM        : CONSTANT Integer := -11;
  LIBUSB_ERROR_NOT_SUPPORTED : CONSTANT Integer := -12;
  LIBUSB_ERROR_OTHER         : CONSTANT Integer := -99;

  TYPE DeviceDescriptor IS ARRAY (0 .. 17) OF Interfaces.C.unsigned_char;

  idVendor                   : CONSTANT Natural := 8;
  idProduct                  : CONSTANT Natural := 10;
  iManufacturer              : CONSTANT Natural := 14;
  iProduct                   : CONSTANT Natural := 15;
  iSerialNumber              : CONSTANT Natural := 16;

  FUNCTION libusb_init
   (context  : System.Address) RETURN Integer;

  FUNCTION libusb_get_device_list
   (context  : System.Address;
    list     : System.Address) RETURN Integer;

  PROCEDURE libusb_free_device_list
   (list     : System.Address;
    unref    : Integer);

  FUNCTION libusb_open
   (dev      : System.Address;
    handle   : OUT System.Address) RETURN Integer;

  PROCEDURE libusb_close
   (handle   : System.Address);

  FUNCTION libusb_set_auto_detach_kernel_driver
   (handle   : System.Address;
    enable   : Integer) RETURN Integer;

  FUNCTION libusb_claim_interface
   (handle   : System.Address;
    num      : Integer) RETURN Integer;

  FUNCTION libusb_interrupt_transfer
   (handle   : System.Address;
    endpoint : Interfaces.C.unsigned_char;
    data     : System.Address;
    length   : Integer;
    count    : OUT Integer;
    timeout  : Interfaces.C.unsigned) RETURN Integer;

  FUNCTION libusb_get_device
   (handle   : System.Address) RETURN System.Address;

  FUNCTION libusb_get_device_descriptor
   (handle   : System.Address;
    data     : OUT DeviceDescriptor) RETURN Integer;

  FUNCTION libusb_get_string_descriptor_ascii
   (handle   : System.Address;
    index    : Interfaces.C.unsigned_char;
    data     : OUT Interfaces.C.char_array;
    length   : Integer) RETURN Integer;

  PRAGMA Import(C, libusb_init);
  PRAGMA Import(C, libusb_get_device_list);
  PRAGMA Import(C, libusb_free_device_list);
  PRAGMA Import(C, libusb_open);
  PRAGMA Import(C, libusb_close);
  PRAGMA Import(C, libusb_set_auto_detach_kernel_driver);
  PRAGMA Import(C, libusb_claim_interface);
  PRAGMA Import(C, libusb_interrupt_transfer);
  PRAGMA Import(C, libusb_get_device);
  PRAGMA Import(C, libusb_get_device_descriptor);
  PRAGMA Import(C, libusb_get_string_descriptor_ascii);

  PRAGMA Link_With("-lusb-1.0");

END HID.libusb;

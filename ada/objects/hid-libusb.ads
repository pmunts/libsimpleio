-- 64-byte message services using the raw HID services from libusb

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

WITH HID.Munts;
WITH Message64;

PRIVATE WITH Interfaces.C;
PRIVATE WITH System;

PACKAGE HID.libusb IS

  -- Type definitions

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    iface     : Natural := 0;
    timeoutms : Natural := 1000) RETURN Message64.Messenger;

  -- Send a message

  PROCEDURE Send
   (Self      : MessengerSubclass;
    msg       : Message64.Message);

  -- Receive a message

  PROCEDURE Receive
   (Self      : MessengerSubclass;
    msg       : OUT Message64.Message);

PRIVATE

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    handle  : System.Address;
    timeout : Natural;
  END RECORD;

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

  FUNCTION libusb_init
   (context  : OUT System.Address) RETURN Integer;

  FUNCTION libusb_open_device_with_vid_pid
   (context  : System.Address;
    vid      : Interfaces.C.unsigned_short;
    pid      : Interfaces.C.unsigned_short) RETURN System.Address;

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

  PRAGMA Import(C, libusb_init);
  PRAGMA Import(C, libusb_open_device_with_vid_pid);
  PRAGMA Import(C, libusb_set_auto_detach_kernel_driver);
  PRAGMA Import(C, libusb_claim_interface);
  PRAGMA Import(C, libusb_interrupt_transfer);

  PRAGMA Link_With("-lusb-1.0");

END HID.libusb;

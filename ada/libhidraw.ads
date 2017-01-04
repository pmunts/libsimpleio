-- Minimal Ada wrapper for the Linux raw HID services
-- implemented in libso

-- Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

WITH System;

PACKAGE libHIDRaw IS
  PRAGMA Link_With("-lsimpleio");

  PROCEDURE Open
   (devname : String;
    fd      : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Open, "LINUX_open_readwrite");

  PROCEDURE Close
   (fd      : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Close, "LINUX_close");

  PROCEDURE GetName
   (fd      : Integer;
    name    : System.Address;
    size    : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, GetName, "HIDRAW_get_name");

  PROCEDURE GetInfo
   (fd      : Integer;
    bustype : OUT Integer;
    vendor  : OUT Integer;
    product : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, GetInfo, "HIDRAW_get_info");

  PROCEDURE Send
   (fd      : Integer;
    buf     : System.Address;
    bufsize : Integer;
    count   : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Send, "LINUX_write");

  PROCEDURE Receive
   (fd      : Integer;
    buf     : System.Address;
    bufsize : Integer;
    count   : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Receive, "LINUX_read");

END libHIDRaw;

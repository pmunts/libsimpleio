-- Minimal Ada wrapper for the Linux raw HID services
-- implemented in libsimpleio.so

-- $Id: libsimpleio-hidraw.ads 10152 2016-03-09 13:32:41Z svn $

-- Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

PACKAGE libsimpleio.HIDRaw IS

  PROCEDURE Open
   (devname : String;
    fd      : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Open, "HIDRAW_open");

  PROCEDURE Close
   (fd      : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Close, "HIDRAW_close");

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
    size    : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Send, "HIDRAW_send");

  PROCEDURE Receive
   (fd      : Integer;
    buf     : System.Address;
    size    : IN OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Receive, "HIDRAW_receive");

END libsimpleio.HIDRaw;

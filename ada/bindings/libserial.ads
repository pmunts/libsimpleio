-- Minimal Ada wrapper for the Linux serial port services
-- implemented in libsimpleio.so

-- Copyright (C)2016-2025, Philip Munts dba Munts Technologies.
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

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH System;

PACKAGE libSerial IS
  PRAGMA Link_With("-lsimpleio");

  PARITY_NONE  : CONSTANT Integer := 0;
  PARITY_EVEN  : CONSTANT Integer := 1;
  PARITY_ODD   : CONSTANT Integer := 2;

  FLUSH_INPUT  : CONSTANT Integer := 0;
  FLUSH_OUTPUT : CONSTANT Integer := 1;
  FLUSH_BOTH   : CONSTANT Integer := 2;

  PROCEDURE Open
   (devname  : String;
    baudrate : Integer;
    parity   : Integer;
    databits : Integer;
    stopbits : Integer;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Open, "SERIAL_open");

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Close, "SERIAL_close");

  PROCEDURE Send
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    count    : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Send, "SERIAL_send");

  PROCEDURE Receive
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    count    : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Receive, "SERIAL_receive");

  PROCEDURE Flush
   (fd       : Integer;
    what     : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Flush, "SERIAL_flush");

END libSerial;

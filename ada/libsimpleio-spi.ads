-- Minimal Ada wrapper for the Linux SPI services
-- implemented in libsimpleio.so

-- $Id: libsimpleio-spi.ads 10104 2016-03-04 12:55:21Z svn $

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

PACKAGE libsimpleio.SPI IS

  PROCEDURE Open
   (devname  : String;
    mode     : Integer;
    wordsize : Integer;
    speed    : Integer;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Open, "SPI_open");

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Close, "SPI_close");

  PROCEDURE Transaction
   (fd       : Integer;
    cmd      : System.Address;
    cmdlen   : Integer;
    delayus  : Integer;
    resp     : System.Address;
    resplen  : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Transaction, "SPI_transaction");

END libsimpleio.SPI;

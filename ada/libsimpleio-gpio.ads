-- Minimal Ada wrapper for the Linux GPIO services
-- implemented in libsimpleio.so

-- $Id$

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

PACKAGE libsimpleio.GPIO IS

  DIRECTION_INPUT  : CONSTANT := 0;
  DIRECTION_OUTPUT : CONSTANT := 1;

  EDGE_NONE        : CONSTANT := 0;
  EDGE_RISING      : CONSTANT := 1;
  EDGE_FALLING     : CONSTANT := 2;
  EDGE_BOTH        : CONSTANT := 3;

  ACTIVELOW        : CONSTANT := 0;
  ACTIVEHIGH       : CONSTANT := 1;

  PROCEDURE Configure
   (pin       : Integer;
    direction : Integer;
    state     : Integer;
    edge      : Integer;
    polarity  : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, Configure, "GPIO_configure");

  PROCEDURE Open
   (devname  : String;
    mode     : Integer;
    wordsize : Integer;
    speed    : Integer;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Open, "GPIO_open");

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Close, "GPIO_close");

  PROCEDURE Read
   (fd       : Integer;
    state    : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Read, "GPIO_read");

  PROCEDURE Write
   (fd       : Integer;
    state    : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Write, "GPIO_write");

END libsimpleio.GPIO;

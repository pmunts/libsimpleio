-- Minimal Ada wrapper for the Linux GPIO services
-- implemented in libsimpleio.so

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE libGPIO IS
  PRAGMA Link_With("-lsimpleio");

  -- Old GPIO pin number API

  DIRECTION_INPUT     : CONSTANT Integer := 0;
  DIRECTION_OUTPUT    : CONSTANT Integer := 1;

  EDGE_NONE           : CONSTANT Integer := 0;
  EDGE_RISING         : CONSTANT Integer := 1;
  EDGE_FALLING        : CONSTANT Integer := 2;
  EDGE_BOTH           : CONSTANT Integer := 3;

  POLARITY_ACTIVELOW  : CONSTANT Integer := 0;
  POLARITY_ACTIVEHIGH : CONSTANT Integer := 1;

  PROCEDURE Configure
   (pin       : Integer;
    direction : Integer;
    state     : Integer;
    edge      : Integer;
    polarity  : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, Configure, "GPIO_configure");

  PROCEDURE Open
   (pin      : Integer;
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

  -- New GPIO descriptor API

  LINE_INFO_KERNEL         : CONSTANT Integer := 16#0001#;
  LINE_INFO_OUTPUT         : CONSTANT Integer := 16#0002#;
  LINE_INFO_ACTIVE_LOW     : CONSTANT Integer := 16#0004#;
  LINE_INFO_OPEN_DRAIN     : CONSTANT Integer := 16#0008#;
  LINE_INFO_OPEN_SOURCE    : CONSTANT Integer := 16#0010#;

  LINE_REQUEST_INPUT       : CONSTANT Integer := 16#0001#;
  LINE_REQUEST_OUTPUT      : CONSTANT Integer := 16#0002#;
  LINE_REQUEST_ACTIVE_HIGH : CONSTANT Integer := 16#0000#;
  LINE_REQUEST_ACTIVE_LOW  : CONSTANT Integer := 16#0004#;
  LINE_REQUEST_PUSH_PULL   : CONSTANT Integer := 16#0000#;
  LINE_REQUEST_OPEN_DRAIN  : CONSTANT Integer := 16#0008#;
  LINE_REQUEST_OPEN_SOURCE : CONSTANT Integer := 16#0010#;
  LINE_REQUEST_NONE        : CONSTANT Integer := 16#0000#;
  LINE_REQUEST_RISING      : CONSTANT Integer := 16#0001#;
  LINE_REQUEST_FALLING     : CONSTANT Integer := 16#0002#;
  LINE_REQUEST_BOTH        : CONSTANT Integer := 16#0003#;

  PROCEDURE GetChipInfo
   (chip      : Integer;
    name      : OUT String;
    namesize  : Integer;
    label     : OUT String;
    labelsize : Integer;
    lines     : OUT Integer;
    error     : OUT Integer);
  PRAGMA Import(C, GetChipInfo, "GPIO_chip_info");

  PROCEDURE GetLineInfo
   (chip      : Integer;
    line      : Integer;
    flags     : OUT Integer;
    name      : OUT String;
    namesize  : Integer;
    label     : OUT String;
    labelsize : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, GetLineInfo, "GPIO_line_info");

  PROCEDURE LineOpen
   (chip      : Integer;
    line      : Integer;
    flags     : Integer;
    events    : Integer;
    state     : integer;
    fd        : OUT Integer;
    error     : OUT Integer);
  PRAGMA Import(C, LineOpen, "GPIO_line_open");

  PROCEDURE LineClose
   (fd        : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, LineClose, "GPIO_line_close");

  PROCEDURE LineRead
   (fd        : Integer;
    state     : OUT Integer;
    error     : OUT Integer);
  PRAGMA Import(C, LineRead, "GPIO_line_read");

  PROCEDURE LineWrite
   (fd        : Integer;
    state     : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, LineWrite, "GPIO_line_write");

  PROCEDURE LineEvent
   (fd        : Integer;
    state     : OUT Integer;
    error     : OUT Integer);
  PRAGMA Import(C, LineEvent, "GPIO_line_event");

END libGPIO;

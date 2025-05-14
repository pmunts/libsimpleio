-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Interfaces.C.Strings;

WITH Wio_E5.Ham2;

PACKAGE libWioE5Ham2 IS

  PACKAGE LoRA IS NEW Wio_E5.Ham2;

  PROCEDURE Initialize
   (portname   : Interfaces.C.Strings.chars_ptr;
    baudrate   : Integer;
    network    : Interfaces.C.Strings.chars_ptr;
    node       : Integer;
    freqmhz    : Float;
    spreading  : Integer;
    bandwidth  : Integer;
    txpreamble : Integer;
    rxpreamble : Integer;
    txpower    : Integer;
    handle     : OUT Integer;
    err        : OUT Integer);

  PROCEDURE Shutdown
   (handle     : Integer;
    err        : OUT Integer);

  PROCEDURE Receive
   (handle     : Integer;
    msg        : OUT LoRa.Payload;
    len        : OUT Integer;
    srcnet     : Interfaces.C.Strings.chars_ptr;
    srcnode    : OUT Integer;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : OUT Integer;
    RSS        : OUT Integer;
    SNR        : OUT Integer;
    err        : OUT Integer);

  PROCEDURE Send
   (handle     : Integer;
    msg        : LoRa.Payload;
    len        : Integer;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : Integer;
    err        : OUT Integer);

  PROCEDURE SendString
   (handle     : Integer;
    outbuf     : Interfaces.C.Strings.chars_ptr;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : Integer;
    err        : OUT Integer);

  PRAGMA Export(Convention => C, Entity => Initialize, External_Name => "wioe5ham2_init");
  PRAGMA Export(Convention => C, Entity => Shutdown  , External_Name => "wioe5ham2_exit");
  PRAGMA Export(Convention => C, Entity => Receive,    External_Name => "wioe5ham2_receive");
  PRAGMA Export(Convention => C, Entity => Send,       External_Name => "wioe5ham2_send");
  PRAGMA Export(Convention => C, Entity => SendString, External_Name => "wioe5ham2_send_string");

END libWioE5Ham2;

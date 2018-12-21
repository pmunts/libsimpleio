-- Minimal Ada wrapper for the Linux D/A services
-- implemented in libsimpleio.so

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE libDAC IS
  PRAGMA Link_With("-lsimpleio");

  PROCEDURE GetName
   (chip    : Integer;
    name    : OUT String;
    size    : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, GetName, "DAC_get_name");

  PROCEDURE Open
   (chip    : Integer;
    channel : Integer;
    fd      : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Open, "DAC_open");

  PROCEDURE Close
   (fd      : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Close, "DAC_close");

  PROCEDURE Write
   (fd      : Integer;
    sample  : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Write, "DAC_write");
END libDAC;

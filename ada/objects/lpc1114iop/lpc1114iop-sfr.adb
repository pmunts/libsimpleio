-- Raspberry Pi LPC1114 I/O Processor Expansion Board SFR services

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY LPC1114IOP.SFR IS

  -- Thin binding to libsimpleio.so

  PROCEDURE spiagent_sfr_get
   (address : sfr_address;
    data    : OUT sfr_data;
    error   : OUT Integer);

  PRAGMA Import(C, spiagent_sfr_get);

  PROCEDURE spiagent_sfr_put
   (address : sfr_address;
    data    : sfr_data;
    error   : OUT Integer);

  PRAGMA Import(C, spiagent_sfr_put);

  -- Create an LPC1114 special function register instance

  FUNCTION Create(address : sfr_address) RETURN SFR IS

  BEGIN
    IF ((address >= 16#40000000#) AND (address <= 16#4007FFFF#)) OR
       ((address >= 16#50000000#) AND (address <= 16#501FFFFF#)) THEN
      RETURN SFR'(address => address);
    ELSE
      RAISE LPC1114IOP.Error WITH "Illegal SFR address";
    END IF;
  END Create;

  -- Read from LPC1114 special function register

  FUNCTION Get(reg : SFR) RETURN sfr_data IS

    data  : sfr_data;
    error : Integer;

  BEGIN
    spiagent_sfr_get(reg.address, data, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_sfr_get() failed, error" & error'Image;
    END IF;

    RETURN data;
  END Get;

  -- Write to LPC1114 special function register

  PROCEDURE Put(reg : SFR; data : sfr_data) IS

    error : Integer;

  BEGIN
    spiagent_sfr_put(reg.address, data, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_sfr_put() failed, error" & error'Image;
    END IF;
  END Put;

END LPC1114IOP.SFR;

-- TLC1543 Analog to Digital Converter services

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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

-- Adapted from the C example at:
--
-- http://www.pibits.net/code/using-the-tlc1543-with-a-raspberry-pi.php
--
-- It is not at all clear how this works:  The ARPI600 has both the TLC1543
-- CS input and the EOC output disconnected.

WITH Interfaces;

USE TYPE Interfaces.Unsigned_16;

PACKAGE BODY TLC1543 IS

  -- Constructors

  FUNCTION Create
   (clk  : GPIO.Pin;
    addr : GPIO.Pin;
    data : GPIO.Pin) RETURN Device IS

  BEGIN
    RETURN NEW DeviceClass'(clk, addr, data);
  END Create;

  FUNCTION Create
   (dev  : DeviceClass;
    chan : Channel) RETURN Analog.Input IS

  BEGIN
    RETURN NEW InputSubclass'(dev, chan);
  END Create;

  -- Methods

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Analog.Sample IS

    sr : Interfaces.Unsigned_16;

  BEGIN
    sr := Interfaces.Shift_Left(Interfaces.Unsigned_16(self.chan), 4);

    FOR i IN NATURAL RANGE 0 .. 3 LOOP
      IF (sr AND 16#0080#) /= 16#0000# THEN
        self.dev.addr.Put(True);
      ELSE
        self.dev.addr.Put(False);
      END IF;

      self.dev.clk.Put(True);
      self.dev.clk.Put(False);

      sr := Interfaces.Shift_Left(sr, 1);
    END LOOP;

    FOR i IN NATURAL RANGE 0 .. 5 LOOP
      self.dev.clk.Put(True);
      self.dev.clk.Put(False);
    END LOOP;

    DELAY 15.0E-6;

    sr := 16#0000#;

    FOR i IN NATURAL RANGE 0 .. 9 LOOP
      sr := Interfaces.Shift_Left(sr, 1);

      self.dev.clk.Put(True);

      IF self.dev.data.Get THEN
        sr := sr OR 1;
      END IF;

      self.dev.clk.Put(False);
    END LOOP;

    RETURN Analog.Sample(sr);
  END Get;

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN TLC1543.Resolution;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

END TLC1543;

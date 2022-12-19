-- Mikroelektronika Click Board shield services, using libsimpleio

-- Copyright (C)2016-2022, Philip Munts, President, Munts AM Corp.
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

PACKAGE ClickBoard.Shields IS

  ShieldError : EXCEPTION;

  -- These are the supported ClickBoard shields

  TYPE Kind IS
  (None,              -- No shield installed
   PiClick1,          -- Raspberry Pi with MIKROE-1513/1512, with 1 socket
   PiClick2,          -- Raspberry Pi with MIKROE-1879, with 2 sockets
   PiClick3,          -- Raspberry Pi with MIKROE-2756, with 2 sockets
   BeagleBoneClick2,  -- BeagleBone with MIKROE-1596, with 2 sockets
   BeagleBoneClick4,  -- BeagleBone with MIKROE-1857, with 4 sockets
   PocketBeagle);     -- PocketBeagle with 2 sockets

  -- Detect the kind of ClickBoard shield we are using

  FUNCTION Detect RETURN Kind;

END ClickBoard.Shields;

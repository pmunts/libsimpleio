-- Watchdog timer device services using libsimpleio

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

PACKAGE Watchdog.libsimpleio IS

  DefaultTimer  : CONSTANT String   := "/dev/watchdog";
  DefaultTimeout : CONSTANT Duration := 0.0;

  TYPE TimerSubclass IS NEW Watchdog.TimerInterface WITH PRIVATE;

  -- Watchdog device object constructor

  FUNCTION Create
   (devname : String   := DefaultTimer;
    timeout : Duration := DefaultTimeout) RETURN Watchdog.Timer;

  -- Method to get the watchdog timeout in seconds

  FUNCTION GetTimeout(self : TimerSubclass) RETURN Duration;

  -- Method to change the watchdog timeout in seconds

  PROCEDURE SetTimeout(self : TimerSubclass; timeout : Duration);

  -- Method to reset the watchdog timer

  PROCEDURE Kick(self : TimerSubclass);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(self : TimerSubclass) RETURN Integer;

PRIVATE

  TYPE TimerSubclass IS NEW Watchdog.TimerInterface WITH RECORD
    fd : Integer;
  END RECORD;

END Watchdog.libsimpleio;

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

PACKAGE libRemoteIO.PWM IS

  PROCEDURE PWM_Configure
   (handle     : Integer;
    channel    : Integer;
    frequency  : Integer;
    error      : OUT Integer);

  PROCEDURE PWM_Write
   (handle     : Integer;
    channel    : Integer;
    duty       : Float;
    error      : OUT Integer);

  PROCEDURE PWM_Channels
   (handle    : Integer;
    channels  : OUT ChannelArray;
    error     : OUT Integer);

PRIVATE

  PRAGMA Export(Convention => C, Entity => PWM_Configure, External_Name => "pwm_configure");
  PRAGMA Export(Convention => C, Entity => PWM_Write,     External_Name => "pwm_write");
  PRAGMA Export(Convention => C, Entity => PWM_Channels,  External_Name => "pwm_channels");

END libRemoteIO.PWM;

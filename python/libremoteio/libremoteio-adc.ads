-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE libRemoteIO.ADC IS

  PROCEDURE ADC_Configure
   (handle     : Interfaces.C.int;
    channel    : Interfaces.C.int;
    resolution : OUT Interfaces.C.int;
    error      : OUT Interfaces.C.int);

  PROCEDURE ADC_Read
   (handle     : Interfaces.C.int;
    channel    : Interfaces.C.int;
    sample     : OUT Interfaces.C.int;
    error      : OUT Interfaces.C.int);

  PROCEDURE ADC_Channels
   (handle    : Interfaces.C.int;
    channels  : OUT ChannelArray;
    error     : OUT Interfaces.C.int);

PRIVATE

  PRAGMA Export(Convention => C, Entity => ADC_Configure, External_Name => "adc_configure");
  PRAGMA Export(Convention => C, Entity => ADC_Read,      External_Name => "adc_read");
  PRAGMA Export(Convention => C, Entity => ADC_Channels,  External_Name => "adc_channels");

END libRemoteIO.ADC;

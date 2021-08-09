-- Grove I2C Motor Driver TB6612 DC Motor Services

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

-- See also: https://wiki.seeedstudio.com/Grove-I2C_Motor_Driver-TB6612FNG

WITH Motor;

PACKAGE Grove_TB6612.Motor IS

  -- Grove TB6612 DC motor output channels

  TYPE Channels IS (ChannelA, ChannelB);

  -- Grove TB6612 DC motor output type

  TYPE OutputClass IS NEW Standard.Motor.OutputInterface WITH PRIVATE;

  -- Grove TB6612 DC motor output output constructor

  FUNCTION Create
   (dev  : NOT NULL Device;
    chan : Channels;
    V    : Standard.Motor.Velocity := 0.0) RETURN Standard.Motor.Output;

  -- Grove TB6612 DC motor output initializer

  PROCEDURE Initialize
   (Self : IN OUT OutputClass;
    dev  : NOT NULL Device;
    chan : Channels;
    V    : Standard.Motor.Velocity := 0.0);

  -- Motor interface methods

  PROCEDURE Put
   (Self : IN OUT OutputClass;
    V    : Standard.Motor.Velocity);

PRIVATE

  TYPE OutputClass IS NEW Standard.Motor.OutputInterface WITH RECORD
    dev  : Device;
    chan : Channels;
  END RECORD;

END Grove_TB6612.Motor;

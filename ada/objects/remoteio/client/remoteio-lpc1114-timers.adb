-- LPC1114 I/O Processor 32-bit Counter/Timer services

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY RemoteIO.LPC1114.Timers IS

 -- Constructor

  FUNCTION Create
   (absdev : NOT NULL RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32) RETURN Timer IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Validate parameters

    IF desg > RemoteIO.LPC1114.LPC1114_CT32B1 THEN
      RAISE Timer_Error WITH "Invalid timer designator";
    END IF;

    cmd.Command := SPIAGENT_CMD_INIT_TIMER;
    cmd.Pin     := desg;
    cmd.Data    := 0;

    absdev.Operation(cmd, resp);

    RETURN NEW TimerClass'(absdev, desg);
  END Create;

  -- Methods

  PROCEDURE Reset(Self : TimerClass) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := SPIAGENT_CMD_INIT_TIMER;
    cmd.Pin     := Self.desg;
    cmd.Data    := 0;

    Self.dev.Operation(cmd, resp);
  END Reset;

  PROCEDURE Configure_Mode
   (Self    : TimerClass;
    mode    : Interfaces.Unsigned_32) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Validate parameters

    IF mode > RemoteIO.LPC1114.LPC1114_TIMER_MODE_CAP0_BOTH THEN
      RAISE Timer_Error WITH "Invalid timer mode parameter";
    END IF;

    cmd.Command := SPIAGENT_CMD_CONFIGURE_TIMER_MODE;
    cmd.Pin     := Self.desg;
    cmd.Data    := mode;

    Self.dev.Operation(cmd, resp);
  END Configure_Mode;

  PROCEDURE Configure_Prescaler
   (Self    : TimerClass;
    divisor : Interfaces.Unsigned_32) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER;
    cmd.Pin     := Self.desg;
    cmd.Data    := divisor;

    Self.dev.Operation(cmd, resp);
  END Configure_Prescaler;

  PROCEDURE Configure_Capture
   (Self    : TimerClass;
    edge    : Interfaces.Unsigned_32) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Validate parameters

    IF edge > RemoteIO.LPC1114.LPC1114_TIMER_CAPTURE_EDGE_CAP0_BOTH THEN
      RAISE Timer_Error WITH "Invalid capture edge parameter";
    END IF;

    cmd.Command := SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE;
    cmd.Pin     := Self.desg;
    cmd.Data    := edge;

    Self.dev.Operation(cmd, resp);
  END Configure_Capture;

  PROCEDURE Configure_Match_Action
   (Self    : TimerClass;
    reg     : Interfaces.Unsigned_32;
    action  : Interfaces.Unsigned_32;
    reset   : Boolean;
    stop    : Boolean) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Validate parameters

    IF reg > RemoteIO.LPC1114.LPC1114_TIMER_MATCH3 THEN
      RAISE Timer_Error WITH "Invalid match register parameter";
    END IF;

    IF action > RemoteIO.LPC1114.LPC1114_TIMER_MATCH_OUTPUT_TOGGLE THEN
      RAISE Timer_Error WITH "Invalid match action parameter";
    END IF;

    cmd.Command := SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0 + reg;
    cmd.Pin     := Self.desg;
    cmd.Data    := action;

    IF reset THEN
      cmd.Data := cmd.Data OR RemoteIO.LPC1114.LPC1114_TIMER_MATCH_RESET;
    END IF;

    IF stop THEN
      cmd.Data := cmd.Data OR RemoteIO.LPC1114.LPC1114_TIMER_MATCH_STOP;
    END IF;

    Self.dev.Operation(cmd, resp);
  END Configure_Match_Action;

  PROCEDURE Configure_Match_Value
   (Self    : TimerClass;
    reg     : Interfaces.Unsigned_32;
    value   : Interfaces.Unsigned_32) IS

    cmd  : RemoteIO.LPC1114.SPIAGENT_COMMAND_MSG_t;
    resp : RemoteIO.LPC1114.SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    -- Validate parameters

    IF reg > RemoteIO.LPC1114.LPC1114_TIMER_MATCH3 THEN
      RAISE Timer_Error WITH "Invalid match register parameter";
    END IF;

    cmd.Command := SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE + reg;
    cmd.Pin     := Self.desg;
    cmd.Data    := value;

    Self.dev.Operation(cmd, resp);
  END Configure_Match_Value;

END RemoteIO.LPC1114.Timers;

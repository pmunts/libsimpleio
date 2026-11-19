-- Raspberry Pi LPC1114 I/O Processor Expansion Board timer services

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

WITH Interfaces;

WITH LPC1114IOP.Commands;   USE LPC1114IOP.Commands;
WITH LPC1114IOP.Messages;   USE LPC1114IOP.Messages;
WITH LPC1114IOP.Transport;

USE TYPE Interfaces.Unsigned_32;

PACKAGE BODY LPC1114IOP.Timer IS

  FUNCTION Create(id : timer_id_t) RETURN Timer IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_INIT_TIMER);
    cmd.pin     := timer_id_t'POS(id);
    cmd.data    := 0;

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN timer'(id => id);
  END Create;

  PROCEDURE ConfigureMode
   (self  : Timer;
    mode  : timer_mode_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_TIMER_MODE);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := timer_mode_t'POS(mode);

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigureMode;

  PROCEDURE ConfigurePrescaler
   (self      : Timer;
    prescaler : timer_prescaler_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := Interfaces.Unsigned_32(prescaler);

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigurePrescaler;

  PROCEDURE ConfigureCapture
   (self      : Timer;
    edge      : capture_edge_t;
    interrupt : capture_interrupt_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := capture_edge_t'POS(edge) OR
      Interfaces.Shift_Left(Interfaces.Unsigned_32(capture_interrupt_t'POS(interrupt)), 4);

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigureCapture;

  PROCEDURE ConfigureMatch
   (self      : Timer;
    reg       : timer_match_register_t;
    value     : timer_count_t;
    action    : timer_match_output_action_t;
    interrupt : timer_match_interrupt_t;
    reset     : timer_match_reset_t;
    stop      : timer_match_stop_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0) +
      timer_match_register_t'POS(reg);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := timer_match_output_action_t'POS(action) OR
      Interfaces.Shift_Left(Interfaces.Unsigned_32(timer_match_interrupt_t'POS(interrupt)), 4) OR
      Interfaces.Shift_Left(Interfaces.Unsigned_32(timer_match_reset_t'POS(reset)), 5) OR
      Interfaces.Shift_left(Interfaces.Unsigned_32(timer_match_stop_t'POS(stop)), 6);

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE) +
      timer_match_register_t'POS(reg);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := Interfaces.Unsigned_32(value);

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigureMatch;

  FUNCTION Get(self : Timer) RETURN timer_count_t IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_TIMER_VALUE);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := 0;

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN timer_count_t(resp.data);
  END Get;

  FUNCTION GetCapture(self : Timer) RETURN timer_count_t IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_TIMER_CAPTURE);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := 0;

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN timer_count_t(resp.data);
  END GetCapture;

  FUNCTION GetCaptureDelta(self : Timer) RETURN timer_count_t IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_TIMER_CAPTURE_DELTA);
    cmd.pin     := timer_id_t'POS(self.id);
    cmd.data    := 0;

    -- Issue the command to the LPC1114 SPI Firmware Agent

    LPC1114IOP.Transport.command(cmd, resp, error);

    -- Check for error return from LPC1114IOP.Transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "LPC1114IOP.Transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN timer_count_t(resp.data);
  END GetCaptureDelta;

END LPC1114IOP.Timer;

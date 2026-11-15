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

PACKAGE spi_agent.timer IS

  PCLK_FREQUENCY : CONSTANT := 48000000;

  TYPE timer_id_t IS (
    LPC1114_CT32B0,
    LPC1114_CT32B1);

  TYPE timer_mode_t IS (
    LPC1114_TIMER_MODE_DISABLED,
    LPC1114_TIMER_MODE_RESET,
    LPC1114_TIMER_MODE_PCLK,
    LPC1114_TIMER_MODE_CAP0_RISING,
    LPC1114_TIMER_MODE_CAP0_FALLING,
    LPC1114_TIMER_MODE_CAP0_BOTH);

  TYPE capture_edge_t IS (
    LPC1114_TIMER_CAPTURE_EDGE_DISABLED,
    LPC1114_TIMER_CAPTURE_EDGE_CAP0_RISING,
    LPC1114_TIMER_CAPTURE_EDGE_CAP0_FALLING,
    LPC1114_TIMER_CAPTURE_EDGE_CAP0_BOTH);

  TYPE capture_interrupt_t IS (
    LPC1114_TIMER_CAPTURE_INTERRUPT_DISABLE,
    LPC1114_TIMER_CAPTURE_INTERRUPT_ENABLE);

  TYPE timer_match_register_t IS (
    LPC1114_TIMER_MATCH0,
    LPC1114_TIMER_MATCH1,
    LPC1114_TIMER_MATCH2,
    LPC1114_TIMER_MATCH3);

  TYPE timer_match_output_action_t IS (
    LPC1114_TIMER_MATCH_OUTPUT_DISABLED,
    LPC1114_TIMER_MATCH_OUTPUT_CLEAR,
    LPC1114_TIMER_MATCH_OUTPUT_SET,
    LPC1114_TIMER_MATCH_OUTPUT_TOGGLE);

  TYPE timer_match_interrupt_t IS (
    LPC1114_TIMER_MATCH_INTERRUPT_DISABLE,
    LPC1114_TIMER_MATCH_INTERRUPT_ENABLE);

  TYPE timer_match_reset_t IS (
    LPC1114_TIMER_MATCH_RESET_DISABLE,
    LPC1114_TIMER_MATCH_RESET_ENABLE);

  TYPE timer_match_stop_t IS (
    LPC1114_TIMER_MATCH_STOP_DISABLE,
    LPC1114_TIMER_MATCH_STOP_ENABLE);

  TYPE timer_prescaler_t IS MOD 2 ** 32;

  TYPE timer_count_t IS MOD 2 ** 32;

  TYPE Timer IS TAGGED PRIVATE;

  -- Timer services

  FUNCTION Create(id : timer_id_t) RETURN Timer;

  PROCEDURE ConfigureMode
   (self      : Timer;
    mode      : timer_mode_t);

  PROCEDURE ConfigurePrescaler
   (self      : Timer;
    prescaler : timer_prescaler_t);

  PROCEDURE ConfigureCapture
   (self      : Timer;
    edge      : capture_edge_t;
    interrupt : capture_interrupt_t);

  PROCEDURE ConfigureMatch
   (self      : Timer;
    reg       : timer_match_register_t;
    value     : timer_count_t;
    action    : timer_match_output_action_t;
    interrupt : timer_match_interrupt_t;
    reset     : timer_match_reset_t;
    stop      : timer_match_stop_t);

  FUNCTION Get(self : Timer) RETURN timer_count_t;

  FUNCTION GetCapture(self : Timer) RETURN timer_count_t;

  FUNCTION GetCaptureDelta(self : Timer) RETURN timer_count_t;

PRIVATE
  TYPE Timer IS TAGGED RECORD
    id : timer_id_t;
  END RECORD;
END spi_agent.timer;

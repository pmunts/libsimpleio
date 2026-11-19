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

WITH libspiagent;

PACKAGE LPC1114IOP.Timer IS

  TYPE timer_prescaler_t IS MOD 2 ** 32;
  TYPE timer_count_t     IS MOD 2 ** 32;
  TYPE TimerClass        IS TAGGED PRIVATE;
  TYPE Timer             IS ACCESS ALL TimerClass'Class;

  -- Rename some types from the thin binding package libspiagent

  SUBTYPE timer_id_t                IS libspiagent.timer_id_t;
  SUBTYPE timer_mode_t              IS libspiagent.timer_mode_t;
  SUBTYPE timer_capture_edge_t      IS libspiagent.timer_capture_edge_t;
  SUBTYPE timer_capture_interrupt_t IS libspiagent.timer_capture_interrupt_t;
  SUBTYPE timer_match_register_t    IS libspiagent.timer_match_register_t;
  SUBTYPE timer_match_action_t      IS libspiagent.timer_match_action_t;
  SUBTYPE timer_match_interrupt_t   IS libspiagent.timer_match_interrupt_t;
  SUBTYPE timer_match_reset_t       IS libspiagent.timer_match_reset_t;
  SUBTYPE timer_match_stop_t        IS libspiagent.timer_match_stop_t;

  -- Timer object constructor

  FUNCTION Create(id : libspiagent.timer_id_t) RETURN Timer;

  -- Timer object initializer

  PROCEDURE Initialize
   (self      : TimerClass;
    id        : timer_id_t);

  -- Timer object methods

  PROCEDURE ConfigureMode
   (self      : TimerClass;
    mode      : timer_mode_t);

  PROCEDURE ConfigurePrescaler
   (self      : TimerClass;
    prescaler : timer_prescaler_t);

  PROCEDURE ConfigureCapture
   (self      : TimerClass;
    edge      : timer_capture_edge_t;
    intr      : timer_capture_interrupt_t);

  PROCEDURE ConfigureMatch
   (self      : TimerClass;
    reg       : timer_match_register_t;
    value     : timer_count_t;
    action    : timer_match_action_t;
    intr      : timer_match_interrupt_t;
    reset     : timer_match_reset_t;
    stop      : timer_match_stop_t);

  FUNCTION Get(self : TimerClass) RETURN timer_count_t;

  FUNCTION GetCapture(self : TimerClass) RETURN timer_count_t;

  FUNCTION GetCaptureDelta(self : TimerClass) RETURN timer_count_t;

PRIVATE
  TYPE TimerClass IS TAGGED RECORD
    id : libspiagent.timer_id_t;
  END RECORD;
END LPC1114IOP.Timer;

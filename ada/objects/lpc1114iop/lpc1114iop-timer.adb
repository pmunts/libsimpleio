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

WITH Discrete_To_Unsigned;
WITH Interfaces.C;

WITH libspiagent; USE libspiagent;

USE TYPE Interfaces.C.int;
USE TYPE Interfaces.C.unsigned;

PACKAGE BODY LPC1114IOP.Timer IS

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(timer_count_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(timer_prescaler_t);

  -- Timer object constructor

  FUNCTION Create(id : timer_id_t) RETURN Timer IS

    self : TimerClass;

  BEGIN
    self.Initialize(id);
    RETURN NEW TimerClass'(self);
  END Create;

  -- Timer object initializer

  PROCEDURE Initialize
   (self      : TimerClass;
    id        : timer_id_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_init(To_Unsigned(id), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_init() failed, error" &
        error'Image;
    END IF;
  END Initialize;

  PROCEDURE ConfigureMode
   (self      : TimerClass;
    mode      : timer_mode_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_configure_mode(To_Unsigned(self.id), To_Unsigned(mode), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_configure_mode() failed, error" &
        error'Image;
    END IF;
  END ConfigureMode;

  PROCEDURE ConfigurePrescaler
   (self      : TimerClass;
    prescaler : timer_prescaler_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_configure_prescaler(To_Unsigned(self.id),
      To_Unsigned(prescaler), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_configure_prescaler() failed, error" &
        error'Image;
    END IF;
  END ConfigurePrescaler;

  PROCEDURE ConfigureCapture
   (self      : TimerClass;
    edge      : timer_capture_edge_t;
    intr      : timer_capture_interrupt_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_configure_capture(To_Unsigned(self.id), To_Unsigned(edge),
      To_Unsigned(intr), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_configure_capture() failed, error" &
        error'Image;
    END IF;
  END ConfigureCapture;

  PROCEDURE ConfigureMatch
   (self      : TimerClass;
    reg       : timer_match_register_t;
    value     : timer_count_t;
    action    : timer_match_action_t;
    intr      : timer_match_interrupt_t;
    reset     : timer_match_reset_t;
    stop      : timer_match_stop_t) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_configure_match(To_Unsigned(self.id), To_Unsigned(reg),
      To_Unsigned(value), To_Unsigned(action), To_Unsigned(intr),
      To_Unsigned(reset), To_Unsigned(stop), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_configure_match() failed, error" &
        error'Image;
    END IF;
  END ConfigureMatch;

  FUNCTION Get(self : TimerClass) RETURN timer_count_t IS

    count : Interfaces.C.unsigned;
    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_get(To_Unsigned(self.id), count, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_get() failed, error" &
        error'Image;
    END IF;

    RETURN timer_count_t(count);
  END Get;

  FUNCTION GetCapture(self : TimerClass) RETURN timer_count_t IS

    count : Interfaces.C.unsigned;
    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_get_capture(To_Unsigned(self.id), count, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_get_capture() failed, error" &
        error'Image;
    END IF;

    RETURN timer_count_t(count);
  END GetCapture;

  FUNCTION GetCaptureDelta(self : TimerClass) RETURN timer_count_t IS

    count : Interfaces.C.unsigned;
    error : Interfaces.C.int;

  BEGIN
    spiagent_timer_get_capture_delta(To_Unsigned(self.id), count, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_timer_get_capture_delta() failed, error" &
        error'Image;
    END IF;

    RETURN timer_count_t(count);
  END GetCaptureDelta;

END LPC1114IOP.Timer;

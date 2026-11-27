-- Thin binding to libspiagent.so for the Raspberry Pi LPC1114 I/O Processor

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

WITH Interfaces.C;

PACKAGE libspiagent IS
  PRAGMA Link_With("-lspiagent");

-------------------------------------------------------------------------------

  -- Initialize the SPI Agent Firmware transport library

  PROCEDURE spiagent_open(servername : String; error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_open);

  -- Deinitialize the SPI Agent Firmware transport library

  PROCEDURE spiagent_close(error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_close);

-------------------------------------------------------------------------------

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware command structure

  TYPE SPIAGENT_COMMAND_MSG_t IS RECORD
    command : Interfaces.C.unsigned;
    pin     : Interfaces.C.unsigned;
    data    : Interfaces.C.unsigned;
  END RECORD WITH Convention => C;

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware response structure

  TYPE SPIAGENT_RESPONSE_MSG_t IS RECORD
    command : Interfaces.C.unsigned;
    pin     : Interfaces.C.unsigned;
    data    : Interfaces.C.unsigned;
    error   : Interfaces.C.unsigned;
  END RECORD WITH Convention => C;

  -- Dispatch an SPI Agent Firmware command to the transport library

  PROCEDURE spiagent_command
   (command  : IN SPIAGENT_COMMAND_MSG_t;
    response : OUT SPIAGENT_RESPONSE_MSG_t;
    error    : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_command);

-------------------------------------------------------------------------------

  -- ADC input services

  PROCEDURE spiagent_analog_configure
   (pin   : Interfaces.C.unsigned;
    error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_analog_configure);

  PROCEDURE spiagent_analog_get
   (pin   : Interfaces.C.unsigned;
    volts : OUT Interfaces.C.C_float;
    error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_analog_get);

-------------------------------------------------------------------------------

  -- GPIO pin services

  PROCEDURE spiagent_gpio_configure
   (pin       : Interfaces.C.unsigned;
    direction : Interfaces.C.unsigned;
    state     : Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_gpio_configure);

  PROCEDURE spiagent_gpio_configure_mode
   (pin       : Interfaces.C.unsigned;
    mode      : Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_gpio_configure_mode);

  PROCEDURE spiagent_gpio_configure_interrupt
   (pin       : Interfaces.C.unsigned;
    intconfig : Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_gpio_configure_interrupt);

  PROCEDURE spiagent_gpio_get
   (pin       : Interfaces.C.unsigned;
    state     : OUT Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_gpio_get);

  PROCEDURE spiagent_gpio_put
   (pin       : Interfaces.C.unsigned;
    state     : Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_gpio_put);

-------------------------------------------------------------------------------

  -- Interrupt services

  PROCEDURE spiagent_interrupt_enable(error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_interrupt_enable);

  PROCEDURE spiagent_interrupt_disable(error : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_interrupt_disable);

  PROCEDURE interrupt_wait
   (timeout : Interfaces.C.int;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, interrupt_wait, "spiagent_interrupt_wait");

-------------------------------------------------------------------------------

  -- LEGO Power Functions Remote Control services

  PROCEDURE spiagent_legorc_put
   (pin       : Interfaces.C.unsigned;
    channel   : Interfaces.C.unsigned;
    motor     : Interfaces.C.unsigned;
    direction : Interfaces.C.unsigned;
    speed     : Interfaces.C.unsigned;
    error     : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_legorc_put);

-------------------------------------------------------------------------------

  -- PWM output services

  PROCEDURE spiagent_pwm_configure
   (pin    : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_configure);

  PROCEDURE spiagent_pwm_set_frequency
   (freq   : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_set_frequency);

  PROCEDURE spiagent_pwm_put
   (pin    : Interfaces.C.unsigned;
    duty   : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_put);

  PROCEDURE spiagent_servo_configure
   (pin    : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_servo_configure);

  PROCEDURE spiagent_servo_put
   (pin    : Interfaces.C.unsigned;
    posi   : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_servo_put);

  PROCEDURE spiagent_motor_configure
   (pwmpin : Interfaces.C.unsigned;
    dirpin : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_motor_configure);

  PROCEDURE spiagent_motor_put
   (pwmpin : Interfaces.C.unsigned;
    dirpin : Interfaces.C.unsigned;
    speed  : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_motor_put);

-------------------------------------------------------------------------------

  -- Special Function Register services

  PROCEDURE spiagent_sfr_get
   (address : Interfaces.C.unsigned;
    data    : OUT Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_sfr_get);

  PROCEDURE spiagent_sfr_put
   (address : Interfaces.C.unsigned;
    data    : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_sfr_put);

-------------------------------------------------------------------------------

  -- Timer services

  PROCEDURE spiagent_timer_init
   (timer   : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_init);

  PROCEDURE spiagent_timer_configure_mode
   (timer   : Interfaces.C.unsigned;
    mode    : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_configure_mode);

  PROCEDURE spiagent_timer_configure_prescaler
   (timer   : Interfaces.C.unsigned;
    divisor : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_configure_prescaler);

  PROCEDURE spiagent_timer_configure_capture
   (timer   : Interfaces.C.unsigned;
    edge    : Interfaces.C.unsigned;
    intr    : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_configure_capture);

  PROCEDURE spiagent_timer_configure_match
   (timer   : Interfaces.C.unsigned;
    reg     : Interfaces.C.unsigned;
    value   : Interfaces.C.unsigned;
    action  : Interfaces.C.unsigned;
    intr    : Interfaces.C.unsigned;
    reset   : Interfaces.C.unsigned;
    stop    : Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_configure_match);

  PROCEDURE spiagent_timer_get
   (timer   : Interfaces.C.unsigned;
    count   : OUT Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_get);

  PROCEDURE spiagent_timer_get_capture
   (timer   : Interfaces.C.unsigned;
    count   : OUT Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_get_capture);

  PROCEDURE spiagent_timer_get_capture_delta
   (timer   : Interfaces.C.unsigned;
    count   : OUT Interfaces.C.unsigned;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_timer_get_capture_delta);

END libspiagent;

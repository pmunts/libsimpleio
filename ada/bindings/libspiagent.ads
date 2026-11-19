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

WITH Discrete_To_Unsigned;
WITH GPIO;
WITH lpc11xx;

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

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware command constants

  TYPE SPIAGENT_COMMAND_t IS
   (SPIAGENT_CMD_NOP,
    SPIAGENT_CMD_LOOPBACK,
    SPIAGENT_CMD_CONFIGURE_ANALOG_INPUT,
    SPIAGENT_CMD_CONFIGURE_GPIO_INPUT,
    SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT,
    SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT,
    SPIAGENT_CMD_GET_ANALOG,
    SPIAGENT_CMD_GET_GPIO,
    SPIAGENT_CMD_PUT_GPIO,
    SPIAGENT_CMD_PUT_PWM,
    SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT,
    SPIAGENT_CMD_CONFIGURE_GPIO,
    SPIAGENT_CMD_PUT_LEGORC,
    SPIAGENT_CMD_GET_SFR,
    SPIAGENT_CMD_PUT_SFR,
    SPIAGENT_CMD_CONFIGURE_TIMER_MODE,
    SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER,
    SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1_VALUE,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2_VALUE,
    SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3_VALUE,
    SPIAGENT_CMD_GET_TIMER_VALUE,
    SPIAGENT_CMD_GET_TIMER_CAPTURE,
    SPIAGENT_CMD_GET_TIMER_CAPTURE_DELTA,
    SPIAGENT_CMD_INIT_TIMER);

  -- Type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(SPIAGENT_COMMAND_t);

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware command structure

  TYPE SPIAGENT_COMMAND_MSG_t IS RECORD
    command : Interfaces.C.unsigned;
    pin     : Interfaces.C.unsigned;
    data    : Interfaces.C.unsigned;
  END RECORD;

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware response structure

  TYPE SPIAGENT_RESPONSE_MSG_t IS RECORD
    command : Interfaces.C.unsigned;
    pin     : Interfaces.C.unsigned;
    data    : Interfaces.C.unsigned;
    error   : Interfaces.C.unsigned;
  END RECORD;

  -- Dispatch an SPI Agent Firmware command to the transport library

  PROCEDURE spiagent_command
   (command  : IN SPIAGENT_COMMAND_MSG_t;
    response : OUT SPIAGENT_RESPONSE_MSG_t;
    error    : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_command);

-------------------------------------------------------------------------------

  -- ADC input configuration constants

  ADC_SPAN     : constant := 3.3;		-- Volts
  ADC_BITS     : constant := 10;		-- Bits
  ADC_STEPS    : constant := 1024;		-- Levels
  ADC_STEPSIZE : constant := 0.00322265625;	-- Volts

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

  -- GPIO pin configuration constants

  TYPE gpio_direction_t IS
   (GPIO_DIRECTION_INPUT,
    GPIO_DIRECTION_OUTPUT);

  TYPE gpio_mode_t IS
   (GPIO_MODE_INPUT,			-- Normal high impedance input
    GPIO_MODE_INPUT_PULLDOWN,
    GPIO_MODE_INPUT_PULLUP,
    GPIO_MODE_OUTPUT,			-- Normal push-pull output
    GPIO_MODE_OUTPUT_OPENDRAIN);

  TYPE gpio_interrupt_config_t IS
   (GPIO_INTERRUPT_DISABLED,
    GPIO_INTERRUPT_FALLING,
    GPIO_INTERRUPT_RISING,
    GPIO_INTERRUPT_BOTH);

  -- GPIO pin type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(Boolean);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(GPIO.Direction);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(gpio_mode_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(gpio_direction_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(gpio_interrupt_config_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(lpc11xx.pin_id_t);

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
    pin     : OUT Interfaces.C.int;
    error   : OUT Interfaces.C.int);

  PRAGMA Import(C, interrupt_wait, "spiagent_interrupt_wait");

-------------------------------------------------------------------------------

  -- LEGO Power Functions Remote Control configuration constants

  TYPE legorc_channel_t IS NEW Natural RANGE 1 .. 4;

  TYPE legorc_motor_t IS
   (ALLSTOP,
    MOTORA,
    MOTORB,
    COMBODIRECT,
    COMBOPWM);

  TYPE legorc_direction_t IS
   (DIRECTION_REVERSE,
    DIRECTION_FORWARD);

  TYPE legorc_speed_t IS NEW Natural RANGE 0 .. 255;

  -- LEGO Power Functions Remote Control type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_channel_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_motor_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_direction_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_speed_t);

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

END libspiagent;

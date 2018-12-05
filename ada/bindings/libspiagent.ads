-- Thin binding to libspiagent.so, for the Raspberry Pi LPC1114 I/O Processor
-- Expansion Board (http://git.munts.com/rpi-mcu/expansion/LPC1114)

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE libspiagent IS
  PRAGMA Link_With("-lspiagent");

  -----------------------------------------------------------------------------
  -- From spi-agent-transport.h

  Localhost : CONSTANT String := "ioctl://localhost" & ASCII.NUL;

  PROCEDURE Open
   (servername : String;
    error      : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Open, "spiagent_open");

  PROCEDURE Close
   (error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Close, "spiagent_close");

  -----------------------------------------------------------------------------
  -- From spi-agent-adc.h

  PROCEDURE Analog_Configure
   (pin   : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Analog_Configure, "spiagent_analog_configure");

  PROCEDURE Analog_Get
   (pin   : Interfaces.Unsigned_32;
    V     : OUT Float;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Analog_Get, "spiagent_analog_get");

  -----------------------------------------------------------------------------
  -- From spi-agent-gpio.h

  -- GPIO configuration values

  GPIO_DIR_INPUT             : CONSTANT Interfaces.Unsigned_32 := 0;
  GPIO_DIR_OUTPUT            : CONSTANT Interfaces.Unsigned_32 := 1;
  GPIO_PULLDOWN              : CONSTANT Interfaces.Unsigned_32 := 0;  -- pullup resistor
  GPIO_PULLUP                : CONSTANT Interfaces.Unsigned_32 := 1;  -- pulldown resistor
  GPIO_MODE_INPUT            : CONSTANT Interfaces.Unsigned_32 := 0;  -- high impedance
  GPIO_MODE_INPUT_PULLDOWN   : Constant Interfaces.Unsigned_32 := 1;
  GPIO_MODE_INPUT_PULLUP     : CONSTANT Interfaces.Unsigned_32 := 2;
  GPIO_MODE_OUTPUT           : CONSTANT Interfaces.Unsigned_32 := 3;  -- push/pull
  GPIO_MODE_OUTPUT_OPENDRAIN : CONSTANT Interfaces.Unsigned_32 := 4;

  PROCEDURE GPIO_Configure
   (pin   : Interfaces.Unsigned_32;
    dir   : Interfaces.Unsigned_32;
    state : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, GPIO_Configure, "spiagent_gpio_configure");

  PROCEDURE GPIO_Configure_Mode
   (pin   : Interfaces.Unsigned_32;
    mode  : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, GPIO_Configure_Mode, "spiagent_gpio_configure_mode");

  PROCEDURE GPIO_Get
   (pin   : Interfaces.Unsigned_32;
    state : OUT Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, GPIO_Get, "spiagent_gpio_get");

  PROCEDURE GPIO_Put
   (pin   : Interfaces.Unsigned_32;
    state : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, GPIO_Put, "spiagent_gpio_put");

  -----------------------------------------------------------------------------
  -- From spi-agent-interrupt.h

  PROCEDURE Interrupt_Enable
   (error : Interfaces.Integer_32);

  PRAGMA Import(C, Interrupt_Enable, "spiagent_interrupt_enable");

  PROCEDURE Interrupt_Disable
   (error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Interrupt_Disable, "spiagent_interrupt_disable");

  PROCEDURE Interrupt_Wait
   (timeout : Interfaces.Unsigned_32;
    pin     : Interfaces.Unsigned_32;
    error   : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Interrupt_Wait, "spiagent_interrupt_wait");

  -----------------------------------------------------------------------------
  -- From spi-agent-legorc.h

  -- Motor ID values

  LEGO_RC_ALLSTOP     : CONSTANT Interfaces.Unsigned_32 := 0;
  LEGO_RC_MOTORA      : CONSTANT Interfaces.Unsigned_32 := 1;
  LEGO_RC_MOTORB      : CONSTANT Interfaces.Unsigned_32 := 2;
  LEGO_RC_COMBODIRECT : CONSTANT Interfaces.Unsigned_32 := 3;
  LEGO_RC_COMBOPWM    : CONSTANT Interfaces.Unsigned_32 := 4;

  -- Direction values

  LEGO_RC_REVERSE     : CONSTANT Interfaces.Unsigned_32 := 0;
  LEGO_RC_FORWARD     : CONSTANT Interfaces.Unsigned_32 := 1;

  PROCEDURE LEGO_RC_Put
   (pin       : Interfaces.Unsigned_32;
    channel   : Interfaces.Unsigned_32;
    motor     : Interfaces.Unsigned_32;
    direction : Interfaces.Unsigned_32;
    speed     : Interfaces.Unsigned_32;
    error     : OUT Interfaces.Integer_32);

  PRAGMA Import(C, LEGO_RC_Put, "spiagent_legorc_put");

  -----------------------------------------------------------------------------
  -- From spi-agent-pwm.h

  PROCEDURE PWM_Set_Frequency
   (freq  : Interfaces.Unsigned_32;	-- 50 to 50000 Hz
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, PWM_Set_Frequency, "spiagent_pwm_set_frequency");

  PROCEDURE PWM_Configure
   (pin   : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, PWM_Configure, "spiagent_pwm_configure");

  PROCEDURE PWM_Put
   (pin       : Interfaces.Unsigned_32;
    dutycycle : Float;		-- 0.0 to 100.0 percent
    error     : OUT Interfaces.Integer_32);

  PRAGMA Import(C, PWM_Put, "spiagent_pwm_put");

  PROCEDURE Servo_Configure
   (pin   : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Servo_Configure, "spiagent_servo_configure");

  PROCEDURE Servo_Put
   (pin      : Interfaces.Unsigned_32;
    position : Float;		-- -1.0 to +1.0
    error    : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Servo_Put, "spiagent_servo_put");

  PROCEDURE Motor_Configure
   (pwmpin : Interfaces.Unsigned_32;
    dirpin : Interfaces.Unsigned_32;
    error  : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Motor_Configure, "spiagent_motor_configure");

  PROCEDURE Motor_Put
   (pwmpin : Interfaces.Unsigned_32;
    dirpin : Interfaces.Unsigned_32;
    speed  : Float;		-- 0.0 to 100.0
    error  : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Motor_Put, "spiagent_motor_put");

  -----------------------------------------------------------------------------
  -- From spi-agent-timer.h

  -- LPC1114 timer ID values

  TIMER_CT32B0 : CONSTANT Interfaces.Unsigned_32 := 0;
  TIMER_CT32B1 : CONSTANT Interfaces.Unsigned_32 := 1;

  -- LPC1114 timer mode configuration values

  TIMER_MODE_DISABLED     : CONSTANT Interfaces.Unsigned_32 := 0;
  TIMER_MODE_RESET        : CONSTANT Interfaces.Unsigned_32 := 1;
  TIMER_MODE_PCLK         : CONSTANT Interfaces.Unsigned_32 := 2;
  TIMER_MODE_CAP0_RISING  : CONSTANT Interfaces.Unsigned_32 := 3;
  TIMER_MODE_CAP0_FALLING : CONSTANT Interfaces.Unsigned_32 := 4;
  TIMER_MODE_CAP0_BOTH    : CONSTANT Interfaces.Unsigned_32 := 5;

  -- LPC1114 timer capture edge configuration values

  TIMER_CAPTURE_EDGE_DISABLED     : CONSTANT Interfaces.Unsigned_32 := 0;
  TIMER_CAPTURE_EDGE_CAP0_RISING  : CONSTANT Interfaces.Unsigned_32 := 1;
  TIMER_CAPTURE_EDGE_CAP0_FALLING : CONSTANT Interfaces.Unsigned_32 := 2;
  TIMER_CAPTURE_EDGE_CAP0_BOTH    : CONSTANT Interfaces.Unsigned_32 := 3;

  -- LPC1114 match register values

  TIMER_MATCH0 : CONSTANT Interfaces.Unsigned_32 := 0;
  TIMER_MATCH1 : CONSTANT Interfaces.Unsigned_32 := 1;
  TIMER_MATCH2 : CONSTANT Interfaces.Unsigned_32 := 2;
  TIMER_MATCH3 : CONSTANT Interfaces.Unsigned_32 := 3;

  -- LPC1114 match output action configuration values

  TIMER_MATCH_OUTPUT_DISABLED : CONSTANT Interfaces.Unsigned_32 := 0;
  TIMER_MATCH_OUTPUT_CLEAR    : CONSTANT Interfaces.Unsigned_32 := 1;
  TIMER_MATCH_OUTPUT_SET      : CONSTANT Interfaces.Unsigned_32 := 2;
  TIMER_MATCH_OUTPUT_TOGGLE   : CONSTANT Interfaces.Unsigned_32 := 3;

  PROCEDURE Timer_Init
   (timer : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Init, "spiagent_timer_init");

  PROCEDURE Timer_Configure_Mode
   (timer : Interfaces.Unsigned_32;
    mode  : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Configure_Mode, "spiagent_timer_configure_mode");

  PROCEDURE Timer_Configure_Prescaler
   (timer   : Interfaces.Unsigned_32;
    divisor : Interfaces.Unsigned_32;
    error   : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Configure_Prescaler, "spiagent_configure_prescaler");

  PROCEDURE Timer_Configure_Capture
   (timer : Interfaces.Unsigned_32;
    edge  : Interfaces.Unsigned_32;
    intr  : Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Configure_Capture, "spiagent_timer_configure_capture");

  PROCEDURE Timer_Configure_Match
   (timer  : Interfaces.Unsigned_32;
    match  : Interfaces.Unsigned_32;
    value  : Interfaces.Unsigned_32;
    action : Interfaces.Unsigned_32;
    intr   : Interfaces.Unsigned_32;
    reset  : Interfaces.Unsigned_32;
    stop   : Interfaces.Unsigned_32;
    error  : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Configure_Match, "spiagent_timer_configure_match");

  PROCEDURE Timer_Get_Count
   (timer : Interfaces.Unsigned_32;
    count : OUT Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Get_Count, "spiagent_timer_get");

  PROCEDURE Timer_Get_Capture
   (timer : Interfaces.Unsigned_32;
    count : OUT Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Get_Capture, "spiagent_timer_get_capture");

  PROCEDURE Timer_Get_Capture_Delta
   (timer : Interfaces.Unsigned_32;
    count : OUT Interfaces.Unsigned_32;
    error : OUT Interfaces.Integer_32);

  PRAGMA Import(C, Timer_Get_Capture_Delta, "spiagent_timer_get_capture_delta");

END libspiagent;

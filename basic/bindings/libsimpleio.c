// MY-BASIC bindings for libsimpleio (http://git.munts.com/libsimpleio)

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#include <assert.h>
#include <unistd.h>

#include <libsimpleio/libadc.h>
#include <libsimpleio/libgpio.h>
#include <libsimpleio/libpwm.h>
#include <my_basic.h>

// Define an error handler macro

#define FAILIF(condition) if (condition) return MB_FUNC_ERR

/*********************** Operating System Services ***************************/

// Delay for some number of microseconds
//
// Usage: delay(usecs)

static int delay(struct mb_interpreter_t *s, void **l)
{
  int usecs;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &usecs));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(usecs < 0);

  // Sleep a while

  usleep(usecs);
  return MB_FUNC_OK;
}

/************************* A/D Converter Services ****************************/

// Open an ADC input
//
// Usage:  fd = adc_open(chip, channel)

static int adc_open(struct mb_interpreter_t *s, void **l)
{
  int chip;
  int channel;
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &chip));
  mb_check(mb_pop_int(s, l, &channel));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(chip < 0);
  FAILIF(channel < 0);

  // Open the ADC input

  ADC_open(chip, channel, &fd, &error);
  FAILIF(error);

  // Return the file descriptor

  mb_check(mb_push_int(s, l, fd));

  return MB_FUNC_OK;
}

// Close an ADC input
//
// Usage: adc_close(fd)

static int adc_close(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Close the ADC input

  ADC_close(fd, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

// Read from an ADC input
//
// Usage: sample = adc_read(fd)

static int adc_read(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int sample;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Read from the ADC input

  ADC_read(fd, &sample, &error);
  FAILIF(error);

  mb_check(mb_push_int(s, l, sample));

  return MB_FUNC_OK;
}

/************************* D/A Converter Services ****************************/

// Open a DAC output
//
// Usage:  fd = dac_open(chip, channel)

static int dac_open(struct mb_interpreter_t *s, void **l)
{
  int chip;
  int channel;
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &chip));
  mb_check(mb_pop_int(s, l, &channel));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(chip < 0);
  FAILIF(channel < 0);

  // Open the DAC output

  DAC_open(chip, channel, &fd, &error);
  FAILIF(error);

  // Return the file descriptor

  mb_check(mb_push_int(s, l, fd));

  return MB_FUNC_OK;
}

// Close a DAC output
//
// Usage: dac_close(fd)

static int dac_close(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Close the DAC output

  DAC_close(fd, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

// Write to a DAC output
//
// Usage: dac_write(fd, sample)

static int dac_write(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int sample;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_pop_int(s, l, &sample));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Write to the DAC output

  DAC_write(fd, sample, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

/**************************** GPIO Pin Services ******************************/

#define InputFlags  GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_PUSH_PULL|  \
  GPIOHANDLE_REQUEST_ACTIVE_HIGH

#define OutputFlags GPIOHANDLE_REQUEST_OUTPUT|GPIOHANDLE_REQUEST_PUSH_PULL| \
  GPIOHANDLE_REQUEST_ACTIVE_HIGH

// Open a GPIO pin
//
// Usage:  fd = gpio_open(chip, channel, dir, state)

static int gpio_open(struct mb_interpreter_t *s, void **l)
{
  int chip;
  int channel;
  int dir;
  int state;
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &chip));
  mb_check(mb_pop_int(s, l, &channel));
  mb_check(mb_pop_int(s, l, &dir));
  mb_check(mb_pop_int(s, l, &state));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(chip < 0);
  FAILIF(channel < 0);
  FAILIF(dir < 0);
  FAILIF(dir > 1);
  FAILIF(state < 0);
  FAILIF(state > 1);

  // Open the GPIO pin

  GPIO_line_open(chip, channel, dir ? OutputFlags : InputFlags, 0, state,
    &fd, &error);
  FAILIF(error);

  // Return the file descriptor

  mb_check(mb_push_int(s, l, fd));

  return MB_FUNC_OK;
}

// Close a GPIO pin
//
// Usage: gpio_close(fd)

static int gpio_close(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Close the GPIO pin

  GPIO_line_close(fd, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

// Read from a GPIO pin
//
// Usage: state = gpio_read(fd)

static int gpio_read(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int state;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Read from the GPIO pin

  GPIO_line_read(fd, &state, &error);
  FAILIF(error);

  mb_check(mb_push_int(s, l, state));

  return MB_FUNC_OK;
}

// Write to a GPIO pin
//
// Usage: gpio_write(state)

static int gpio_write(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int state;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_pop_int(s, l, &state));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);
  FAILIF(state < 0);
  FAILIF(state > 1);

  // Write to the GPIO pin

  GPIO_line_write(fd, state, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

/***************************** PWM Output Services ***************************/

// Open a PWM output
//
// Usage:  fd = pwm,_open(chip, channel, period, ontime)

static int pwm_open(struct mb_interpreter_t *s, void **l)
{
  int chip;
  int channel;
  int period;
  int ontime;
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &chip));
  mb_check(mb_pop_int(s, l, &channel));
  mb_check(mb_pop_int(s, l, &period));
  mb_check(mb_pop_int(s, l, &ontime));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(chip < 0);
  FAILIF(channel < 0);
  FAILIF(period < 0);
  FAILIF(ontime < 0);

  // Configure the PWM output

  PWM_configure(chip, channel, period, ontime, PWM_POLARITY_ACTIVEHIGH, &error);
  FAILIF(error);

  PWM_open(chip, channel, &fd, &error);
  FAILIF(error);

  // Return the file descriptor

  mb_check(mb_push_int(s, l, fd));

  return MB_FUNC_OK;
}

// Close a PWM output
//
// Usage: pwm_close(fd)

static int pwm_close(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);

  // Close the PWM output

  PWM_close(fd, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

// Write to a PWM output
//
// Usage: pwm_write(ontime)

static int pwm_write(struct mb_interpreter_t *s, void **l)
{
  int fd;
  int ontime;
  int error;

  // Fetch parameters

  mb_assert(s && l);
  mb_check(mb_attempt_open_bracket(s, l));
  mb_check(mb_pop_int(s, l, &fd));
  mb_check(mb_pop_int(s, l, &ontime));
  mb_check(mb_attempt_close_bracket(s, l));

  // Validate parameters

  FAILIF(fd < 0);
  FAILIF(ontime < 0);

  // Write to the GPIO pin

  PWM_write(fd, ontime, &error);
  FAILIF(error);

  return MB_FUNC_OK;
}

/*****************************************************************************/

void libsimpleio_init(struct mb_interpreter_t *bas)
{
  // Operating System services
  mb_reg_fun(bas, delay);

  mb_begin_module(bas, "libsimpleio");

  // ADC services
  mb_reg_fun(bas, adc_open);
  mb_reg_fun(bas, adc_close);
  mb_reg_fun(bas, adc_read);

  // DAC services
  mb_reg_fun(bas, dac_open);
  mb_reg_fun(bas, dac_close);
  mb_reg_fun(bas, dac_write);

  // GPIO services
  mb_reg_fun(bas, gpio_open);
  mb_reg_fun(bas, gpio_close);
  mb_reg_fun(bas, gpio_read);
  mb_reg_fun(bas, gpio_write);

  // PWM services
  mb_reg_fun(bas, pwm_open);
  mb_reg_fun(bas, pwm_close);
  mb_reg_fun(bas, pwm_write);

  mb_end_module(bas);
}

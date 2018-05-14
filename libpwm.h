/* PWM (Pulse Width Modulated) output services for Linux */

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

#ifndef LIBPWM_H
#define LIBPWM_H

#include <libsimpleio/cplusplus.h>
#include <stdint.h>

typedef enum
{
  PWM_POLARITY_ACTIVELOW,
  PWM_POLARITY_ACTIVEHIGH,
} PWM_POLARITY_t;

_BEGIN_STD_C

extern void PWM_configure(int32_t chip, int32_t channel, int32_t period,
  int32_t ontime, int32_t polarity, int32_t *error);

extern void PWM_open(int32_t chip, int32_t channel, int32_t *fd,
  int32_t *error);

extern void PWM_close(int32_t fd, int32_t *error);

extern void PWM_write(int32_t fd, int32_t ontime, int32_t *error);

_END_STD_C

#endif

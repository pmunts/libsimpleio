/* GPIO services for Linux */

// Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

#ifndef LIBGPIO_H
#define LIBGPIO_H

#include <cplusplus.h>
#include <liblinux.h>
#include <stdint.h>

typedef enum
{
  GPIO_DIRECTION_INPUT,
  GPIO_DIRECTION_OUTPUT,
} GPIO_DIRECTION_t;

typedef enum
{
  GPIO_EDGE_NONE,
  GPIO_EDGE_RISING,
  GPIO_EDGE_FALLING,
  GPIO_EDGE_BOTH
} GPIO_EDGE_t;

typedef enum
{
  GPIO_ACTIVELOW,
  GPIO_ACTIVEHIGH,
} GPIO_POLARITY_t;

_BEGIN_STD_C

extern void GPIO_configure(int32_t pin, int32_t direction, int32_t state,
  int32_t edge, int32_t polarity, int32_t *error);

extern void GPIO_open(int32_t pin, int32_t *fd, int32_t *error);

extern void GPIO_close(int32_t fd, int32_t *error);

extern void GPIO_read(int32_t fd, int32_t *state, int32_t *error);

extern void GPIO_write(int32_t fd, int32_t state, int32_t *error);

_END_STD_C

#define GPIO_close(f, e) LINUX_close(f, e)

#endif

/* GPIO services for Linux */

// $Id$

// Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

extern void GPIO_configure(int pin, int direction, int state, int edge, int polarity, int *error);

extern void GPIO_open(char *name, int *fd, int *error);

extern void GPIO_close(int fd, int *error);

extern void GPIO_read(int fd, int *state, int *error);

extern void GPIO_write(int fd, int state, int *error);

#endif

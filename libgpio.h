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

#define GPIO_DIRECTION_INPUT	0
#define GPIO_DIRECTION_OUTPUT	1

#define GPIO_EDGE_NONE		0
#define GPIO_EDGE_RISING	1
#define GPIO_EDGE_FALLING	2
#define GPIO_EDGE_BOTH		3

#define GPIO_ACTIVEHIGH		1
#define GPIO_ACTIVELOW		0
 
extern void GPIO_configure(int pin, int direction, int state, int edge, int polarity, int *error);

extern void GPIO_open(int pin, int *fd, int *error);

extern void GPIO_close(int fd, int *error);

extern void GPIO_read(int fd, int *state, int *error);

extern void GPIO_write(int fd, int state, int *error);

#endif

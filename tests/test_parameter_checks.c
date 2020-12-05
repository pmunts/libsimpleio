// Linux Simple I/O Library unit tests -- parameter checking

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

#include <check.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <libadc.h>
#include <libevent.h>
#include <libgpio.h>
#include <libhidraw.h>
#include <libi2c.h>
#include <libipv4.h>
#include <liblinux.h>
#include <liblinx.h>
#include <libpwm.h>
#include <libserial.h>
#include <libspi.h>
#include <libstream.h>
#include <libwatchdog.h>

START_TEST(test_libadc)
{
  char name[256];
  int32_t error;
  int32_t fd;
  int32_t sample;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  ADC_get_name(-1, name, sizeof(name), &error);
  ck_assert(error == EINVAL);

  ADC_get_name(0, NULL, sizeof(name), &error);
  ck_assert(error == EINVAL);

  ADC_get_name(0, name, 15, &error);
  ck_assert(error == EINVAL);

  ADC_get_name(999, name, sizeof(name), &error);
  ck_assert(error == ENOENT);

  fd = -888;
  ADC_open(-1, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  ADC_open(0, -1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  ADC_open(0, 0, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  ADC_open(999, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  fd = -888;
  ADC_open(0, 999, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  ADC_read(-1, &sample, &error);
  ck_assert(error == EINVAL);

  ADC_read(999, NULL, &error);
  ck_assert(error == EINVAL);

  ADC_read(999, &sample, &error);
  ck_assert(error == EBADF);

  ADC_close(-1, &error);
  ck_assert(error == EINVAL);

  ADC_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libevent)
{
  int32_t epfd;
  int32_t fd;
  int32_t error;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  EVENT_open(NULL, &error);
  ck_assert(error == EINVAL);

  EVENT_open(&epfd, &error);
  ck_assert(error == 0);

  EVENT_register_fd(-1, 0, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_register_fd(epfd, -1, 0, 0, &error);
  ck_assert(error == EINVAL);

  fd = open("/dev/null", O_RDONLY);
  ck_assert(fd > 0);

  EVENT_modify_fd(-1, fd, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_modify_fd(epfd, -1, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_unregister_fd(-1, fd, &error);
  ck_assert(error == EINVAL);

  EVENT_unregister_fd(epfd, -1, &error);
  ck_assert(error == EINVAL);

  EVENT_close(epfd, &error);
  ck_assert(error == 0);

  EVENT_close(-1, &error);
  ck_assert(error == EINVAL);

  EVENT_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libgpio)
{
  int32_t error;
  int32_t fd;
  int32_t state;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  GPIO_configure(-1, GPIO_DIRECTION_INPUT, false, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, -1, false, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, 2, false, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, -1, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, 2, GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, false, -1,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, false, 4,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, false, GPIO_EDGE_NONE,
    -1, &error);
  ck_assert(error == EINVAL);

  GPIO_configure(0, GPIO_DIRECTION_INPUT, false, GPIO_EDGE_NONE,
    2, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_open(-1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  GPIO_open(0, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_open(999, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  GPIO_read(-1, &state, &error);
  ck_assert(error == EINVAL);

  GPIO_read(999, NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_read(999, &state, &error);
  ck_assert(error == EBADF);

  GPIO_write(-1, 0, &error);
  ck_assert(error == EINVAL);

  GPIO_write(999, -1, &error);
  ck_assert(error == EINVAL);

  GPIO_write(999, 2, &error);
  ck_assert(error == EINVAL);

  GPIO_write(999, 0, &error);
  ck_assert(error == EBADF);

  GPIO_close(-1, &error);
  ck_assert(error == EINVAL);

  GPIO_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libgpiod)
{
  char name[32];
  char label[32];
  int32_t lines;
  int32_t error;
  int32_t flags;
  int32_t fd;
  int32_t state;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  GPIO_chip_info(-1, name, sizeof(name), label, sizeof(label), &lines, &error);
  ck_assert(error == EINVAL);

  GPIO_chip_info(999, name, sizeof(name), label, sizeof(label), &lines, &error);
  ck_assert(error == ENOENT);

  GPIO_chip_info(0, NULL, sizeof(name), label, sizeof(label), &lines, &error);
  ck_assert(error == EINVAL);

  GPIO_chip_info(0, name, sizeof(name)-1, label, sizeof(label), &lines, &error);
  ck_assert(error == EINVAL);

  GPIO_chip_info(0, name, sizeof(name), NULL, sizeof(label), &lines, &error);
  ck_assert(error == EINVAL);

  GPIO_chip_info(0, name, sizeof(name), label, sizeof(label)-1, &lines, &error);
  ck_assert(error == EINVAL);

  GPIO_chip_info(0, name, sizeof(name), label, sizeof(label), NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(-1, 0, &flags, name, sizeof(name), label, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(999, 0, &flags, name, sizeof(name), label, sizeof(label), &error);
  ck_assert(error == ENOENT);

  GPIO_line_info(0, -1, &flags, name, sizeof(name), label, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(0, 0, NULL, name, sizeof(name), label, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(0, 0, &flags, NULL, sizeof(name), label, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(0, 0, &flags, name, sizeof(name)-1, label, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(0, 0, &flags, name, sizeof(name), NULL, sizeof(label), &error);
  ck_assert(error == EINVAL);

  GPIO_line_info(0, 0, &flags, name, sizeof(name), label, sizeof(label)-1, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(-1, 0, GPIOHANDLE_REQUEST_INPUT, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, -1, GPIOHANDLE_REQUEST_INPUT, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, -1, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, 0x21, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, 0, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_ACTIVE_LOW, GPIO_EDGE_NONE, false,
    &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_ACTIVE_LOW, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OPEN_DRAIN, GPIO_EDGE_NONE, false,
    &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OPEN_DRAIN,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_OPEN_DRAIN, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_DRAIN, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_DRAIN, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_ACTIVE_LOW|GPIOHANDLE_REQUEST_OPEN_DRAIN,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false,
    &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_ACTIVE_LOW|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OPEN_DRAIN|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OPEN_DRAIN|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OUTPUT|GPIOHANDLE_REQUEST_OPEN_DRAIN|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_OPEN_DRAIN|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_DRAIN|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_DRAIN|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OUTPUT|GPIOHANDLE_REQUEST_ACTIVE_LOW|
    GPIOHANDLE_REQUEST_OPEN_DRAIN|GPIOHANDLE_REQUEST_OPEN_SOURCE,
    GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT|GPIOHANDLE_REQUEST_OUTPUT|
    GPIOHANDLE_REQUEST_ACTIVE_LOW|GPIOHANDLE_REQUEST_OPEN_DRAIN|
    GPIOHANDLE_REQUEST_OPEN_SOURCE, GPIO_EDGE_NONE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT, -1, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT, 4, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OUTPUT,
    GPIOEVENT_REQUEST_RISING_EDGE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OUTPUT,
    GPIOEVENT_REQUEST_FALLING_EDGE, false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_OUTPUT, GPIOEVENT_REQUEST_BOTH_EDGES,
    false, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  GPIO_line_open(0, 0, GPIOHANDLE_REQUEST_INPUT, GPIO_EDGE_NONE, false, NULL,
    &error);
  ck_assert(error == EINVAL);

  GPIO_line_read(-1, &state, &error);
  ck_assert(error == EINVAL);

  GPIO_line_read(999, &state, &error);
  ck_assert(error == EBADF);

  GPIO_line_read(0, NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_line_write(-1, false, &error);
  ck_assert(error == EINVAL);

  GPIO_line_write(999, false, &error);
  ck_assert(error == EBADF);

  GPIO_line_write(0, -1, &error);
  ck_assert(error == EINVAL);

  GPIO_line_write(0, 2, &error);
  ck_assert(error == EINVAL);

  GPIO_line_event(-1, &state, &error);
  ck_assert(error == EINVAL);

  GPIO_line_event(999, &state, &error);
  ck_assert(error == EIO);

  GPIO_line_event(0, NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_line_close(-1, &error);
  ck_assert(error == EINVAL);

  GPIO_line_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libhidraw)
{
  int32_t fd;
  int32_t error;
  char name[256];
  int32_t bustype;
  int32_t vendor;
  int32_t product;
  uint8_t buf[256];
  int32_t count;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  HIDRAW_open1(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  HIDRAW_open1("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  HIDRAW_open1("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  HIDRAW_open2(0, 0, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  HIDRAW_open2(0, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENODEV);

  HIDRAW_open3(0, 0, NULL, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  HIDRAW_open3(0, 0, NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENODEV);

  HIDRAW_get_name(-1, name, sizeof(name), &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(999, NULL, sizeof(name), &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(999, name, 15, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(999, name, sizeof(name), &error);
  ck_assert(error == EBADF);

  HIDRAW_get_info(-1, &bustype, &vendor, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(999, NULL, &vendor, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(999, &bustype, NULL, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(999, &bustype, &vendor, NULL, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(999, &bustype, &vendor, &product, &error);
  ck_assert(error == EBADF);

  HIDRAW_send(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_send(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  HIDRAW_send(0, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_send(0, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_send(0, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  HIDRAW_receive(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_receive(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  HIDRAW_receive(0, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_receive(0, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  HIDRAW_receive(0, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  HIDRAW_close(-1, &error);
  ck_assert(error == EINVAL);

  HIDRAW_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libi2c)
{
  int32_t fd;
  int32_t error;
  uint8_t cmd[8];
  uint8_t resp[8];

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  I2C_open(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  I2C_open("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  I2C_open("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  I2C_transaction(-1, 0x40, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, -1, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 128, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, -1, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, sizeof(cmd), resp, -1, &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, NULL, 1, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, 0, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, sizeof(cmd), NULL, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, sizeof(cmd), resp, 0, &error);
  ck_assert(error == EINVAL);

  I2C_transaction(999, 0x40, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EBADF);

  I2C_close(-1, &error);
  ck_assert(error == EINVAL);

  I2C_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libipv4)
{
  int32_t addr;
  int32_t error;
  char buf[256];
  int32_t fd;
  int32_t count;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  IPV4_resolve(NULL, &addr, &error);
  ck_assert(error == EINVAL);

  IPV4_resolve("localhost", NULL, &error);
  ck_assert(error == EINVAL);

  IPV4_resolve("localhost", &addr, &error);
  ck_assert(error == 0);
  ck_assert(addr == 0x7F000001);

  IPV4_resolve("bogus.munts.net", &addr, &error);
  ck_assert(error == EIO);

  IPV4_ntoa(0x00000000, NULL, sizeof(buf), &error);
  ck_assert(error == EINVAL);

  IPV4_ntoa(0x00000000, buf, 15, &error);
  ck_assert(error == EINVAL);

  IPV4_ntoa(0x00000000, buf, sizeof(buf), &error);
  ck_assert(error == 0);
  ck_assert(!strcmp(buf, "0.0.0.0"));

  IPV4_ntoa(0x01020304, buf, sizeof(buf), &error);
  ck_assert(error == 0);
  ck_assert(!strcmp(buf, "1.2.3.4"));

  IPV4_ntoa(0xFFFFFFFF, buf, sizeof(buf), &error);
  ck_assert(error == 0);
  ck_assert(!strcmp(buf, "255.255.255.255"));

  TCP4_connect(0x00000000, 1234, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_connect(0xFFFFFFFF, 1234, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_connect(0x7F000001, 0, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_connect(0x7F000001, 65536, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_connect(0x7F000001, 1234, NULL, &error);
  ck_assert(error == EINVAL);

  TCP4_connect(0x7F000001, 65535, &fd, &error);
  ck_assert(error == ECONNREFUSED);

  TCP4_accept(0xFFFFFFFF, 1234, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_accept(0x7F000001, 0, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_accept(0x7F000001, 65536, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_accept(0x7F000001, 65535, NULL, &error);
  ck_assert(error == EINVAL);

  TCP4_server(0xFFFFFFFF, 1234, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_server(0x7F000001, 0, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_server(0x7F000001, 65536, &fd, &error);
  ck_assert(error == EINVAL);

  TCP4_server(0x7F000001, 65535, NULL, &error);
  ck_assert(error == EINVAL);

  TCP4_close(-1, &error);
  ck_assert(error == EINVAL);

  TCP4_close(999, &error);
  ck_assert(error == EBADF);

  TCP4_send(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  TCP4_send(999, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  TCP4_send(999, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  TCP4_send(999, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  TCP4_send(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  TCP4_receive(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  TCP4_receive(999, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  TCP4_receive(999, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  TCP4_receive(999, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  TCP4_receive(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_liblinux)
{
  int32_t error;
  char buf[256];
  int32_t status;
  int32_t fd;
  int32_t count;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  LINUX_drop_privileges(NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_drop_privileges("nobody", &error);
  ck_assert(error == EPERM);

  LINUX_openlog(NULL, LOG_NDELAY, LOG_LOCAL0, &error);
  ck_assert(error == EINVAL);

  LINUX_openlog("test_parameter_checks", LOG_NDELAY, (24 << 3), &error);
  ck_assert(error == EINVAL);

  LINUX_openlog("test_parameter_checks", LOG_NDELAY, LOG_LOCAL0, &error);
  ck_assert(error == 0);

  LINUX_syslog(LOG_NOTICE, NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_syslog(LOG_NOTICE, "test", &error);
  ck_assert(error == 0);

  LINUX_strerror(0, NULL, sizeof(buf));

  LINUX_strerror(0, buf, 15);

  LINUX_strerror(0, buf, sizeof(buf));
  ck_assert(!strcmp(buf, "Success"));

  LINUX_strerror(EPERM, buf, sizeof(buf));
  ck_assert(!strcmp(buf, "Operation not permitted"));

  LINUX_strerror(EPIPE, buf, sizeof(buf));
  ck_assert(!strcmp(buf, "Broken pipe"));

  int32_t files[1];
  int32_t events[1];
  int32_t results[1];

  LINUX_poll(0, files, events, results, 0, &error);
  ck_assert(error == EINVAL);

  LINUX_poll(1, NULL, events, results, 0, &error);
  ck_assert(error == EINVAL);

  LINUX_poll(1, files, NULL, results, 0, &error);
  ck_assert(error == EINVAL);

  LINUX_poll(1, files, events, NULL, 0, &error);
  ck_assert(error == EINVAL);

  LINUX_poll(1, files, events, results, -2, &error);
  ck_assert(error == EINVAL);

  files[0] = 999;
  events[0] = POLLIN;
  results[0] = 0;

  LINUX_poll(1, files, events, results, -1, &error);
  ck_assert(error == 0);
  ck_assert(results[0] == POLLNVAL);

  files[0] = open("/dev/null", O_RDONLY);
  ck_assert(files[0] > 2);

  events[0] = POLLPRI;
  results[0] = 0;

  LINUX_poll(1, files, events, results, 100, &error);
  ck_assert(error == EAGAIN);
  ck_assert(results[0] == 0);

  LINUX_usleep(1000, &error);
  ck_assert(error == 0);

  LINUX_command(NULL, &status, &error);
  ck_assert(status == 0);
  ck_assert(error == EINVAL);

  LINUX_command("true", NULL, &error);
  ck_assert(status == 0);
  ck_assert(error == EINVAL);

  LINUX_command("true", &status, &error);
  ck_assert(status == 0);
  ck_assert(error == 0);

  LINUX_command("false", &status, &error);
  ck_assert(status == 1);
  ck_assert(error == 0);

  fd = -888;
  LINUX_open(NULL, O_RDWR, 0644, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open("/dev/bogus", O_RDWR, 0644, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open("/dev/bogus", O_RDWR, 0644, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  fd = -888;
  LINUX_open("/dev/null", O_WRONLY|O_CREAT|O_EXCL, 0644, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EEXIST);

  LINUX_open("/dev/null", O_RDWR, 0644, &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  fd = -888;
  LINUX_open_read(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_read("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_read("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  LINUX_open_read("/dev/null", &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  fd = -888;
  LINUX_open_write(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_write("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_write("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  LINUX_open_write("/dev/null", &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  fd = -888;
  LINUX_open_readwrite(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_readwrite("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_readwrite("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  LINUX_open_readwrite("/dev/null", &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  fd = -888;
  LINUX_open_create(NULL, 0644, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_create("/dev/bogus", 0644, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_create("/dev/bogus", 0644, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EACCES);

  LINUX_open_create("/dev/null", 0644, &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_close(-1, &error);
  ck_assert(error == EINVAL);

  LINUX_close(999, &error);
  ck_assert(error == EBADF);

  LINUX_open_read("/dev/zero", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINUX_read(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_read(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  LINUX_read(fd, buf, sizeof(buf), &count, &error);
  ck_assert(error == 0);
  ck_assert(count == sizeof(buf));

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_write("/dev/null", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINUX_write(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_write(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  LINUX_write(fd, buf, sizeof(buf), &count, &error);
  ck_assert(error == 0);
  ck_assert(count == sizeof(buf));

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_readwrite("/dev/null", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINUX_read(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  LINUX_read(fd, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_read(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  LINUX_read(fd, buf, sizeof(buf), &count, &error);
  ck_assert(error == 0);
  ck_assert(count == 0);

  LINUX_write(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  LINUX_write(fd, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_write(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  LINUX_write(fd, buf, sizeof(buf), &count, &error);
  ck_assert(error == 0);
  ck_assert(count == sizeof(buf));

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;
}
END_TEST

START_TEST(test_liblinx)
{
  int32_t fd = -1;
  LINX_command_t cmd;
  int32_t error;
  LINX_response_t resp;
  int32_t count = 0;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  LINUX_open_readwrite(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_readwrite("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_readwrite("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  LINUX_open_readwrite("/dev/null", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  memset(&cmd, 0, sizeof(cmd));

  LINX_transmit_command(-1, &cmd, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_command(999, &cmd, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_command(fd, NULL, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == EINVAL);

  cmd.SoF = LINX_SOF;

  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == EINVAL);

  cmd.PacketSize = 6;
  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == EINVAL);

  cmd.PacketSize = sizeof(LINX_command_t) + 1;
  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == EINVAL);

  cmd.PacketSize = 7;
  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == 0);

  cmd.PacketSize = sizeof(LINX_command_t);
  LINX_transmit_command(fd, &cmd, &error);
  ck_assert(error == 0);

  LINUX_close(-1, &error);
  ck_assert(error == EINVAL);

  LINUX_close(999, &error);
  ck_assert(error == EBADF);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  fd = -888;
  LINUX_open_readwrite(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  LINUX_open_readwrite("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  LINUX_open_readwrite("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  LINUX_open_readwrite("/dev/null", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  memset(&resp, 0, sizeof(resp));

  LINX_transmit_response(-1, &resp, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_response(999, &resp, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_response(fd, NULL, &error);
  ck_assert(error == EINVAL);

  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == EINVAL);

  resp.SoF = LINX_SOF;

  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == EINVAL);

  resp.PacketSize = 5;
  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == EINVAL);

  resp.PacketSize = sizeof(LINX_response_t) + 1;
  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == EINVAL);

  resp.PacketSize = 6;
  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == 0);

  resp.PacketSize = sizeof(LINX_response_t);
  LINX_transmit_response(fd, &resp, &error);
  ck_assert(error == 0);

  LINUX_close(-1, &error);
  ck_assert(error == EINVAL);

  LINUX_close(999, &error);
  ck_assert(error == EBADF);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_readwrite("/dev/null", &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINX_receive_command(-1, &cmd, &count, &error);
  ck_assert(error == EINVAL);

  LINX_receive_command(fd, NULL, &count, &error);
  ck_assert(error == EINVAL);

  LINX_receive_command(fd, &cmd, NULL, &error);
  ck_assert(error == EINVAL);

  LINX_receive_command(fd, &cmd, &count, &error);
  ck_assert(error == EPIPE);

  LINX_receive_response(-1, &resp, &count, &error);
  ck_assert(error == EINVAL);

  LINX_receive_response(fd, NULL, &count, &error);
  ck_assert(error == EINVAL);

  LINX_receive_response(fd, &resp, NULL, &error);
  ck_assert(error == EINVAL);

  LINX_receive_response(fd, &resp, &count, &error);
  ck_assert(error == EPIPE);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
}
END_TEST

START_TEST(test_libpwm)
{
  int32_t error;
  int32_t fd;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  PWM_configure(-1, 0, 100, 100, PWM_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  PWM_configure(0, -1, 100, 100, PWM_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  PWM_configure(0, 0, -1, 100, PWM_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  PWM_configure(0, 0, 100, -1, PWM_POLARITY_ACTIVEHIGH, &error);
  ck_assert(error == EINVAL);

  PWM_configure(0, 0, 100, 100, PWM_POLARITY_ACTIVELOW - 1, &error);
  ck_assert(error == EINVAL);

  PWM_configure(0, 0, 100, 100, PWM_POLARITY_ACTIVEHIGH + 1, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  PWM_open(-1, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  PWM_open(0, -1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  PWM_open(0, 0, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  PWM_open(0, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  PWM_write(-1, 100, &error);
  ck_assert(error == EINVAL);

  PWM_write(999, -1, &error);
  ck_assert(error == EINVAL);

  PWM_write(999, 100, &error);
  ck_assert(error == EBADF);

  PWM_close(-1, &error);
  ck_assert(error == EINVAL);

  PWM_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libserial)
{
  int32_t fd;
  int32_t error;
  uint8_t buf[256];
  int32_t count;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  SERIAL_open(NULL, 9600, SERIAL_PARITY_NONE, 8, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 49, SERIAL_PARITY_NONE, 8, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE - 1, 8, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_ODD + 1, 8, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE, 4, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE, 9, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE, 8, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE, 8, 3, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SERIAL_open("/dev/bogus", 9600, SERIAL_PARITY_NONE, 8, 1, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  SERIAL_send(-1, buf, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  SERIAL_send(999, NULL, sizeof(buf), &count, &error);
  ck_assert(error == EINVAL);

  SERIAL_send(999, buf, 0, &count, &error);
  ck_assert(error == EINVAL);

  SERIAL_send(999, buf, sizeof(buf), NULL, &error);
  ck_assert(error == EINVAL);

  SERIAL_send(999, buf, sizeof(buf), &count, &error);
  ck_assert(error == EBADF);

  SERIAL_close(-1, &error);
  ck_assert(error == EINVAL);

  SERIAL_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libspi)
{
  int32_t fd;
  int32_t error;
  uint8_t cmd[16];
  uint8_t resp[16];

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  SPI_open(NULL, 0, 8, 1000000, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SPI_open("/dev/bogus", -1, 8, 1000000, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SPI_open("/dev/bogus", 4, 8, 1000000, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SPI_open("/dev/bogus", 0, 7, 1000000, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  fd = -888;
  SPI_open("/dev/bogus", 0, 8, 0, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  SPI_open("/dev/bogus", 0, 8, 1000000, NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  SPI_open("/dev/bogus", 0, 8, 1000000, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  SPI_transaction(-1, SPI_CS_AUTO, &cmd, sizeof(cmd), 1000, &resp,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, -2, &cmd, sizeof(cmd), 1000, &resp,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, NULL, sizeof(cmd), 1000, &resp,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, 0, 1000, &resp,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, sizeof(cmd), -1, &resp,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, sizeof(cmd), 1000, NULL,
    sizeof(resp), &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, sizeof(cmd), 1000, &resp,
    0, &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, NULL, 0, 1000, NULL, 0, &error);
  ck_assert(error == EINVAL);

  SPI_transaction(999, SPI_CS_AUTO, NULL, 0, 1000, &resp, sizeof(resp), &error);
  ck_assert(error == EBADF);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, sizeof(cmd), 1000, NULL, 0, &error);
  ck_assert(error == EBADF);

  SPI_transaction(999, SPI_CS_AUTO, &cmd, sizeof(cmd), 1000, &resp,
    sizeof(resp), &error);
  ck_assert(error == EBADF);

  SPI_close(-1, &error);
  ck_assert(error == EINVAL);

  SPI_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libstream)
{
  uint8_t msgbuf[256];
  uint8_t framebuf[518];
  int32_t count;
  int error;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  STREAM_encode_frame(NULL, sizeof(msgbuf), framebuf, sizeof(framebuf),
    &count, &error);
  ck_assert(error == EINVAL);
  ck_assert(count == 0);

  STREAM_encode_frame(msgbuf, -1, framebuf, sizeof(framebuf), &count, &error);
  ck_assert(error == EINVAL);
  ck_assert(count == 0);

  STREAM_encode_frame(msgbuf, sizeof(msgbuf), NULL, sizeof(framebuf),
    &count, &error);
  ck_assert(error == EINVAL);
  ck_assert(count == 0);

  STREAM_encode_frame(msgbuf, sizeof(msgbuf), framebuf, 5, &count, &error);
  ck_assert(error == EINVAL);
  ck_assert(count == 0);

  STREAM_encode_frame(msgbuf, sizeof(msgbuf), framebuf, sizeof(framebuf),
    NULL, &error);
  ck_assert(error == EINVAL);
  ck_assert(count == 0);

  memset(framebuf, 0, sizeof(framebuf));
  count = 0;
  STREAM_encode_frame(msgbuf, 0, framebuf, sizeof(framebuf),
    &count, &error);
  ck_assert(error == 0);
  ck_assert(count == 6);
  ck_assert(framebuf[0] == 0x10);	// DLE
  ck_assert(framebuf[1] == 0x02);	// STX
  ck_assert(framebuf[2] == 0x1D);	// FCS high
  ck_assert(framebuf[3] == 0x0F);	// FCS low
  ck_assert(framebuf[4] == 0x10);	// DLE
  ck_assert(framebuf[5] == 0x03);	// ETX

  STREAM_decode_frame(NULL, sizeof(framebuf), msgbuf, sizeof(msgbuf), &count,
    &error);
  ck_assert(error == EINVAL);

  STREAM_decode_frame(framebuf, 5, msgbuf, sizeof(msgbuf), &count, &error);
  ck_assert(error == EINVAL);

  STREAM_decode_frame(framebuf, sizeof(framebuf), NULL, sizeof(msgbuf), &count,
    &error);
  ck_assert(error == EINVAL);

  STREAM_decode_frame(framebuf, sizeof(framebuf), msgbuf, -1, &count, &error);
  ck_assert(error == EINVAL);

  STREAM_decode_frame(framebuf, sizeof(framebuf), msgbuf, sizeof(msgbuf), NULL,
    &error);
  ck_assert(error == EINVAL);

  STREAM_decode_frame(framebuf, 6, msgbuf, sizeof(msgbuf), &count,
    &error);
  ck_assert(error == 0);
  ck_assert(count == 0);

  STREAM_send_frame(-1, framebuf, sizeof(framebuf), &count, &error);
  ck_assert(error == EINVAL);

  STREAM_send_frame(999, NULL, sizeof(framebuf), &count, &error);
  ck_assert(error == EINVAL);

  STREAM_send_frame(999, framebuf, 0, &count, &error);
  ck_assert(error == EINVAL);

  STREAM_send_frame(999, framebuf, sizeof(framebuf), NULL, &error);
  ck_assert(error == EINVAL);

  STREAM_send_frame(999, framebuf, sizeof(framebuf), &count, &error);
  ck_assert(error == EBADF);

  STREAM_receive_frame(-1, framebuf, sizeof(framebuf), &count, &error);
  ck_assert(error == EINVAL);

  STREAM_receive_frame(999, NULL, sizeof(framebuf), &count, &error);
  ck_assert(error == EINVAL);

  STREAM_receive_frame(999, framebuf, 5, &count, &error);
  ck_assert(error == EINVAL);

  STREAM_receive_frame(999, framebuf, sizeof(framebuf), NULL, &error);
  ck_assert(error == EINVAL);

  STREAM_receive_frame(999, framebuf, sizeof(framebuf), &count, &error);
  ck_assert(error == EBADF);
}
END_TEST

START_TEST(test_libwatchdog)
{
  int32_t fd;
  int32_t error;
  int32_t timeout;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  fd = -888;
  WATCHDOG_open(NULL, &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == EINVAL);

  WATCHDOG_open("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  fd = -888;
  WATCHDOG_open("/dev/bogus", &fd, &error);
  ck_assert(fd == -1);
  ck_assert(error == ENOENT);

  WATCHDOG_get_timeout(-1, &timeout, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_get_timeout(999, NULL, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_get_timeout(999, &timeout, &error);
  ck_assert(error == EBADF);

  WATCHDOG_set_timeout(-1, 10, &timeout, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_set_timeout(999, -1, &timeout, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_set_timeout(999, 10, NULL, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_set_timeout(999, 10, &timeout, &error);
  ck_assert(error == EBADF);

  WATCHDOG_kick(-1, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_kick(999, &error);
  ck_assert(error == EBADF);

  WATCHDOG_close(-1, &error);
  ck_assert(error == EINVAL);

  WATCHDOG_close(999, &error);
  ck_assert(error == EBADF);
}
END_TEST

int main(void)
{
  TCase   *tests;
  Suite   *suite;
  SRunner *runner;

  tests = tcase_create("Test Parameter Checking");
  tcase_add_test(tests, test_libadc);
  tcase_add_test(tests, test_libevent);
  tcase_add_test(tests, test_libgpio);
  tcase_add_test(tests, test_libgpiod);
  tcase_add_test(tests, test_libhidraw);
  tcase_add_test(tests, test_libi2c);
  tcase_add_test(tests, test_libipv4);
  tcase_add_test(tests, test_liblinux);
  tcase_add_test(tests, test_liblinx);
  tcase_add_test(tests, test_libpwm);
  tcase_add_test(tests, test_libserial);
  tcase_add_test(tests, test_libspi);
  tcase_add_test(tests, test_libstream);
  tcase_add_test(tests, test_libwatchdog);

  suite = suite_create("Test Parameter Checking");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

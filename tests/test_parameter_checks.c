// Linux Simple I/O Library unit tests -- parameter checking

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

  ADC_open(-1, 0, &fd, &error);
  ck_assert(error == EINVAL);

  ADC_open(0, -1, &fd, &error);
  ck_assert(error == EINVAL);

  ADC_open(0, 0, NULL, &error);
  ck_assert(error == EINVAL);

  ADC_open(999, 0, &fd, &error);
  ck_assert(error == ENOENT);

  ADC_open(0, 999, &fd, &error);
  ck_assert(error == ENOENT);

  ADC_read(2, &sample, &error);
  ck_assert(error == EINVAL);

  ADC_read(3, NULL, &error);
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

  EVENT_register_fd(2, 0, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_register_fd(epfd, -1, 0, 0, &error);
  ck_assert(error == EINVAL);

  fd = open("/dev/null", O_RDONLY);
  ck_assert(fd > 0);

  EVENT_modify_fd(2, fd, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_modify_fd(epfd, -1, 0, 0, &error);
  ck_assert(error == EINVAL);

  EVENT_unregister_fd(2, fd, &error);
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

  GPIO_open(-1, &fd, &error);
  ck_assert(error == EINVAL);

  GPIO_open(0, NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_open(999, &fd, &error);
  ck_assert(error == ENOENT);

  GPIO_read(2, &state, &error);
  ck_assert(error == EINVAL);

  GPIO_read(3, NULL, &error);
  ck_assert(error == EINVAL);

  GPIO_read(999, &state, &error);
  ck_assert(error == EBADF);

  GPIO_write(2, 0, &error);
  ck_assert(error == EINVAL);

  GPIO_write(3, -1, &error);
  ck_assert(error == EINVAL);

  GPIO_write(3, 2, &error);
  ck_assert(error == EINVAL);

  GPIO_write(999, 0, &error);
  ck_assert(error == EBADF);

  GPIO_close(-1, &error);
  ck_assert(error == EINVAL);

  GPIO_close(999, &error);
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

  HIDRAW_open(NULL, &fd, &error);
  ck_assert(error == EINVAL);

  HIDRAW_open("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  HIDRAW_open("/dev/bogus", &fd, &error);
  ck_assert(error == ENOENT);

  HIDRAW_open_id(0, 0, NULL, &error);
  ck_assert(error == EINVAL);

  HIDRAW_open_id(0, 0, &fd, &error);
  ck_assert(error == ENODEV);

  HIDRAW_get_name(2, name, sizeof(name), &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(3, NULL, sizeof(name), &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(3, name, 15, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_name(999, name, sizeof(name), &error);
  ck_assert(error == EBADF);

  HIDRAW_get_info(2, &bustype, &vendor, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(3, NULL, &vendor, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(3, &bustype, NULL, &product, &error);
  ck_assert(error == EINVAL);

  HIDRAW_get_info(3, &bustype, &vendor, NULL, &error);
  ck_assert(error == EINVAL);

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

  I2C_open(NULL, &fd, &error);
  ck_assert(error == EINVAL);

  I2C_open("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  I2C_open("/dev/bogus", &fd, &error);
  ck_assert(error == ENOENT);

  I2C_transaction(2, 0x40, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, -1, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 128, cmd, sizeof(cmd), resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, cmd, -1, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, cmd, sizeof(cmd), resp, -1, &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, NULL, 1, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, cmd, 0, resp, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, cmd, sizeof(cmd), NULL, sizeof(resp), &error);
  ck_assert(error == EINVAL);

  I2C_transaction(3, 0x40, cmd, sizeof(cmd), resp, 0, &error);
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
  ck_assert(error == ENONET);

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

  LINUX_open(NULL, O_RDWR, 0644, &fd, &error);
  ck_assert(error == EINVAL);

  LINUX_open("/dev/bogus", O_RDWR, 0644, NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_open("/dev/bogus", O_RDWR, 0644, &fd, &error);
  ck_assert(error == ENOENT);

  LINUX_open("/dev/null", O_WRONLY|O_CREAT|O_EXCL, 0644, &fd, &error);
  ck_assert(error == EEXIST);

  LINUX_open("/dev/null", O_RDWR, 0644, &fd, &error);
  ck_assert(error == 0);
  ck_assert(fd > 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_read(NULL, &fd, &error);
  ck_assert(error == EINVAL);

  LINUX_open_read("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_open_read("/dev/bogus", &fd, &error);
  ck_assert(error == ENOENT);

  LINUX_open_read("/dev/null", &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_write(NULL, &fd, &error);
  ck_assert(error == EINVAL);

  LINUX_open_write("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_open_write("/dev/bogus", &fd, &error);
  ck_assert(error == ENOENT);

  LINUX_open_write("/dev/null", &fd, &error);
  ck_assert(error == 0);

  LINUX_close(fd, &error);
  ck_assert(error == 0);
  fd = -1;

  LINUX_open_readwrite(NULL, &fd, &error);
  ck_assert(error == EINVAL);

  LINUX_open_readwrite("/dev/bogus", NULL, &error);
  ck_assert(error == EINVAL);

  LINUX_open_readwrite("/dev/bogus", &fd, &error);
  ck_assert(error == ENOENT);

  LINUX_open_readwrite("/dev/null", &fd, &error);
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

int main(void)
{
  TCase   *tests;
  Suite   *suite;
  SRunner *runner;

  tests = tcase_create("Test Parameter Checking");
  tcase_add_test(tests, test_libadc);
  tcase_add_test(tests, test_libevent);
  tcase_add_test(tests, test_libgpio);
  tcase_add_test(tests, test_libhidraw);
  tcase_add_test(tests, test_libi2c);
  tcase_add_test(tests, test_libipv4);
  tcase_add_test(tests, test_liblinux);

  suite = suite_create("Test Parameter Checking");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

// Linux Simple I/O Library unit tests

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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
#include <unistd.h>

#include <libwioe5ham1.h>

START_TEST(test_initialize)
{
  int32_t handle;
  int32_t error;

  // Test empty serial port name

  wioe5ham1_init("", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test nonexistent serial port name

  wioe5ham1_init("/dev/ttyBOGUS", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test disconnected serial port name

  wioe5ham1_init("/dev/ttyS0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EIO);

  // Test invalid baud rates

  wioe5ham1_init("/dev/ttyUSB0", 2400, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 4800, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 9601, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid RF carrier frequencies

  wioe5ham1_init("/dev/ttyUSB0", 115200, 862.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 871.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 901.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 929.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid spreading factors

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 6, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 13, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid bandwidth

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 1000, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid tx preamble

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 0, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid rx preamble

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 0, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid transmit power

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, -1, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 23, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid network ID aka callsign

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXXX", 1, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid node ID

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 0, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 256, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid device handle

  wioe5ham1_exit(0,  &error);
  ck_assert(error == EINVAL);

  wioe5ham1_exit(1,  &error);
  ck_assert(error == EINVAL);

  wioe5ham1_exit(11, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_receive)
{
  int8_t msg[255];
  int32_t len;
  int32_t src;
  int32_t dst;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Test invalid device handle

  wioe5ham1_receive(0, msg, &len, &src, &dst, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_receive(1, msg, &len, &src, &dst, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_receive(11, msg, &len, &src, &dst, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_send)
{
  int32_t handle;
  int8_t msg[245];
  int32_t error;

  // Test invalid device handle

  wioe5ham1_send(0, msg, 1, 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send(1, msg, 1, 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send(11, msg, 1, 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(0, "This is a test.", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(1, "This is a test.", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(11, "This is a test.", 2, &error);
  ck_assert(error == EINVAL);

  // Need to get a device handle to test length and destination node ID values

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Test invalid length values

  wioe5ham1_send(handle, msg, 0, 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send(handle, msg, 244, 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(handle, "", 2, &error);
  ck_assert(error == EINVAL);

  memset(msg,  0, sizeof(msg));
  memset(msg, 'A', sizeof(msg)-1);

  wioe5ham1_send_string(handle, (char *) msg, 2, &error);
  ck_assert(error == EINVAL);

  // Test invalid destination node ID values

  wioe5ham1_send(handle, "DEADBEEF", 8, -1, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send(handle, "DEADBEEF", 8, 256, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(handle, "DEADBEEF", -1, &error);
  ck_assert(error == EINVAL);

  wioe5ham1_send_string(handle, "DEADBEEF", 256, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_radio)
{
  int32_t handle;
  int8_t msg[255];
  int32_t len;
  int32_t src;
  int32_t dst;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Initialize Wio-E5 radio subsystem

  wioe5ham1_init("/dev/ttyUSB0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Send a frame

  wioe5ham1_send(handle, "This is test_radio 1", 20, 2, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);

  usleep(300000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5ham1_receive(handle, msg, &len, &src, &dst, &RSS, &SNR, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);
  ck_assert(len > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS: %d dBm SNR: %d dB\n", len, RSS, SNR);

  // Send another frame

  wioe5ham1_send_string(handle, "This is test_radio 2", 2, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);

  usleep(300000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5ham1_receive(handle, msg, &len, &src, &dst, &RSS, &SNR, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);
  ck_assert(len > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS: %d dBm SNR: %d dB\n", len, RSS, SNR);

  // Test graceful exit

  wioe5ham1_exit(handle, &error);
  ck_assert(error == 0);
}

int main(void)
{
  TCase   *tests;
  Suite   *suite;
  SRunner *runner;

  tests = tcase_create("Initialize Checks");
  tcase_add_test(tests, test_initialize);
  tcase_add_test(tests, test_receive);
  tcase_add_test(tests, test_send);
  tcase_add_test(tests, test_radio);

  suite = suite_create("libwioe5ham1 Unit Tests");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

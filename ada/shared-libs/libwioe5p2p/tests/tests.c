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

#include <libwioe5p2p.h>

START_TEST(test_initialize)
{
  int32_t handle;
  int32_t error;

  // Test empty serial port name

  wioe5p2p_init("", 115200, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test nonexistent serial port name

  wioe5p2p_init("/dev/ttyBOGUS", 115200, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == ENOENT);

  // Test disconnected serial port name

  wioe5p2p_init("/dev/ttyS0", 115200, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EIO);

  // Test invalid baud rates

  wioe5p2p_init("/dev/ttyUSB0", 2400, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 4800, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 9601, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid RF carrier frequencies

  wioe5p2p_init("/dev/ttyUSB0", 115200, 862.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 871.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 901.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 929.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid spreading factors

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 6, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 13, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid bandwidth

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 1000, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid tx preamble

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 0, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid rx preamble

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 12, 0, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid transmit power

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 12, 15, -2, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 12, 15, 23, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid device handle

  wioe5p2p_exit(0,  &error);
  ck_assert(error == EINVAL);

  wioe5p2p_exit(1,  &error);
  ck_assert(error == EINVAL);

  wioe5p2p_exit(11, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_receive)
{
  int8_t msg[255];
  int32_t len;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Test invalid device handle

  wioe5p2p_receive(0, msg, &len, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_receive(1, msg, &len, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_receive(11, msg, &len, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_send)
{
  int32_t handle;
  int8_t msg[255];
  int32_t error;

  // Test invalid device handle

  wioe5p2p_send(0, msg, 1, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send(1, msg, 1, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send(11, msg, 1, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send_string(0, "This is a test.", &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send_string(1, "This is a test.", &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send_string(11, "This is a test.", &error);
  ck_assert(error == EINVAL);

  // Need to get a device handle to test length values

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Test invalid length values

  wioe5p2p_send(handle, msg, 0, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_send(handle, msg, 254, &error);
  ck_assert(error == EINVAL);

  // Test invalid length values

  wioe5p2p_send_string(handle, "", &error);
  ck_assert(error == EINVAL);

  memset(msg,  0, sizeof(msg));
  memset(msg, 'A', sizeof(msg)-1);

  wioe5p2p_send_string(handle, (char *) msg, &error);
  ck_assert(error == EINVAL);}
END_TEST

START_TEST(test_radio)
{
  int32_t handle;
  int8_t msg[255];
  int32_t len;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Initialize Wio-E5 radio subsystem

  wioe5p2p_init("/dev/ttyUSB0", 115200, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Send a frame

  wioe5p2p_send(handle, "This is test_radio 1", 20, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);

  usleep(300000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5p2p_receive(handle, msg, &len, &RSS, &SNR, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);
  ck_assert(len > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS:%d dBm SNR: %d dB\n", len, RSS, SNR);

  // Send another frame

  wioe5p2p_send_string(handle, "This is test_radio 2", &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);

  usleep(300000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5p2p_receive(handle, msg, &len, &RSS, &SNR, &error);
  ck_assert(handle == 1);
  ck_assert(error == 0);
  ck_assert(len > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS:%d dBm SNR: %d dB\n", len, RSS, SNR);

  // Test graceful exit

  wioe5p2p_exit(handle, &error);
  ck_assert(error == 0);
}
END_TEST

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

  suite = suite_create("libwioe5p2p Unit Tests");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

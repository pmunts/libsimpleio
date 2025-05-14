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

#include <libwioe5ham2.h>

START_TEST(test_initialize)
{
  int32_t handle;
  int32_t error;

  // Test empty serial port name

  wioe5ham2_init("", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test nonexistent serial port name

  wioe5ham2_init("/dev/ttyBOGUS", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == ENOENT);

  // Test disconnected serial port name

  wioe5ham2_init("/dev/ttyS0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EIO);

  // Test invalid baud rates

  wioe5ham2_init("/dev/ttyUSB0", 2400, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 4800, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 9601, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid RF carrier frequencies

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 901.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 929.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid spreading factors

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 6, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 13, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid bandwidth

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 1000, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid tx preamble

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 0, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid rx preamble

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 0, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid transmit power

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, -2, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 23, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid network ID

  wioe5ham2_init("/dev/ttyUSB0", 115200, "BEACON",    1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "BROADCAST", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "CQ",        1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid node ID

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 0, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 256, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid device handle

  wioe5ham2_exit(0,  &error);
  ck_assert(error == EINVAL);

  wioe5ham2_exit(1,  &error);
  ck_assert(error == EINVAL);

  wioe5ham2_exit(11, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_receive)
{
  int8_t msg[255];
  int32_t len;
  char srcnet[11];
  int32_t srcnode;
  char dstnet[11];
  int32_t dstnode;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Test invalid device handle

  wioe5ham2_receive(0, msg, &len, srcnet, &srcnode, dstnet, &dstnode, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_receive(1, msg, &len, srcnet, &srcnode, dstnet, &dstnode, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_receive(11, msg, &len, srcnet, &srcnode, dstnet, &dstnode, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_send)
{
  int32_t handle;
  int8_t msg[245];
  int32_t error;

  // Test invalid device handle

  wioe5ham2_send(0, msg, 1, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send(1, msg, 1, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send(11, msg, 1, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(0, "This is a test.", "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(1, "This is a test.", "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(11, "This is a test.", "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  // Need to get a device handle to test length and destination node ID values

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Test invalid length values

  wioe5ham2_send(handle, msg, 0, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send(handle, msg, 232, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(handle, "", "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  memset(msg,  0, sizeof(msg));
  memset(msg, 'A', sizeof(msg)-1);

  wioe5ham2_send_string(handle, (char *) msg, "N7AHL", 2, &error);
  ck_assert(error == EINVAL);

  // Test invalid destination node ID values

  wioe5ham2_send(handle, "DEADBEEF", 8, "N7AHL", -1, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send(handle, "DEADBEEF", 8, "N7AHL", 256, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(handle, "DEADBEEF", "N7AHL", -1, &error);
  ck_assert(error == EINVAL);

  wioe5ham2_send_string(handle, "DEADBEEF", "N7AHL", 256, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_radio)
{
  int32_t handle;
  int8_t msg[255];
  int32_t len;
  char srcnet[255];
  int32_t srcnode;
  char dstnet[255];
  int32_t dstnode;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Initialize Wio-E5 radio subsystem

  wioe5ham2_init("/dev/ttyUSB0", 115200, "N7AHL", 1, 927.0, 7, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == 0);
  ck_assert(handle == 1);

  // Send a frame

  wioe5ham2_send(handle, "This is test_radio 1", 20, "N7AHL", 2, &error);
  ck_assert(error == 0);

  usleep(400000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5ham2_receive(handle, msg, &len, srcnet, &srcnode, dstnet, &dstnode, &RSS, &SNR, &error);
  ck_assert(error == 0);
  ck_assert(len > 0);
  ck_assert(!strcmp(srcnet, "N7AHL"));
  ck_assert(srcnode == 2);
  ck_assert(!strcmp(dstnet, "N7AHL"));
  ck_assert(dstnode == 1);
  ck_assert(RSS < 0);
  ck_assert(SNR > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS:%d dBm SNR: %d dB\n", len, RSS, SNR);

  // Send another frame

  wioe5ham2_send_string(handle, "This is test_radio 2", "N7AHL", 0, &error);
  ck_assert(error == 0);

  usleep(400000);

  // Receive response frame

  memset(msg, 0, sizeof(msg));
  wioe5ham2_receive(handle, msg, &len, srcnet, &srcnode, dstnet, &dstnode, &RSS, &SNR, &error);
  ck_assert(error == 0);
  ck_assert(len > 0);
  ck_assert(!strcmp(srcnet, "N7AHL"));
  ck_assert(srcnode == 2);
  ck_assert(!strcmp(dstnet, "N7AHL"));
  ck_assert(dstnode == 1);
  ck_assert(RSS < 0);
  ck_assert(SNR > 0);
  msg[len] = 0;
  puts((char *) msg);
  printf("LEN: %d bytes RSS:%d dBm SNR: %d dB\n", len, RSS, SNR);

  // Test graceful exit

  wioe5ham2_exit(handle, &error);
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

  suite = suite_create("libwioe5ham2 Unit Tests");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

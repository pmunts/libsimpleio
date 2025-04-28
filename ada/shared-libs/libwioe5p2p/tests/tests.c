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

START_TEST(test_init_success)
{
  int32_t handle;
  int32_t error;

  // Success -- requires Wio-E5 Mini (https://wiki.seeedstudio.com/LoRa_E5_mini)
  // to be installed.

  if (!access("/dev/ttyUSB0", F_OK))
  {
    wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 12, 15, 22, &handle, &error);
    ck_assert(error == 0);
    ck_assert(handle == 1);
  }
}
END_TEST

START_TEST(test_init_portname)
{
  int32_t handle;
  int32_t error;

  // Test empty serial port name

  wioe5p2p_init("", 115200, 915.0, 12, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test nonexistent serial port name

  wioe5p2p_init("/dev/ttyBOGUS", 115200, 915.0, 12, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test disconnected serial port name

  wioe5p2p_init("/dev/ttyS0", 115200, 915.0, 12, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EIO);
}
END_TEST

START_TEST(test_init_spreading)
{
  int32_t handle;
  int32_t error;

  // Test invalid spreading factors

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 6, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);
  
  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 13, 500, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_init_bandwidth)
{
  int32_t handle;
  int32_t error;

  // Test invalid bandwidth

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 1000, 12, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_init_preambles)
{
  int32_t handle;
  int32_t error;

  // Test invalid tx preamble

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 0, 15, 22, &handle, &error);
  ck_assert(error == EINVAL);

  // Test invalid rx preamble

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 12, 0, 22, &handle, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_init_txpower)
{
  int32_t handle;
  int32_t error;

  // Test invalid transmit power

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 12, 15, -1, &handle, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 12, 15, 23, &handle, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_receive_success)
{
  int32_t handle;
  int32_t error;
  int8_t msg[243];
  int32_t len;
  int32_t RSS;
  int32_t SNR;

  // Success -- requires Wio-E5 Mini (https://wiki.seeedstudio.com/LoRa_E5_mini)
  // to be installed.

  if (!access("/dev/ttyUSB0", F_OK))
  {
    wioe5p2p_init("/dev/ttyUSB0", 115200, 915.0, 12, 500, 12, 15, 22, &handle, &error);
    ck_assert(error == 0);
    ck_assert(handle == 1);

    wioe5p2p_receive(handle, msg, &len, &RSS, &SNR, &error);
    ck_assert(error == 0);
  }
}
END_TEST

START_TEST(test_receive_handle)
{
  int8_t msg[243];
  int32_t len;
  int32_t RSS;
  int32_t SNR;
  int32_t error;

  // Test invalid device handle

  wioe5p2p_receive(0, msg, &len, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);

  wioe5p2p_receive(11, msg, &len, &RSS, &SNR, &error);
  ck_assert(error == EINVAL);
}
END_TEST

START_TEST(test_template)
{
  int32_t handle;
  int32_t error;
}
END_TEST

int main(void)
{
  TCase   *init_tests;
  TCase   *receive_tests;
  TCase   *send_tests;
  Suite   *suite;
  SRunner *runner;

  putenv("DEBUGLEVEL=1");

  init_tests = tcase_create("Initialize Parameter Checks");
  tcase_add_test(init_tests, test_init_success);
  tcase_add_test(init_tests, test_init_portname);
  tcase_add_test(init_tests, test_init_spreading);
  tcase_add_test(init_tests, test_init_bandwidth);
  tcase_add_test(init_tests, test_init_preambles);
  tcase_add_test(init_tests, test_init_txpower);

  receive_tests = tcase_create("Receive Parameter Checks");
  tcase_add_test(receive_tests, test_receive_success);
  tcase_add_test(receive_tests, test_receive_handle);

  send_tests = tcase_create("Send Parameter Checks");

  suite = suite_create("libwioe5p2p Unit Tests");
  suite_add_tcase(suite, init_tests);
  suite_add_tcase(suite, send_tests);
  suite_add_tcase(suite, receive_tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

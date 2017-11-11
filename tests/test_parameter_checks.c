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
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <libadc.h>
#include <libgpio.h>

static int terminated = false;

void _Exit(int status)
{
  terminated = true;
}

START_TEST(test_libadc)
{
  char name[256];
  int32_t error;
  int32_t fd;
  int32_t sample;

#ifdef VERBOSE
  putenv("DEBUGLEVEL=1");
#endif

  ADC_name(0, name, sizeof(name), NULL);
  ck_assert(terminated);

  ADC_name(-1, name, sizeof(name), &error);
  ck_assert(error == EINVAL);

  ADC_name(0, NULL, sizeof(name), &error);
  ck_assert(error == EINVAL);

  ADC_name(0, name, 15, &error);
  ck_assert(error == EINVAL);

  ADC_name(999, name, sizeof(name), &error);
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
}
END_TEST

int main(void)
{
  TCase   *tests;
  Suite   *suite;
  SRunner *runner;

  tests = tcase_create("Test Parameter Checking");
  tcase_add_test(tests, test_libadc);
  tcase_add_test(tests, test_libgpio);

  suite = suite_create("Test Parameter Checking");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}

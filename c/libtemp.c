/* Linux Industrial I/O temperature sensor services */

// Copyright (C)2025, Philip Munts dba Munts Technologies.
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

#include <fcntl.h>

#include "libtemp.h"
#include "iiocommon.inc"

#define SCALE_FILE1	"/sys/bus/iio/devices/iio:device%d/in_temp%d_scale"
#define SCALE_FILE2	"/sys/bus/iio/devices/iio:device%d/in_temp_scale"
#define DATA_FILE1	"/sys/bus/iio/devices/iio:device%d/in_temp%d_raw"
#define DATA_FILE2	"/sys/bus/iio/devices/iio:device%d/in_temp_raw"

void TEMP_get_scale(int32_t chip, int32_t channel, double *scale, int32_t *error)
{
  IIO_get_scale(chip, channel, SCALE_FILE1, SCALE_FILE2, scale, error);
}

void TEMP_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error)
{
  IIO_open(chip, channel, DATA_FILE1, DATA_FILE2, O_RDONLY, fd, error);
}

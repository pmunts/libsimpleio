// Simple byte stream message framing library

// Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

#ifndef _LIBSTREAM_H
#define _LIBSTREAM_H

#include <unistd.h>
#ifndef _BEGIN_STD_C
#include <cplusplus.h>
#endif
#include <stdint.h>

_BEGIN_STD_C

extern void STREAM_encode_frame(void *src, int32_t srclen, void *dst,
  int32_t dstsize, int32_t *dstlen, int32_t *error);

extern void STREAM_decode_frame(void *src, int32_t srclen, void *dst,
  int32_t dstsize, int32_t *dstlen, int32_t *error);

extern void STREAM_receive_frame(int32_t fd, void *buf, int32_t bufsize,
  int32_t *framesize, int32_t *error);

extern void STREAM_send_frame(int32_t fd, void *buf, int32_t bufsize,
  int32_t *count, int32_t *error);

_END_STD_C

#endif

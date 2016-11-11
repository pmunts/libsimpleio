// Labview LINX Common Commands module

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

#ifndef _COMMON_H_
#define _COMMON_H_

#include <liblinx.h>

#include "command.h"

// Prepare the LINX response message structure

#define PREPARE_RESPONSE					\
  memset(resp, 0, sizeof(LINX_response_t));			\
  resp->SoF = LINX_SOF;						\
  resp->PacketSize = 6;						\
  resp->PacketNum = cmd->PacketNum

// Validate the LINX command message size

#define CHECK_COMMAND_SIZE(low, high)				\
  if ((cmd->PacketSize < low) || (cmd->PacketSize > high))	\
  {								\
    resp->Status = L_UNKNOWN_ERROR;				\
    *error = EINVAL;						\
    return;							\
  }

extern void common_init(void);

#endif

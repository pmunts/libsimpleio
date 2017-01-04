// LabView LINX Remote I/O Protocol Command Executive module

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

#include "common.h"

// This function will not return until a fatal error occurrs or the
// connection is closed by the client.

void executive(int fd, int32_t *error)
{
  LINX_command_t cmd;
  LINX_response_t resp;
  int32_t count = 0;
  command_handler_t handler;

  for (;;)
  {
    LINX_receive_command(fd, &cmd, &count, error);

    // Process the various error cases

    switch (*error)
    {
      case 0 :
        LookupCommand(cmd.Command, &handler);
        if (handler == NULL)
        {
#ifdef __linux__
          syslog(LOG_ERR, "ERROR: Unrecognized command %04X", cmd.Command);
#endif

          memset(&resp, 0, sizeof(LINX_response_t));
          resp.SoF = LINX_SOF;
          resp.PacketSize = 6;
          resp.PacketNum = cmd.PacketNum;
          resp.Status = L_FUNCTION_NOT_SUPPORTED;
        }
        else
        {
          handler(&cmd, &resp, error);
          if (*error)
          {
#ifdef __linux__
            syslog(LOG_ERR, "ERROR: Command %04X handler failed, %s", cmd.Command, strerror(*error));
#endif
          }
        }

        LINX_transmit_response(fd, &resp, error);
        if (*error)
        {
#ifdef __linux__
          syslog(LOG_ERR, "ERROR: LINX_transmit_response() failed, %s", strerror(*error));
#endif
        }
        break;

      case EAGAIN :
      case EINVAL :
        continue;


      case EPIPE :
      case ECONNRESET :
#ifdef __linux__
        syslog(LOG_ERR, "Connection closed.");
#endif
        return;

      default :
#ifdef __linux__
        syslog(LOG_ERR, "ERROR: LINX_receive_command() failed, %s", strerror(*error));
#endif
        return;
        break;
    }
  }
}

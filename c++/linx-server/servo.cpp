// LabView LINX Remote I/O Protocol
// RC Servo output abstract interface module

// Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

#include <map>

#include "common.h"

// Local state variables

typedef std::map<uint8_t, Servo_Interface_Ptr> ServoChannelMap_t;

static ServoChannelMap_t ChannelTable;

//***************************************************************************

static void GetChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (ServoChannelMap_t::iterator it=ChannelTable.begin(); it!=ChannelTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void ServoSetPulseWidth(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->Args[0];
  uint8_t *ChannelNums = &cmd->Args[1];
  uint8_t *PulseWidths = &cmd->Args[1 + NumChannels];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(11, 8 + MaxChannels*3);
  CHECK_COMMAND_SIZE(8 + NumChannels*3, 8 + NumChannels*3);

  // Process the servo output channel list

  for (i = 0; i < NumChannels; i++)
  {
    uint8_t n = ChannelNums[i];
    uint16_t w = LINX_makeu16(PulseWidths[i*2+0], PulseWidths[i*2+1]);
    Servo_Interface_Ptr o;

    // Look up servo output channel object

    try
    {
      o = ChannelTable[n];
    }

    catch (int e)
    {
      resp->Status = L_UNKNOWN_ERROR;
      *error = ENODEV;
      return;
    }

    // Write the servo output channel pulse width

    o->write(w, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }
  }

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

// Add servo output channel object to the channel table

void servo_add_channel(uint8_t number, Servo_Interface_Ptr object)
{
  ChannelTable[number] = object;
}

//***************************************************************************

// Register command handlers

void servo_init(void)
{
  AddCommand(CMD_GET_SERVO_CHANNELS, GetChannels);
  AddCommand(CMD_SERVO_SET_PULSE_WIDTH, ServoSetPulseWidth);
}

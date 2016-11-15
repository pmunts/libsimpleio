// LabView LINX Remote I/O Protocol
// Pulse Width Modulation output abstract interface module

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

#include <map>

#include "common.h"

// Local state variables

typedef std::map<uint8_t, PWM_Interface_Ptr> PWMChannelMap_t;

static PWMChannelMap_t ChannelTable;

//***************************************************************************

static void GetChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (PWMChannelMap_t::iterator it=ChannelTable.begin(); it!=ChannelTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void PWMSetFrequency(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->Args[0];
  uint8_t *ChannelNums = &cmd->Args[1];
  uint8_t *Frequencies = &cmd->Args[1 + NumChannels];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(13, 8 + MaxChannels*5);
  CHECK_COMMAND_SIZE(8 + NumChannels*5, 8 + NumChannels*5);

  // Process the PWM output channel list

  for (i = 0; i < NumChannels; i++)
  {
    uint8_t n = ChannelNums[i];
    uint32_t f = LINX_makeu32(Frequencies[i*4+0], Frequencies[i*4+1],
      Frequencies[i*4+2], Frequencies[i*4+3]);
    PWM_Interface_Ptr o;

    // Look up PWM output channel object

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

    // Set the PWM output channel frequency

    o->set_frequency(f, error);
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

static void PWMSetDutyCycle(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->Args[0];
  uint8_t *ChannelNums = &cmd->Args[1];
  uint8_t *DutyCycles = &cmd->Args[1 + NumChannels];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(10, 8 + MaxChannels*2);
  CHECK_COMMAND_SIZE(8 + NumChannels*2, 8 + NumChannels*2);

  // Process the PWM output channel list

  for (i = 0; i < NumChannels; i++)
  {
    uint8_t n = ChannelNums[i];
    uint8_t d = DutyCycles[i];
    PWM_Interface_Ptr o;

    // Look up PWM output channel object

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

    // Write the PWM output channel duty cycle

    o->write(d, error);
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

// Add PWM output channel object to the channel table

void pwm_add_channel(uint8_t number, PWM_Interface_Ptr object)
{
  ChannelTable[number] = object;
}

//***************************************************************************

// Register command handlers

void pwm_init(void)
{
  AddCommand(CMD_GET_PWM_CHANNELS, GetChannels);
  AddCommand(CMD_PWM_SET_FREQUENCY, PWMSetFrequency);
  AddCommand(CMD_PWM_SET_DUTYCYCLE, PWMSetDutyCycle);
}

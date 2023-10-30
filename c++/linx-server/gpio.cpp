// LabView LINX Remote I/O Protocol
// General Purpose Input/Output abstract interface module

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

typedef std::map<uint8_t, GPIO_Interface_Ptr> GPIO_Map_t;

static GPIO_Map_t ChannelTable;

//***************************************************************************

static void GetGPIOChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (GPIO_Map_t::iterator it=ChannelTable.begin(); it!=ChannelTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GPIOConfigure(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->Args[0];
  uint8_t *ChannelNums = &cmd->Args[1];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(10, 9 + MaxChannels + MaxChannels / 8);
  CHECK_COMMAND_SIZE(9 + NumChannels + NumChannels / 8, 9 + NumChannels + NumChannels / 8);

  // Process the GPIO channel list

  for (i = 0; i < NumChannels; i++)
  {
    int32_t n = ChannelNums[i];
    int32_t d = (cmd->Args[NumChannels + 1 + i / 8] >> (i % 8)) & 0x01;
    GPIO_Interface_Ptr o;

    // Lookup GPIO object

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

    // Configure the GPIO channel

    o->configure(d, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }

    o->IsOutput = d;
  }

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GPIOWrite(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->Args[0];
  uint8_t *ChannelNums = &cmd->Args[1];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(10, 9 + MaxChannels + MaxChannels / 8);
  CHECK_COMMAND_SIZE(9 + NumChannels + NumChannels / 8, 9 + NumChannels + NumChannels / 8);

  // Process the GPIO channel list

  for (i = 0; i < NumChannels; i++)
  {
    int32_t n = ChannelNums[i];
    int32_t v = (cmd->Args[NumChannels + 1 + i / 8] >> (i % 8)) & 0x01;
    GPIO_Interface_Ptr o;

    // Lookup GPIO channel object

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

    // Configure the GPIO channel as an output, if necessary

    if (!o->IsOutput)
    {
      o->configure(true, error);
      if (*error)
      {
        resp->Status = L_UNKNOWN_ERROR;
        return;
      }

      o->IsOutput = true;
    }

    // Write to the GPIO channel

    o->write(v, error);
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

static void GPIORead(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ChannelTable.size();
  unsigned NumChannels = cmd->PacketSize - 7;
  uint8_t *ChannelNums = &cmd->Args[0];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(8, 7 + MaxChannels);
  CHECK_COMMAND_SIZE(7 + NumChannels, 7 + NumChannels);

  // Process the GPIO channel list

  for (i = 0; i < NumChannels; i++)
  {
    int32_t n = ChannelNums[i];
    int32_t v;
    GPIO_Interface_Ptr o;

    // Lookup GPIO channel object

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

    // Read the GPIO channel

    o->read(&v, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }

    resp->Data[i / 8] |= (v << (7 - i % 8));
  }

  resp->PacketSize += NumChannels/8 + 1;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

// Add a GPIO channel to the channel table

void gpio_add_channel(uint8_t number, GPIO_Interface_Ptr object)
{
  ChannelTable[number] = object;
}

//***************************************************************************

// Register command handlers

void gpio_init(void)
{
  AddCommand(CMD_GET_GPIO_CHANNELS, GetGPIOChannels);
  AddCommand(CMD_GPIO_CONFIGURE, GPIOConfigure);
  AddCommand(CMD_GPIO_WRITE, GPIOWrite);
  AddCommand(CMD_GPIO_READ, GPIORead);
}

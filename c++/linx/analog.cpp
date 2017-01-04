// LabView Linx Remote I/O Protocol Analog I/O abstract interface module

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

#include <map>

#include "common.h"

#define NORMALIZED_REFERENCE	4292967
#define NORMALIZED_RESOLUTION	32

// Local state variables

typedef std::map<uint8_t, ADC_Interface_Ptr> ADCChannelMap_t;
typedef std::map<uint8_t, DAC_Interface_Ptr> DACChannelMap_t;

static ADCChannelMap_t ADCChannelTable;
static DACChannelMap_t DACChannelTable;

//***************************************************************************

static void GetADCChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (ADCChannelMap_t::iterator it=ADCChannelTable.begin(); it!=ADCChannelTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetDACChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (DACChannelMap_t::iterator it=DACChannelTable.begin(); it!=DACChannelTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetReference(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  resp->Data[0] = LINX_splitu32(NORMALIZED_REFERENCE, 0);
  resp->Data[1] = LINX_splitu32(NORMALIZED_REFERENCE, 1);
  resp->Data[2] = LINX_splitu32(NORMALIZED_REFERENCE, 2);
  resp->Data[3] = LINX_splitu32(NORMALIZED_REFERENCE, 3);

  resp->PacketSize += 4;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void AnalogRead(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxChannels = ADCChannelTable.size();
  unsigned NumChannels = cmd->PacketSize - 7;
  uint8_t *ChannelNums = &cmd->Args[0];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(8, 7 + MaxChannels);
  CHECK_COMMAND_SIZE(7 + NumChannels, 7 + NumChannels);

  resp->Data[0] = NORMALIZED_RESOLUTION;

  // Process the ADC input channel list

  for (i = 0; i < NumChannels; i++)
  {
    uint8_t n = ChannelNums[i];
    uint32_t v;
    ADC_Interface_Ptr o;

    // Lookup analog input channel object

    try
    {
      o = ADCChannelTable[n];
    }

    catch (int e)
    {
      resp->Status = L_UNKNOWN_ERROR;
      *error = ENODEV;
      return;
    }

    // Read the analog input channel

    o->read(&v, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }

    resp->Data[1 + i*4] = LINX_splitu32(v, 0);
    resp->Data[2 + i*4] = LINX_splitu32(v, 1);
    resp->Data[3 + i*4] = LINX_splitu32(v, 2);
    resp->Data[4 + i*4] = LINX_splitu32(v, 3);
  }

  resp->PacketSize += 1 + NumChannels*4;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void AnalogWrite(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;

  resp->Status = L_FUNCTION_NOT_SUPPORTED;
  *error = EINVAL;
}

//***************************************************************************

// Add an analog input object to the A/D channel table

void adc_add_channel(uint8_t number, ADC_Interface_Ptr object)
{
  ADCChannelTable[number] = object;
}

//***************************************************************************

// Add an analog output object to the D/A channel table

void dac_add_channel(uint8_t number, DAC_Interface_Ptr object)
{
  DACChannelTable[number] = object;
}

//***************************************************************************

// Register command handlers

void analog_init(void)
{
  AddCommand(CMD_GET_ANALOG_IN_CHANNELS, GetADCChannels);
  AddCommand(CMD_GET_ANALOG_OUT_CHANNELS, GetDACChannels);
  AddCommand(CMD_GET_ANALOG_REFERENCE, GetReference);
  AddCommand(CMD_ANALOG_READ, AnalogRead);
  AddCommand(CMD_ANALOG_WRITE, AnalogWrite);
}

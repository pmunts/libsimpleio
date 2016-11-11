// General Purpose Input/Output Pin abstract interface module

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

#include <errno.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "gpio.h"

// Local state variables

typedef std::map<uint8_t, GPIO_Interface_Ptr> GPIO_Map_t;

static GPIO_Map_t PinTable;

//***************************************************************************

static void GetGPIOChannels(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned ChannelIndex = 0;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  for (GPIO_Map_t::iterator it=PinTable.begin(); it!=PinTable.end(); ++it)
    resp->Data[ChannelIndex++] = it->first;

  resp->PacketSize += ChannelIndex;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GPIOConfigure(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxPins = PinTable.size();
  unsigned NumPins = cmd->Args[0];
  uint8_t *PinNums = &cmd->Args[1];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(10, 9 + MaxPins + MaxPins / 8);
  CHECK_COMMAND_SIZE(9 + NumPins + NumPins / 8, 9 + NumPins + NumPins / 8);

  // Process the GPIO pin list

  for (i = 0; i < NumPins; i++)
  {
    int32_t p = PinNums[i];
    int32_t d = (cmd->Args[NumPins + 1 + i / 8] >> (i % 8)) & 0x01;
    GPIO_Interface_Ptr pin;

    // Lookup pin info

    try
    {
      pin = PinTable[p];
    }

    catch (int e)
    {
      resp->Status = L_UNKNOWN_ERROR;
      *error = ENODEV;
      return;
    }

    // Configure the GPIO pin

    pin->configure(d, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }

    pin->IsOutput = d;
  }

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GPIOWrite(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  unsigned MaxPins = PinTable.size();
  unsigned NumPins = cmd->Args[0];
  uint8_t *PinNums = &cmd->Args[1];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(10, 9 + MaxPins + MaxPins / 8);
  CHECK_COMMAND_SIZE(9 + NumPins + NumPins / 8, 9 + NumPins + NumPins / 8);

  // Process the GPIO pin list

  for (i = 0; i < NumPins; i++)
  {
    int32_t p = PinNums[i];
    int32_t v = (cmd->Args[NumPins + 1 + i / 8] >> (i % 8)) & 0x01;
    GPIO_Interface_Ptr pin;

    // Lookup pin info

    try
    {
      pin = PinTable[p];
    }

    catch (int e)
    {
      resp->Status = L_UNKNOWN_ERROR;
      *error = ENODEV;
      return;
    }

    // Configure the GPIO pin as an output, if necessary

    if (!pin->IsOutput)
    {
      pin->configure(true, error);
      if (*error)
      {
        resp->Status = L_UNKNOWN_ERROR;
        return;
      }

      pin->IsOutput = true;
    }

    // Write to the GPIO pin

    pin->write(v, error);
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
  unsigned MaxPins = PinTable.size();
  unsigned NumPins = cmd->PacketSize - 7;
  uint8_t *PinNums = &cmd->Args[0];
  unsigned i;

  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(8, 7 + MaxPins);
  CHECK_COMMAND_SIZE(7 + NumPins, 7 + NumPins);

  // Process the GPIO pin list

  for (i = 0; i < NumPins; i++)
  {
    int32_t p = PinNums[i];
    int32_t v;
    GPIO_Interface_Ptr pin;

    // Lookup pin info

    try
    {
      pin = PinTable[p];
    }

    catch (int e)
    {
      resp->Status = L_UNKNOWN_ERROR;
      *error = ENODEV;
      return;
    }

    // Read the GPIO pin

    pin->read(&v, error);
    if (*error)
    {
      resp->Status = L_UNKNOWN_ERROR;
      return;
    }

    resp->Data[i / 8] |= (v << (7 - i % 8));
  }

  resp->PacketSize += NumPins/8 + 1;
  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

// Add a GPIO pin to the pin table

void gpio_add_channel(uint8_t channel, GPIO_Interface_Ptr pin)
{
  PinTable[channel] = pin;
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

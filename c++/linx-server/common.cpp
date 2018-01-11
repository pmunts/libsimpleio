// LabView LINX Command Commands module

// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

// External constants, defined in the main program file

extern const uint8_t	LINX_DEVICE_FAMILY;
extern const uint8_t	LINX_DEVICE_ID;
extern const char	LINX_DEVICE_NAME[];

// Local state variables

static uint16_t DeviceUserID = 0;

//***************************************************************************

static void NoOperation(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetDeviceID(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  resp->PacketSize = 8;

  resp->Data[0] = LINX_DEVICE_FAMILY;
  resp->Data[1] = LINX_DEVICE_ID;

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetAPIVersion(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  resp->PacketSize = 10;

  resp->Data[0] = LINX_splitu32(LINX_VERSION, 0);
  resp->Data[1] = LINX_splitu32(LINX_VERSION, 1);
  resp->Data[2] = LINX_splitu32(LINX_VERSION, 2);
  resp->Data[3] = LINX_splitu32(LINX_VERSION, 3);

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void SetDeviceUserID(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(9, 9);

  // Save device user ID

  DeviceUserID = LINX_makeu16(cmd->Args[0], cmd->Args[1]);

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetDeviceUserID(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  // Return the previously saved device user ID

  resp->PacketSize = 8;

  resp->Data[0] = LINX_splitu16(DeviceUserID, 0);
  resp->Data[1] = LINX_splitu16(DeviceUserID, 1);

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

static void GetDeviceName(LINX_command_t *cmd, LINX_response_t *resp, int32_t *error)
{
  PREPARE_RESPONSE;
  CHECK_COMMAND_SIZE(7, 7);

  // Return the device name string

  resp->PacketSize += strlen(LINX_DEVICE_NAME) + 1;

  memcpy(resp->Data, LINX_DEVICE_NAME, strlen(LINX_DEVICE_NAME));

  resp->Status = L_OK;
  *error = 0;
}

//***************************************************************************

// Register default command handlers

void common_init(void)
{
  AddCommand(CMD_SYNC, NoOperation);
  AddCommand(CMD_DISCONNECT, NoOperation);
  AddCommand(CMD_FLUSH, NoOperation);
  AddCommand(CMD_SYSTEM_RESET, NoOperation);

  // Device information commands

  AddCommand(CMD_GET_DEVICE_ID, GetDeviceID);
  AddCommand(CMD_GET_LINX_API_VERSION, GetAPIVersion);
  AddCommand(CMD_SET_DEVICE_USER_ID, SetDeviceUserID);
  AddCommand(CMD_GET_DEVICE_USER_ID, GetDeviceUserID);
  AddCommand(CMD_GET_DEVICE_NAME, GetDeviceName);

  // Peripheral subsytem channels query commands

  AddCommand(CMD_GET_ANALOG_IN_CHANNELS, NoOperation);
  AddCommand(CMD_GET_ANALOG_OUT_CHANNELS, NoOperation);
  AddCommand(CMD_GET_ANALOG_REFERENCE, NoOperation);
  AddCommand(CMD_GET_CAN_CHANNELS, NoOperation);
  AddCommand(CMD_GET_GPIO_CHANNELS, NoOperation);
  AddCommand(CMD_GET_I2C_CHANNELS, NoOperation);
  AddCommand(CMD_GET_PWM_CHANNELS, NoOperation);
  AddCommand(CMD_GET_QE_CHANNELS, NoOperation);
  AddCommand(CMD_GET_SERVO_CHANNELS, NoOperation);
  AddCommand(CMD_GET_SPI_CHANNELS, NoOperation);
  AddCommand(CMD_GET_UART_CHANNELS, NoOperation);
}

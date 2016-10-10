-- Minimal Ada wrapper for the LabView LINX Remote I/O services
-- implemented in libsimpleio.so

-- Copyright (C)2016, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

PACKAGE libsimpleio.LINX IS

  -- Type definitions

  TYPE uint8_t  IS MOD 2**8;

  TYPE uint16_t IS MOD 2**16;

  TYPE uint32_t IS MOD 2**32;

  TYPE args_t IS ARRAY (0 .. 53) OF uint8_t;

  TYPE data_t IS ARRAY (0 .. 54) OF uint8_t;

  TYPE LINX_command_t IS RECORD
    SoF        : uint8_t;
    PacketSize : uint8_t;
    PacketNum  : uint16_t;
    Command    : uint16_t;
    Args       : args_t;
  END RECORD;
  PRAGMA Pack(LINX_command_t);

  TYPE LINX_response_t IS RECORD
    SoF        : uint8_t;
    PacketSize : uint8_t;
    PacketNum  : uint16_t;
    Status     : uint8_t;
    Data       : data_t;
  END RECORD;
  PRAGMA Pack(LINX_response_t);

  -- Constant definitions

  LINX_SOF : CONSTANT uint8_t := 16#FF#;

  -- LabView LINX remote I/O protocol standard commands

  CMD_SYNC                            : CONSTANT Integer := 16#0000#;
  CMD_FLUSH                           : CONSTANT Integer := 16#0001#;
  CMD_SYSTEM_RESET                    : CONSTANT Integer := 16#0002#;
  CMD_GET_DEVICE_ID                   : CONSTANT Integer := 16#0003#;
  CMD_GET_LINX_API_VERSION            : CONSTANT Integer := 16#0004#;
  CMD_GET_MAX_BAUD_RATE               : CONSTANT Integer := 16#0005#;
  CMD_SET_BAUD_RATE                   : CONSTANT Integer := 16#0006#;
  CMD_GET_MAX_PACKET_SIZE             : CONSTANT Integer := 16#0007#;
  CMD_GET_GPIO_CHANNELS               : CONSTANT Integer := 16#0008#;
  CMD_GET_ANALOG_IN_CHANNELS          : CONSTANT Integer := 16#0009#;
  CMD_GET_ANALOG_OUT_CHANNELS         : CONSTANT Integer := 16#000A#;
  CMD_GET_PWM_CHANNELS                : CONSTANT Integer := 16#000B#;
  CMD_GET_QE_CHANNELS                 : CONSTANT Integer := 16#000C#;
  CMD_GET_UART_CHANNELS               : CONSTANT Integer := 16#000D#;
  CMD_GET_I2C_CHANNELS                : CONSTANT Integer := 16#000E#;
  CMD_GET_SPI_CHANNELS                : CONSTANT Integer := 16#000F#;
  CMD_GET_CAN_CHANNELS                : CONSTANT Integer := 16#0010#;
  CMD_DISCONNECT                      : CONSTANT Integer := 16#0011#;
  CMD_SET_DEVICE_USER_ID              : CONSTANT Integer := 16#0012#;
  CMD_GET_DEVICE_USER_ID              : CONSTANT Integer := 16#0013#;
  CMD_SET_DEVICE_ETHERNET_IPADDR      : CONSTANT Integer := 16#0014#;
  CMD_GET_DEVICE_ETHERNET_IPADDR      : CONSTANT Integer := 16#0015#;
  CMD_SET_DEVICE_ETHERNET_TCPPORT     : CONSTANT Integer := 16#0016#;
  CMD_GET_DEVICE_ETHERNET_TCPPORT     : CONSTANT Integer := 16#0017#;
  CMD_SET_DEVICE_WIFI_IPADDR          : CONSTANT Integer := 16#0018#;
  CMD_GET_DEVICE_WIFI_IPADDR          : CONSTANT Integer := 16#0019#;
  CMD_SET_DEVICE_WIFI_TCPPORT         : CONSTANT Integer := 16#001A#;
  CMD_GET_DEVICE_WIFI_TCPPORT         : CONSTANT Integer := 16#001B#;
  CMD_SET_DEVICE_WIFI_SSID            : CONSTANT Integer := 16#001C#;
  CMD_GET_DEVICE_WIFI_SSID            : CONSTANT Integer := 16#001D#;
  CMD_SET_DEVICE_WIFI_SECURITY        : CONSTANT Integer := 16#001E#;
  CMD_GET_DEVICE_WIFI_SECURITY        : CONSTANT Integer := 16#001F#;
  CMD_SET_DEVICE_WIFI_PASSWORD        : CONSTANT Integer := 16#0020#;
  CMD_GET_DEVICE_WIFI_PASSWORD        : CONSTANT Integer := 16#0021#;
  CMD_SET_DEVICE_LINX_MAX             : CONSTANT Integer := 16#0022#;
  CMD_GET_DEVICE_LINX_MAX_BAUD_RATE   : CONSTANT Integer := 16#0023#;
  CMD_GET_DEVICE_NAME                 : CONSTANT Integer := 16#0024#;
  CMD_GET_SERVO_CHANNELS              : CONSTANT Integer := 16#0025#;
  CMD_GPIO_CONFIGURE                  : CONSTANT Integer := 16#0040#;
  CMD_GPIO_WRITE                      : CONSTANT Integer := 16#0041#;
  CMD_GPIO_READ                       : CONSTANT Integer := 16#0042#;
  CMD_GPIO_SQUARE_WAVE                : CONSTANT Integer := 16#0043#;
  CMD_GPIO_PULSE_WIDTH                : CONSTANT Integer := 16#0044#;
  CMD_SET_ANALOG_REFERENCE            : CONSTANT Integer := 16#0060#;
  CMD_GET_ANALOG_IN_REFERENCE         : CONSTANT Integer := 16#0061#;
  CMD_SET_ANALOG_RESOLUTION           : CONSTANT Integer := 16#0062#;
  CMD_GET_ANALOG_RESOLUTION           : CONSTANT Integer := 16#0063#;
  CMD_ANALOG_READ                     : CONSTANT Integer := 16#0064#;
  CMD_ANALOG_WRITE                    : CONSTANT Integer := 16#0065#;
  CMD_PWM_OPEN                        : CONSTANT Integer := 16#0080#;
  CMD_PWM_SET_MODE                    : CONSTANT Integer := 16#0081#;
  CMD_PWM_SET_FREQUENCY               : CONSTANT Integer := 16#0082#;
  CMD_PWM_SET_DUTYCYCLE               : CONSTANT Integer := 16#0083#;
  CMD_PWM_CLOSE                       : CONSTANT Integer := 16#0084#;
  CMD_UART_OPEN                       : CONSTANT Integer := 16#00C0#;
  CMD_UART_SET_BAUD_RATE              : CONSTANT Integer := 16#00C1#;
  CMD_UART_GET_BYTES_AVAILABLE        : CONSTANT Integer := 16#00C2#;
  CMD_UART_READ                       : CONSTANT Integer := 16#00C3#;
  CMD_UART_WRITE                      : CONSTANT Integer := 16#00C4#;
  CMD_UART_CLOSE                      : CONSTANT Integer := 16#00C5#;
  CMD_I2C_OPEN                        : CONSTANT Integer := 16#00E0#;
  CMD_I2C_SET_SPEED                   : CONSTANT Integer := 16#00E1#;
  CMD_I2C_WRITE                       : CONSTANT Integer := 16#00E2#;
  CMD_I2C_READ                        : CONSTANT Integer := 16#00E3#;
  CMD_I2C_CLOSE                       : CONSTANT Integer := 16#00E4#;
  CMD_SPI_OPEN                        : CONSTANT Integer := 16#0100#;
  CMD_SPI_SET_BIT_ORDER               : CONSTANT Integer := 16#0101#;
  CMD_SPI_SET_CLOCK_FREQUENCY         : CONSTANT Integer := 16#0102#;
  CMD_SPI_SET_MODE                    : CONSTANT Integer := 16#0103#;
  CMD_SPI_SET_FRAME_SIZE              : CONSTANT Integer := 16#0104#;
  CMD_SPI_SET_CS_LOGIC_LEVEL          : CONSTANT Integer := 16#0105#;
  CMD_SPI_SET_CS_PIN                  : CONSTANT Integer := 16#0106#;
  CMD_SPI_WRITE_READ                  : CONSTANT Integer := 16#0107#;
  CMD_SERVO_OPEN                      : CONSTANT Integer := 16#0140#;
  CMD_SERVO_SET_PULSE_WIDTH           : CONSTANT Integer := 16#0141#;
  CMD_SERVO_CLOSE                     : CONSTANT Integer := 16#0142#;
  CMD_WS2812_OPEN                     : CONSTANT Integer := 16#0160#;
  CMD_WS2812_WRITE_ONE_PIXEL          : CONSTANT Integer := 16#0161#;
  CMD_WS2812_WRITE_N_PIXELS           : CONSTANT Integer := 16#0162#;
  CMD_WS2812_REFRESH                  : CONSTANT Integer := 16#0163#;
  CMD_WS2812_CLOSE                    : CONSTANT Integer := 16#0164#;
  CMD_CUSTOM_BASE                     : CONSTANT Integer := 16#FC00#;

  -- LabView LINX remote I/O protocol custom commands

  CMD_CUSTOM0                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 0);
  CMD_CUSTOM1                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 1);
  CMD_CUSTOM2                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 2);
  CMD_CUSTOM3                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 3);
  CMD_CUSTOM4                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 4);
  CMD_CUSTOM5                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 5);
  CMD_CUSTOM6                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 6);
  CMD_CUSTOM7                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 7);
  CMD_CUSTOM8                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 8);
  CMD_CUSTOM9                         : CONSTANT Integer := (CMD_CUSTOM_BASE + 9);

  -- LabView LINX remote I/O protocol standard status codes

  L_OK                                : CONSTANT Integer := 16#00#;
  L_FUNCTION_NOT_SUPPORTED            : CONSTANT Integer := 16#01#;
  L_REQUEST_RESEND                    : CONSTANT Integer := 16#02#;
  L_UNKNOWN_ERROR                     : CONSTANT Integer := 16#03#;
  L_DISCONNECT                        : CONSTANT Integer := 16#04#;

  -- LabView LINX Remote I/O server procedures

  PROCEDURE ReceiveCommand
   (fd    : Integer;
    cmd   : IN OUT LINX_command_t;
    error : OUT Integer);
  PRAGMA Import(C, ReceiveCommand, "LINX_receive_command");

  PROCEDURE SendResponse
   (fd    : Integer;
    resp  : IN OUT LINX_response_t;
    error : OUT Integer);
  PRAGMA Import(C, SendResponse, "LINX_transmit_response");

  -- LabView LINX Remote I/O client procedures

  PROCEDURE SendCommand
   (fd    : Integer;
    cmd   : IN OUT LINX_command_t;
    error : OUT Integer);
  PRAGMA Import(C, SendCommand, "LINX_transmit_command");

  PROCEDURE ReceiveResponse
   (fd    : Integer;
    resp  : IN OUT LINX_response_t;
    error : OUT Integer);
  PRAGMA Import(C, ReceiveResponse, "LINX_receive_response");

  -- Pack two 8-bit bytes into one 16-bit word
  -- b0 is most significant byte
  -- b1 is least significant byte

  FUNCTION MakeU16
   (b0 : uint8_t;
    b1 : uint8_t) RETURN uint16_t;
  PRAGMA Import(C, MakeU16, "LINX_makeu16");

  -- Pack for 8-bit bytes into one 32-bit word
  -- b0 is most significant byte
  -- b3 is least significant byte

  FUNCTION MakeU32
   (b0 : uint8_t;
    b1 : uint8_t;
    b2 : uint8_t;
    b3 : uint8_t) RETURN uint32_t;
  PRAGMA Import(C, MakeU32, "LINX_makeu32");

  -- Extract a single byte from a 16-bit word
  -- index 0 is most significant byte
  -- index 1 is least significant byte

  FUNCTION SplitU16
   (item  : uint16_t;
    index : Integer) RETURN uint8_t;
  PRAGMA Import(C, SplitU16, "LINX_splitu16");

  -- Extract a single byte from a 32-bit word
  -- index 0 is most significant byte
  -- index 3 is least significant byte

  FUNCTION SplitU32
   (item  : uint32_t;
    index : Integer) RETURN uint8_t;
  PRAGMA Import(C, SplitU32, "LINX_splitu32");

END libsimpleio.LINX;

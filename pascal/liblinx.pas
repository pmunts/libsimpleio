{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.             }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT libLINX;

INTERFACE

  CONST
    LINX_SOF                          = $FF;
    LINX_VERSION                      = $03000000;

    { LabView LINX Remote I/O Commands }

    CMD_SYNC                          = $0000;
    CMD_FLUSH                         = $0001;
    CMD_SYSTEM_RESET                  = $0002;
    CMD_GET_DEVICE_ID                 = $0003;
    CMD_GET_LINX_API_VERSION          = $0004;
    CMD_GET_MAX_BAUD_RATE             = $0005;
    CMD_SET_BAUD_RATE                 = $0006;
    CMD_GET_MAX_PACKET_SIZE           = $0007;
    CMD_GET_GPIO_CHANNELS             = $0008;
    CMD_GET_ANALOG_IN_CHANNELS        = $0009;
    CMD_GET_ANALOG_OUT_CHANNELS       = $000A;
    CMD_GET_PWM_CHANNELS              = $000B;
    CMD_GET_QE_CHANNELS               = $000C;
    CMD_GET_UART_CHANNELS             = $000D;
    CMD_GET_I2C_CHANNELS              = $000E;
    CMD_GET_SPI_CHANNELS              = $000F;
    CMD_GET_CAN_CHANNELS              = $0010;
    CMD_DISCONNECT                    = $0011;
    CMD_SET_DEVICE_USER_ID            = $0012;
    CMD_GET_DEVICE_USER_ID            = $0013;
    CMD_SET_DEVICE_ETHERNET_IPADDR    = $0014;
    CMD_GET_DEVICE_ETHERNET_IPADDR    = $0015;
    CMD_SET_DEVICE_ETHERNET_TCPPORT   = $0016;
    CMD_GET_DEVICE_ETHERNET_TCPPORT   = $0017;
    CMD_SET_DEVICE_WIFI_IPADDR        = $0018;
    CMD_GET_DEVICE_WIFI_IPADDR        = $0019;
    CMD_SET_DEVICE_WIFI_TCPPORT       = $001A;
    CMD_GET_DEVICE_WIFI_TCPPORT       = $001B;
    CMD_SET_DEVICE_WIFI_SSID          = $001C;
    CMD_GET_DEVICE_WIFI_SSID          = $001D;
    CMD_SET_DEVICE_WIFI_SECURITY      = $001E;
    CMD_GET_DEVICE_WIFI_SECURITY      = $001F;
    CMD_SET_DEVICE_WIFI_PASSWORD      = $0020;
    CMD_GET_DEVICE_WIFI_PASSWORD      = $0021;
    CMD_SET_DEVICE_LINX_MAX           = $0022;
    CMD_GET_DEVICE_LINX_MAX_BAUD_RATE = $0023;
    CMD_GET_DEVICE_NAME               = $0024;
    CMD_GET_SERVO_CHANNELS            = $0025;
    CMD_GPIO_CONFIGURE                = $0040;
    CMD_GPIO_WRITE                    = $0041;
    CMD_GPIO_READ                     = $0042;
    CMD_GPIO_SQUARE_WAVE              = $0043;
    CMD_GPIO_PULSE_WIDTH              = $0044;
    CMD_SET_ANALOG_REFERENCE          = $0060;
    CMD_GET_ANALOG_REFERENCE          = $0061;
    CMD_SET_ANALOG_RESOLUTION         = $0062;
    CMD_GET_ANALOG_RESOLUTION         = $0063;
    CMD_ANALOG_READ                   = $0064;
    CMD_ANALOG_WRITE                  = $0065;
    CMD_PWM_OPEN                      = $0080;
    CMD_PWM_SET_MODE                  = $0081;
    CMD_PWM_SET_FREQUENCY             = $0082;
    CMD_PWM_SET_DUTYCYCLE             = $0083;
    CMD_PWM_CLOSE                     = $0084;
    CMD_UART_OPEN                     = $00C0;
    CMD_UART_SET_BAUD_RATE            = $00C1;
    CMD_UART_GET_BYTES_AVAILABLE      = $00C2;
    CMD_UART_READ                     = $00C3;
    CMD_UART_WRITE                    = $00C4;
    CMD_UART_CLOSE                    = $00C5;
    CMD_I2C_OPEN                      = $00E0;
    CMD_I2C_SET_SPEED                 = $00E1;
    CMD_I2C_WRITE                     = $00E2;
    CMD_I2C_READ                      = $00E3;
    CMD_I2C_CLOSE                     = $00E4;
    CMD_SPI_OPEN                      = $0100;
    CMD_SPI_SET_BIT_ORDER             = $0101;
    CMD_SPI_SET_CLOCK_FREQUENCY       = $0102;
    CMD_SPI_SET_MODE                  = $0103;
    CMD_SPI_SET_FRAME_SIZE            = $0104;
    CMD_SPI_SET_CS_LOGIC_LEVEL        = $0105;
    CMD_SPI_SET_CS_PIN                = $0106;
    CMD_SPI_WRITE_READ                = $0107;
    CMD_SERVO_OPEN                    = $0140;
    CMD_SERVO_SET_PULSE_WIDTH         = $0141;
    CMD_SERVO_CLOSE                   = $0142;
    CMD_WS2812_OPEN                   = $0160;
    CMD_WS2812_WRITE_ONE_PIXEL        = $0161;
    CMD_WS2812_WRITE_N_PIXELS         = $0162;
    CMD_WS2812_REFRESH                = $0163;
    CMD_WS2812_CLOSE                  = $0164;
    CMD_CUSTOM_BASE                   = $FC00;
    CMD_CUSTOM0                       = CMD_CUSTOM_BASE + 0;
    CMD_CUSTOM1                       = CMD_CUSTOM_BASE + 1;
    CMD_CUSTOM2                       = CMD_CUSTOM_BASE + 2;
    CMD_CUSTOM3                       = CMD_CUSTOM_BASE + 3;
    CMD_CUSTOM4                       = CMD_CUSTOM_BASE + 4;
    CMD_CUSTOM5                       = CMD_CUSTOM_BASE + 5;
    CMD_CUSTOM6                       = CMD_CUSTOM_BASE + 6;
    CMD_CUSTOM7                       = CMD_CUSTOM_BASE + 7;
    CMD_CUSTOM8                       = CMD_CUSTOM_BASE + 8;
    CMD_CUSTOM9                       = CMD_CUSTOM_BASE + 9;

    { LabView LINX Remote I/O status codes }

    L_OK                              = $00;
    L_FUNCTION_NOT_SUPPORTED          = $01;
    L_REQUEST_RESEND                  = $02;
    L_UNKNOWN_ERROR                   = $03;
    L_DISCONNECT                      = $04;

  TYPE
    LINX_command_t =
      PACKED RECORD
        SoF        : Byte;
        PacketSize : Byte;
        PacketNum  : Word;
        Command    : Word;
        Args       : ARRAY [0 .. 53] OF Byte;
      END;

    LINX_response_t =
      PACKED RECORD
        SoF        : Byte;
        PacketSize : Byte;
        PacketNum  : Word;
        Status     : Byte;
        Data       : ARRAY [0 .. 54] OF Byte;
      END;

  { LabView LINX Remote I/O server procedures }

  PROCEDURE ReceiveCommand
   (fd        : Integer;
    VAR cmd   : LINX_command_t;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINX_receive_command';

  PROCEDURE SendResponse
   (fd        : Integer;
    VAR resp  : LINX_response_t;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINX_send_response';

  { LabView LINX Remote I/O client procedures }

  PROCEDURE SendCommand
   (fd        : Integer;
    VAR cmd   : LINX_command_t;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINX_send_command';

  PROCEDURE ReceiveResponse
   (fd        : Integer;
    VAR resp  : LINX_response_t;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINX_receive_response';

  { Pack two 8-bit bytes into one 16-bit word }
  { b0 is most significant byte               }
  { b1 is least significant byte              }

  FUNCTION MakeU16
   (b0 : Byte;
    b1 : Byte) : Word; CDECL; EXTERNAL NAME 'LINX_makeu16';

  { Pack four 8-bit bytes into one 16-bit word }
  { b0 is most significant byte                }
  { b3 is least significant byte               }

  FUNCTION MakeU32
   (b0 : Byte;
    b1 : Byte;
    b2 : Byte;
    b3 : Byte) : Longword; CDECL; EXTERNAL NAME 'LINX_makeu32';

  { Extract a single byte from a 16-bit word }
  { index 0 is most significant byte         }
  { index 1 is least significant byte        }

  FUNCTION SplitU16
   (item : Word;
    index : Integer) : Byte; CDECL; EXTERNAL NAME 'LINX_splitu16';

  { Extract a single byte from a 16-bit word }
  { index 0 is most significant byte         }
  { index 3 is least significant byte        }

  FUNCTION SplitU32
   (item : Longword;
    index : Integer) : Byte; CDECL; EXTERNAL NAME 'LINX_splitu32';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.

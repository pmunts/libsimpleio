{ Remote I/O Protocol Definitions                                             }

{ Copyright (C)2017-2023, Philip Munts dba Munts Technologies.                }
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

UNIT RemoteIO;

INTERFACE

  USES
    SysUtils;

  TYPE
    Error = CLASS(Exception);

    Channels = 0 .. 127;

    ChannelArray = ARRAY OF Channels;

    MessageTypes =
     (LOOPBACK_REQUEST,
      LOOPBACK_RESPONSE,
      VERSION_REQUEST,
      VERSION_RESPONSE,
      CAPABILITY_REQUEST,
      CAPABILITY_RESPONSE,
      GPIO_PRESENT_REQUEST,
      GPIO_PRESENT_RESPONSE,
      GPIO_CONFIGURE_REQUEST,
      GPIO_CONFIGURE_RESPONSE,
      GPIO_READ_REQUEST,
      GPIO_READ_RESPONSE,
      GPIO_WRITE_REQUEST,
      GPIO_WRITE_RESPONSE,
      I2C_PRESENT_REQUEST,
      I2C_PRESENT_RESPONSE,
      I2C_CONFIGURE_REQUEST,
      I2C_CONFIGURE_RESPONSE,
      I2C_TRANSACTION_REQUEST,
      I2C_TRANSACTION_RESPONSE,
      SPI_PRESENT_REQUEST,
      SPI_PRESENT_RESPONSE,
      SPI_CONFIGURE_REQUEST,
      SPI_CONFIGURE_RESPONSE,
      SPI_TRANSACTION_REQUEST,
      SPI_TRANSACTION_RESPONSE,
      ADC_PRESENT_REQUEST,
      ADC_PRESENT_RESPONSE,
      ADC_CONFIGURE_REQUEST,
      ADC_CONFIGURE_RESPONSE,
      ADC_READ_REQUEST,
      ADC_READ_RESPONSE,
      DAC_PRESENT_REQUEST,
      DAC_PRESENT_RESPONSE,
      DAC_CONFIGURE_REQUEST,
      DAC_CONFIGURE_RESPONSE,
      DAC_WRITE_REQUEST,
      DAC_WRITE_RESPONSE,
      PWM_PRESENT_REQUEST,
      PWM_PRESENT_RESPONSE,
      PWM_CONFIGURE_REQUEST,
      PWM_CONFIGURE_RESPONSE,
      PWM_WRITE_REQUEST,
      PWM_WRITE_RESPONSE);

IMPLEMENTATION

END.

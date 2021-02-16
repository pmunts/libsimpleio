-- Mikroelektronika Click Board socket services interface template

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

GENERIC

  TYPE Kind_Designator(<>)   IS PRIVATE;
  TYPE Analog_Designator(<>) IS PRIVATE;
  TYPE GPIO_Designator(<>)   IS PRIVATE;
  TYPE I2C_Designator(<>)    IS PRIVATE;
  TYPE PWM_Designator(<>)    IS PRIVATE;
  TYPE SPI_Designator(<>)    IS PRIVATE;
  TYPE UART_Designator(<>)   IS PRIVATE;

PACKAGE ClickBoard.Template IS

  -- Define an abstract interface for Click Board sockets

  TYPE SocketInterface IS INTERFACE;

  -- Click Board socket services

  FUNCTION Kind
   (Self : SocketInterface) RETURN Kind_Designator IS ABSTRACT;

  FUNCTION Number
   (Self : SocketInterface) RETURN Positive IS ABSTRACT;

  FUNCTION GPIO
   (Self : SocketInterface;
    pin  : Pins) RETURN GPIO_Designator IS ABSTRACT;

  FUNCTION AIN
   (Self : SocketInterface) RETURN Analog_Designator IS ABSTRACT;

  FUNCTION I2C
   (Self : SocketInterface) RETURN I2C_Designator IS ABSTRACT;

  FUNCTION PWM
   (Self : SocketInterface) RETURN PWM_Designator IS ABSTRACT;

  FUNCTION SPI
   (Self : SocketInterface) RETURN SPI_Designator IS ABSTRACT;

  FUNCTION UART
   (Self : SocketInterface) RETURN UART_Designator IS ABSTRACT;

END ClickBoard.Template;

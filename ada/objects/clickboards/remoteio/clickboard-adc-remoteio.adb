-- Mikroelecktronika ADC Click services using Remote I/O

-- Copyright (C)2017-2023, Philip Munts, President, Munts AM Corp.
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

WITH SPI.RemoteIO;

PACKAGE BODY ClickBoard.ADC.RemoteIO IS

  -- Create an array of analog voltage inputs from a static socket instance

  FUNCTION Create
   (remdev    : Standard.RemoteIO.Client.Device;
    socket    : ClickBoard.RemoteIO.SocketSubclass;
    reference : Voltage.Volts := 3.3) RETURN Inputs IS

    spidev : SPI.Device;

  BEGIN
    spidev := SPI.RemoteIO.Create(remdev, socket.SPI, SPI_Mode, SPI_WordSize,
                SPI_Frequency);

    RETURN Create(spidev, reference);
  END Create;

  -- Create an array of analog voltage inputs from socket number

  FUNCTION Create
   (remdev    : NOT NULL Standard.RemoteIO.Client.Device;
    socknum   : Positive;
    reference : Voltage.Volts := 3.3) RETURN Inputs IS

    socket : ClickBoard.RemoteIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(remdev, socket, reference);
  END Create;

  -- Create an array of analog voltage inputs from Socket object

  FUNCTION Create
   (remdev    : NOT NULL Standard.RemoteIO.Client.Device;
    socket    : NOT NULL ClickBoard.RemoteIO.Socket;
    reference : Voltage.Volts := 3.3) RETURN Inputs IS

  BEGIN
    RETURN Create(remdev, socket.ALL, reference);
  END Create;

END ClickBoard.ADC.RemoteIO;

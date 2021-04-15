-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH SPI;
WITH Messaging;

PACKAGE libRemoteIO.SPI IS

  PROCEDURE SPI_Configure
   (handle    : Integer;
    channel   : Integer;
    mode      : Integer;
    wordsize  : Integer;
    frequency : Integer;
    error     : OUT Integer);

  PROCEDURE SPI_Transaction
   (handle    : Integer;
    channel   : Integer;
    cmd       : IN OUT Messaging.Buffer;
    cmdlen    : Integer;
    resp      : IN OUT Messaging.Buffer;
    resplen   : Integer;
    delayus   : Integer;
    error     : OUT Integer);

  PROCEDURE SPI_Channels
   (handle    : Integer;
    channels  : OUT ChannelArray;
    error     : OUT Integer);

PRIVATE

  PRAGMA Export(Convention => C, Entity => SPI_Configure,   External_Name => "spi_configure");
  PRAGMA Export(Convention => C, Entity => SPI_Transaction, External_Name => "spi_transaction");
  PRAGMA Export(Convention => C, Entity => SPI_Channels,    External_Name => "spi_channels");

END libRemoteIO.SPI;

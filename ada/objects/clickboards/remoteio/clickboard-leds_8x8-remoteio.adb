-- Services for the Mikroelektronika 8x8 LED Click

-- Copyright (C)2016-2023, Philip Munts, President, Munts AM Corp.
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

-- 8 by 8 LED Display layout:

-- Top left LED     is row 0 column 0
-- Bottom right LED is row 7 column 7

WITH SPI.RemoteIO;

PACKAGE BODY ClickBoard.LEDs_8x8.RemoteIO IS

-- STRANGE GNAT BUG WORKAROUND:
--
-- Without the otherwise meaningless function rename at source code line #60,
-- compiling this package body with an Alire compiler fails with an GNAT
-- internal error:
--
-- +===========================GNAT BUG DETECTED==============================+
-- | 12.2.0 (x86_64-w64-mingw32) Program_Error EXCEPTION_ACCESS_VIOLATION     |
-- | Error detected at clickboard-leds_8x8-remoteio.adb:41:5                  |
-- | Compiling clickboard-leds_8x8-remoteio.adb                               |
-- | Please submit a bug report; see https://gcc.gnu.org/bugs/ .              |
-- | Use a subject line meaningful to you and us to track the bug.            |
-- | Include the entire contents of this bug box in the report.               |
-- | Include the exact command that you entered.                              |
-- | Also include sources listed below.                                       |
-- +==========================================================================+
--
-- +===========================GNAT BUG DETECTED==============================+
-- | 12.2.0 (x86_64-pc-linux-gnu) Storage_Error stack overflow or erroneous memory access|
-- | Error detected at clickboard-leds_8x8-remoteio.adb:39:5                  |
-- | Compiling clickboard-leds_8x8-remoteio.adb                               |
-- | Please submit a bug report; see https://gcc.gnu.org/bugs/ .              |
-- | Use a subject line meaningful to you and us to track the bug.            |
-- | Include the entire contents of this bug box in the report.               |
-- | Include the exact command that you entered.                              |
-- | Also include sources listed below.                                       |
-- +==========================================================================+

  FUNCTION Create(dev : SPI.Device) RETURN TrueColor.Display RENAMES ClickBoard.LEDs_8x8.Create;

  -- Create display object from static socket instance

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socket  : ClickBoard.RemoteIO.SocketSubclass) RETURN TrueColor.Display IS

  BEGIN
    RETURN Create(SPI.RemoteIO.Create(remdev, socket.SPI, SPI_Mode,
      SPI_WordSize, SPI_Frequency));
  END Create;

  -- Create display object from socket number

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socknum : Positive) RETURN TrueColor.Display IS

    socket : ClickBoard.RemoteIO.SocketSubclass;

  BEGIN
    socket.Initialize(socknum);
    RETURN Create(remdev, socket);
  END Create;

  -- Create display object from socket object

  FUNCTION Create
   (remdev  : NOT NULL Standard.RemoteIO.Client.Device;
    socket  : NOT NULL ClickBoard.RemoteIO.Socket) RETURN TrueColor.Display IS

  BEGIN
    RETURN Create(remdev, socket.ALL);
  END Create;

END ClickBoard.LEDs_8x8.RemoteIO;

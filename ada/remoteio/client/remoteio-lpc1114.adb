-- Remote I/O Resources available from a Raspberry Pi LPC1114 I/O Processor
-- Expansion Board (MUNTS-0004) or a LPC1114 I/O Processor Grove Module
-- (MUNTS-0007)

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces;

USE TYPE Interfaces.Unsigned_32;

PACKAGE BODY RemoteIO.LPC1114 IS

  -- Split 32-bit word into individual bytes

  FUNCTION ToByte
   (u : Interfaces.Unsigned_32; b : Natural) RETURN Message64.Byte IS

  BEGIN
    RETURN Message64.Byte(Interfaces.Shift_Right(u, b*8) AND 16#FF#);
  END ToByte;

  -- Merge four bytes into one 32-bit word

  FUNCTION ToUnsigned
   (byte0 : Message64.Byte;
    byte1 : Message64.Byte;
    byte2 : Message64.Byte;
    byte3 : Message64.Byte) RETURN Interfaces.Unsigned_32 IS

  BEGIN
    RETURN
      Interfaces.Shift_Left(Interfaces.Unsigned_32(byte3), 24) OR
      Interfaces.Shift_Left(Interfaces.Unsigned_32(byte2), 16) OR
      Interfaces.Shift_Left(Interfaces.Unsigned_32(byte1), 8)  OR
      Interfaces.Unsigned_32(byte0);
  END ToUnsigned;

  -- Convert command to message

  FUNCTION FromCommand(cmd : SPIAGENT_COMMAND_MSG_t) RETURN Message64.Message IS

  BEGIN
    RETURN
     (3  => ToByte(cmd.Command, 3),
      4  => ToByte(cmd.Command, 2),
      5  => ToByte(cmd.Command, 1),
      6  => ToByte(cmd.Command, 0),

      7  => ToByte(cmd.Pin, 3),
      8  => ToByte(cmd.Pin, 2),
      9  => ToByte(cmd.Pin, 1),
      10 => ToByte(cmd.Pin, 0),

      11 => ToByte(cmd.Data, 3),
      12 => ToByte(cmd.Data, 2),
      13 => ToByte(cmd.Data, 1),
      14 => ToByte(cmd.Data, 0),

      OTHERS => 0);
  END FromCommand;

  -- Convert message to response

  FUNCTION ToResponse(msg : Message64.Message) RETURN SPIAGENT_RESPONSE_MSG_t IS

  BEGIN
    RETURN
     (ToUnsigned(msg(6),  msg(5),  msg(4),  msg(3)),
      ToUnsigned(msg(10), msg(9),  msg(8),  msg(7)),
      ToUnsigned(msg(14), msg(13), msg(12), msg(11)),
      ToUnsigned(msg(18), msg(17), msg(16), msg(15)));
  END ToResponse;

  -- Check for operation failure

  PROCEDURE CheckError(resp : SPIAGENT_RESPONSE_MSG_t) IS

  BEGIN
    IF resp.Error /= 0 THEN
      RAISE Abstract_Device.Device_Error WITH
        "SPIAgent Firmware operation failed, error=" &
        Interfaces.Unsigned_32'Image(resp.Error);
    END IF;
  END CheckError;

END RemoteIO.LPC1114;

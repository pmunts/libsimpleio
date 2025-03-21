-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH BeaglePlay;

PROCEDURE test_beagleplay IS

BEGIN
  Put_Line("MuntsOS       => " & BeaglePlay.MuntsOS'Image);
  Put_Line("I2C_GROVE     =>"  & BeaglePlay.I2C_GROVE.chan'Image);
  Put_Line("I2C_MIKROBUS  =>"  & BeaglePlay.I2C_MIKROBUS.chan'Image);
  Put_Line("I2C_QWIIC     =>"  & BeaglePlay.I2C_QWIIC.chan'Image);
  Put_Line("UART_CONSOLE  => " & BeaglePlay.UART_CONSOLE);
  Put_Line("UART_GROVE    => " & BeaglePlay.UART_GROVE);
  Put_Line("UART_MIKROBUS => " & BeaglePlay.UART_MIKROBUS);
END test_beagleplay;

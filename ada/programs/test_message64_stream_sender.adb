-- Message64.Stream_libsimpleio Send Test

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

WITH errno;
WITH libIPV4;
WITH Message64.Stream_libsimpleio;

PROCEDURE test_message64_stream_sender IS

  fd    : Integer;
  error : Integer;
  msg   : Message64.Messenger;
  buf   : Message64.Message;

BEGIN
  New_Line;
  Put_Line("Message64.Stream Send Test");
  New_Line;

  -- Connect to the receiver

  libIPV4.TCP_Connect(libIPV4.INADDR_LOOPBACK, 12345, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Connect() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Create a Message64.Messenger object

  msg := Message64.Stream_libsimpleio.Create(fd);

  -- Send messages to the receiver

  LOOP
    buf := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, OTHERS => 0);
    msg.Send(buf);
    DELAY 1.0;
  END LOOP;
END test_message64_stream_sender;

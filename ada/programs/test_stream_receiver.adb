-- Ada Stream Framing Protocol receiver test

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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
WITH libStream;
WITH libIPV4;

PROCEDURE test_stream_receiver IS

  TYPE byte IS MOD 2**8;

  error     : Integer;
  fd        : Integer;
  msg       : String(1 .. 1024);
  msgsize   : Integer;
  frame     : ARRAY (1 .. 2*1024+8) OF byte;
  framesize : Integer := 0;

BEGIN
  Put_Line("Ada Stream Framing Protocol Receiver");
  New_Line;

  libIPV4.TCP_Server(libIPV4.INADDR_ANY, 12345, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Server() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  Put_Line("INFO: Sender has connected.");

  LOOP
    libStream.Receive(fd, frame'Address, frame'Length, framesize, error);

    IF error = errno.EAGAIN THEN
      GOTO CONTINUE;
    END IF;

    IF error = errno.EPIPE THEN
      Put_Line("INFO: Sender has disconnected.");
      EXIT;
    END IF;

    IF error /= 0 THEN
      Put_Line("ERROR: Receive() failed, " & errno.strerror(error));
      EXIT;
    END IF;

    libStream.Decode(frame'Address, framesize, msg'Address, msg'Length, msgsize, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Decode() failed, " & errno.strerror(error));
      GOTO CONTINUE;
    END IF;

    Put_Line("Received: " & msg(1 .. msgsize));
    framesize := 0;

    <<CONTINUE>>
  END LOOP;

  libIPV4.TCP_Close(fd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: Close() failed, " & errno.strerror(error));
    RETURN;
  END IF;
END test_stream_receiver;

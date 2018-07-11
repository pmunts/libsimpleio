-- Ada Stream Framing Protocol sender test

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

PROCEDURE test_stream_sender IS

  TYPE byte IS MOD 2**8;

  error     : Integer;
  fd        : Integer;
  msg       : String(1 .. 80);
  msglen    : Integer;
  frame     : ARRAY (1 .. 168) OF byte;
  framesize : Integer;
  count     : Integer;

BEGIN
  Put_Line("Ada Stream Framing Protocol Sender");
  New_Line;

  libIPV4.TCP_Connect(libIPV4.INADDR_LOOPBACK, 12345, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Connect() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  LOOP
    Get_Line(msg, msglen);

    libStream.Encode(msg'Address, msglen, frame'Address, frame'Length, framesize, error);
    IF error /= 0 THEN
      Put_Line("ERROR: Encode() failed, " & errno.strerror(error));
      EXIT;
    END IF;

    libStream.Send(fd, frame'Address, framesize, count, error);

    EXIT WHEN error = errno.EPIPE;

    IF error /= 0 THEN
      Put_Line("ERROR: Send() failed, " & errno.strerror(error));
      EXIT;
    END IF;

    EXIT WHEN msg(1 .. msglen) = "quit";
  END LOOP;

  libIPV4.TCP_Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Close() failed, " & errno.strerror(error));
    RETURN;
  END IF;
END test_stream_sender;

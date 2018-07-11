-- Ada IPv4 TCP server test

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
WITH libIPV4;

PROCEDURE test_tcp4_server IS

  fd    : Integer;
  error : Integer;
  msg   : String(1 .. 256);
  count : Integer;

BEGIN
  libIPV4.TCP_Server(libIPV4.INADDR_ANY, 12345, fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Server() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Message loop

  LOOP
    libIPV4.TCP_Receive(fd, msg'Address, msg'Length, count, error);

    EXIT WHEN error = 104;	-- ECONNRESET

    IF error /= 0 THEN
      Put_Line("ERROR: TCP_Receive() failed, " & errno.strerror(error));
      EXIT;
    END IF;

    EXIT WHEN count = 0;
    EXIT WHEN msg(1 .. 4) = "quit";

    Put("Received: " & Integer'Image(count) & " bytes : " & msg(1 .. count));

    DECLARE

      reply : String := "You sent: " & msg(1 .. count);

    BEGIN
      libIPV4.TCP_Send(fd, reply'Address, reply'Length, count, error);
      IF error /= 0 THEN
        Put_Line("ERROR: TCP_Send() failed, " & errno.strerror(error));
        EXIT;
      END IF;
    END;
  END LOOP;

  libIPV4.TCP_Close(fd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Close() failed, " & errno.strerror(error));
  END IF;

  Put_Line("Connection closed.");
END test_tcp4_server;

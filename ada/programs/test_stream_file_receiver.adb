-- Ada Stream Framing Protocol file receiver test

-- Copyright (C)2019-2023, Philip Munts.
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

-- This program uses a very simple file transfer protocol:
--
-- The first frame received will be the ASCII filename.
-- The first empty frame received indicates end of file.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH libStream;
WITH libIPV4;
WITH libLinux;

PROCEDURE test_stream_file_receiver IS

  BlockSize : CONSTANT := 1024;

  TYPE byte IS MOD 2**8;

  count     : Integer;
  error     : Integer;
  streamfd  : Integer;
  filefd    : Integer;
  frame     : ARRAY (1 .. 2*BlockSize+8) OF byte;
  framesize : Integer := 0;
  name      : String(1 .. 256);
  namesize  : Integer;
  data      : ARRAY (1 .. BlockSize) OF byte;
  datasize  : Integer;

BEGIN
  Put_Line("Ada Stream Framing Protocol File Receiver");
  New_Line;

  libIPV4.TCP_Server(libIPV4.INADDR_ANY, 12345, streamfd, error);
  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Server() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Get filename, in the first frame from the sender

  LOOP
    libStream.Receive(streamfd, frame'Address, frame'Length, framesize, error);

    IF error = 0 THEN
      EXIT;
    END IF;

    IF error = errno.EPIPE THEN
      Put_Line("ERROR: Sender has disconnected.");
      RETURN;
    END IF;

    IF error /= errno.EAGAIN THEN
      Put_Line("ERROR: Receive() failed, " & errno.strerror(error));
      RETURN;
    END IF;
  END LOOP;

  name := (OTHERS => ASCII.NUL);

  libStream.Decode(frame'Address, framesize, name'Address, name'Length,
    namesize, error);

  IF error /= 0 THEN
    Put_Line("ERROR: Decode() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  framesize := 0;

  -- Open the destination file

  libLinux.OpenCreate(name, 8#644#, filefd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: OpenCreate() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Copy the file

  LOOP
    -- Get data frame

    LOOP
      libStream.Receive(streamfd, frame'Address, frame'Length, framesize, error);

      IF error = 0 THEN
        EXIT;
      END IF;

      IF error = errno.EPIPE THEN
        Put_Line("ERROR: Sender has disconnected.");
        RETURN;
      END IF;

      IF error /= errno.EAGAIN THEN
        Put_Line("ERROR: Receive() failed, " & errno.strerror(error));
        RETURN;
      END IF;
    END LOOP;

    -- Decode data frame

    libStream.Decode(frame'Address, framesize, data'Address, data'Length,
      datasize, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Decode() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    framesize := 0;

    -- Check for end of file

    IF datasize = 0 THEN
      EXIT;
    END IF;

    -- Write data to destination file

    libLinux.Write(filefd, data'Address, datasize, count, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Write() failed, " & errno.strerror(error));
      RETURN;
    END IF;
  END LOOP;

  PRAGMA Warnings(Off, "* modified by call, but value *");

  libIPv4.TCP_Close(streamfd, error);
  libLinux.close(filefd, error);
END test_stream_file_receiver;

-- Ada Stream Framing Protocol file sender test

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

-- This program uses a very simple file transfer protocol:
--
-- The first frame received will be the ASCII filename.
-- The first empty frame received indicates end of file.

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Command_Line;

WITH errno;
WITH libLinux;
WITH libIPV4;
WITH libStream;

PROCEDURE test_stream_file_sender IS

  BlockSize : CONSTANT := 1024;

  TYPE byte IS MOD 2**8;

  count     : Integer;
  error     : Integer;
  filefd    : Integer;
  streamfd  : Integer;
  data      : ARRAY (1 .. BlockSize) OF byte;
  datasize  : Integer;
  frame     : ARRAY (1 .. 2*BlockSize + 8) OF byte;
  framesize : Integer;

BEGIN
  Put_Line("Ada Stream Framing Protocol Sender");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    New_Line;
    Put_Line("Usage: test_stream_file_sender <filename>");
    New_Line;
    RETURN;
  END IF;

  -- Open source file

  libLinux.OpenRead(Ada.Command_Line.Argument(1), filefd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: OpenRead() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Open TCP connection to the file receiver

  libIPV4.TCP_Connect(libIPV4.INADDR_LOOPBACK, 12345, streamfd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Connect() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Send the file name

  DECLARE

    name : String(1 .. Ada.Command_Line.Argument(1)'Length) :=
      Ada.Command_Line.Argument(1);

  BEGIN
    libStream.Encode(name'Address, name'Length, frame'Address, frame'Length,
      framesize, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Encode() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    libStream.Send(streamfd, frame'Address, framesize, count, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Send() failed, " & errno.strerror(error));
      RETURN;
    END IF;
  END;

  -- Send the file contents

  LOOP
    libLinux.Read(filefd, data'Address, data'Length, datasize, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Read() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    libStream.Encode(data'Address, datasize, frame'Address, frame'Length,
      framesize, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Encode() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    libStream.Send(streamfd, frame'Address, framesize, count, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Send() failed, " & errno.strerror(error));
      RETURN;
    END IF;

    EXIT WHEN datasize = 0;
  END LOOP;

  -- Close file descriptors

  libLinux.Close(filefd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: Close() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  libIPV4.TCP_Close(streamfd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: TCP_Close() failed, " & errno.strerror(error));
    RETURN;
  END IF;
END test_stream_file_sender;

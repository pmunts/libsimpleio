-- Fixed length message services using the libsimpleio Stream Framing Protocol
-- library.  Must be instantiated for each message size.

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH errno;
WITH libLinux;
WITH libStream;

PACKAGE BODY Messaging.Fixed.libsimpleio_stream IS

  MaxFrameSize : CONSTANT Natural := 2*MessageSize + 8;

  SUBTYPE FrameBuffer IS Messaging.Buffer(1 .. MaxFrameSize);

  -- Constructor

  FUNCTION Create
   (fd        : Integer;
    timeoutms : Integer := 1000;
    trimzeros : Boolean := True) RETURN Messenger IS

  BEGIN
    RETURN NEW MessengerSubclass'(fd, timeoutms, trimzeros);
  END Create;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message) IS

    msgsize   : Natural;
    frame     : FrameBuffer;
    framesize : Natural;
    error     : Integer;
    count     : Natural;

  BEGIN
    msgsize := msg'Length;

    -- Optimize bandwidth by not sending trailing zeros.  For short
    -- messages, this will greatly reduce channel bandwidth

    IF Self.trim THEN
      WHILE (msgsize > 0) AND (msg(msgsize - 1) = 0) LOOP
        msgsize := msgsize - 1;
      END LOOP;
    END IF;

    libStream.Encode(msg'Address, msgsize, frame'Address, Frame'Length,
      framesize, error);

    IF error /= 0 THEN
      RAISE Message_Error WITH "libStream.Encode() failed, " &
        errno.strerror(error);
    END IF;

    libLinux.Write(Self.fd, frame'Address, framesize, count, error);

    IF error /= 0 THEN
      RAISE Message_Error WITH "libLinux.Write() failed, " &
        errno.strerror(error);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message) IS

    frame     : FrameBuffer;
    framesize : Natural := 0;
    error     : Integer;
    msgsize   : Natural;

  BEGIN
    msg := (OTHERS => 0);

    -- Receive a frame

    LOOP
      IF Self.timeoutms > 0 THEN
        DECLARE

          files   : libLinux.FilesType(0 .. 0)   := (OTHERS => Self.fd);
          events  : libLinux.EventsType(0 .. 0)  := (OTHERS => libLinux.POLLIN);
          results : libLinux.ResultsType(0 .. 0) := (OTHERS =>0);

        BEGIN
          libLinux.Poll(1, files, events, results, Self.timeoutms, error);

          IF error = errno.EAGAIN THEN
            RAISE Timeout_Error WITH "libLinux.Poll() timed out";
          END IF;

          IF error /= 0 THEN
            RAISE Message_Error WITH "libLinux.Poll() failed, " &
              errno.strerror(error);
          END IF;
        END;
      END IF;

      libStream.Receive(Self.fd, frame'Address, frame'Length, framesize, error);
      EXIT WHEN error = 0;

      IF error /= errno.EAGAIN THEN
        RAISE Message_Error WITH "libStream.Receive() failed, " &
          errno.strerror(error);
      END IF;
    END LOOP;

    -- Decode the received frame

    libStream.Decode(frame'Address, framesize, msg'Address, msg'Length,
      msgsize, error);

    IF error /= 0 THEN
      RAISE Message_Error WITH "libStream.Decode() failed, " &
        errno.strerror(error);
    END IF;
  END Receive;

 -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : MessengerSubclass) RETURN Integer IS

  BEGIN
    RETURN Self.fd;
  END fd;

END Messaging.Fixed.libsimpleio_stream;

-- Abstract interface for fixed length message services (e.g. raw HID)
-- Must be instantiated for each message size.

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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
WITH libEvent;

PACKAGE BODY Messaging.Fixed IS

  epfd : Integer;

  -- This classwide procedure can be used by any subclass implementing
  -- MessageInterface.

  PROCEDURE Transaction
   (self      : MessengerInterface'Class;
    cmd       : Message;
    resp      : OUT Message;
    timeoutms : Natural) IS

    error  : Integer;
    fd     : Integer;
    event  : Integer;
    handle : Integer;

  BEGIN
    self.Send(cmd);

    IF (timeoutms /= 0) AND (self.fd > 2) THEN
      libEvent.Register(epfd, self.fd, libevent.EPOLLIN, 0, error);

      IF (error /= 0) AND (error /= errno.EEXIST) THEN
        RAISE Program_Error WITH "libEvent.Register() failed, " &
          errno.strerror(error);
      END IF;

      libEvent.Wait(epfd, fd, event, handle, timeoutms, error);

      IF error /= 0 THEN
        RAISE Program_Error WITH "libEvent.Wait() failed, " &
          errno.strerror(error);
      END IF;

      libEvent.Unregister(epfd, self.fd, error);

      IF error /= 0 THEN
        RAISE Program_Error WITH "libEvent.Unregister() failed, " &
          errno.strerror(error);
      END IF;
    END IF;

    self.Receive(resp);
  END Transaction;

  error : Integer;

BEGIN
  libEvent.Open(epfd, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "libEvent.Open() failed, " & errno.strerror(error);
  END IF;
END Messaging.Fixed;

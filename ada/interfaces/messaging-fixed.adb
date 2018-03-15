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
WITH libLinux;

PACKAGE BODY Messaging.Fixed IS

  epfd : Integer;

  -- This classwide procedure can be used by any subclass implementing
  -- MessageInterface.

  PROCEDURE Transaction
   (self      : MessengerInterface'Class;
    cmd       : Message;
    resp      : OUT Message;
    timeoutms : Natural := 0) IS

  BEGIN
    self.Send(cmd);

    IF (timeoutms /= 0) THEN
      DECLARE
        error   : Integer;
        files   : LibLinux.FilesType(0 .. 0);
        events  : LibLinux.EventsType(0 .. 0);
        results : LibLinux.ResultsTYpe(0 .. 0);
      BEGIN
        files(0)   := self.fd;
        events(0)  := LibLinux.POLLIN;
        results(0) := 0;

        LibLinux.Poll(1, files, events, results, timeoutms, error);

        IF error /= 0 THEN
          RAISE Program_Error WITH "libEvent.Wait() failed, " &
            errno.strerror(error);
        END IF;
      END;
    END IF;

    self.Receive(resp);
  END Transaction;

END Messaging.Fixed;

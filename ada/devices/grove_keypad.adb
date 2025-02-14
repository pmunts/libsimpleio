-- Device driver for the Grove 12 Button Capacitive Touch Keypad

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

-- See also:
--
-- https://wiki.seeedstudio.com/Grove-12-Channel-Capacitive-Touch-Keypad-ATtiny1616-/

WITH errno;
WITH libLinux;
WITH libSerial;

PACKAGE BODY Grove_Keypad IS

  TASK BODY ReceiverTask IS

    TYPE Byte IS MOD 256;

    KeyMap : CONSTANT ARRAY (Byte'Range) OF Character :=
     (16#E1# => '1',
      16#E2# => '2',
      16#E3# => '3',
      16#E4# => '4',
      16#E5# => '5',
      16#E6# => '6',
      16#E7# => '7',
      16#E8# => '8',
      16#E9# => '9',
      16#EA# => '*',
      16#EB# => '0',
      16#EC# => '#',
      OTHERS => '.');

    myfd  : Integer;
    inbuf : Byte;
    count : Integer;
    error : Integer;

    files     : libLinux.FilesType(0 .. 0);
    events    : liblinux.EventsType(0 .. 0);
    results   : liblinux.ResultsType(0 .. 0);
    timeoutms : Integer;

  BEGIN
    ACCEPT Initialize(fd : Integer) DO
      myfd := fd;
    END Initialize;

    LOOP
      SELECT
        ACCEPT Get(c : OUT character; timeout : Duration) DO
          files(0)   := myfd;
          events(0)  := libLinux.POLLIN;
          results(0) := 0;
          timeoutms  := Integer(timeout*1000.0);

          libLinux.Poll(1, files, events, results, timeoutms, error);

          IF error = 0 THEN
            libSerial.Receive(myfd, inbuf'Address, 1, count, error);
            c := KeyMap(inbuf);
          ELSE
            c := ASCII.NUL;
          END IF;
        END Get;
      OR
        ACCEPT Clear DO
          libSerial.Flush(myfd, libSerial.FLUSH_INPUT, error);
        END Clear;
      OR
        TERMINATE;
      END SELECT;
    END LOOP;
  END ReceiverTask;

  -- Keypad input object constructor

  FUNCTION Create(portname : String) RETURN Keyboard.Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(portname);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Keypad input object instance initializer

  PROCEDURE Initialize(Self : OUT InputSubclass; portname : String) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    -- Open the serial port device

    libSerial.Open(portname, 9600, 0, 8, 1, fd, error);

    IF error /= 0 THEN
      RAISE Keyboard.Error WITH "libSerial.Open() failed, " &
        errno.strerror(error);
    END IF;

    -- Activate the background task

    Self.receiver := NEW ReceiverTask;

    -- Pass serial port file descriptor to the background task

    Self.receiver.Initialize(fd);
  END Initialize;

  -- Method to fetch the next character from the input buffer.
  -- If the timeout expires, return ASCII.NUL.

  FUNCTION Get
   (Self    : InputSubclass;
    timeout : Duration := Keyboard.DefaultTimeout) RETURN Character IS

    c : Character;

  BEGIN
    Self.receiver.Get(c, timeout);
    RETURN c;
  END Get;

  -- Method to clear the input buffer.

  PROCEDURE Clear(Self : InputSubclass) IS

  BEGIN
    Self.receiver.Clear;
  END Clear;

END Grove_Keypad;

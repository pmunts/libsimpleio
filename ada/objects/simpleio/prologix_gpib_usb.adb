-- GPIB (aka HPIB aka IEEE-488) bus controller services using the Prologix
-- GPIB-USB adapter.

-- Copyright (C)2023, Philip Munts.
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
WITH libSerial;

PACKAGE BODY Prologix_GPIB_USB IS

  -- IEEE-488 bus controller object initializer

  PROCEDURE Initialize(Self : OUT ControllerSubclass; name : String := DefaultDeviceNode) IS

    error : Integer;

  BEGIN
    libSerial.Open(name & ASCII.NUL, 115200, 0, 8, 1, Self.fd, error);

    IF error /= 0 THEN
      RAISE GPIB.Error WITH "libSerial.Open() failed, " & errno.strerror(error);
    END IF;

    Self.Put("++mode 1"); -- Controller mode
    Self.Put("++ifc");    -- Seize control of the bus
    Self.Put("++eoi 1");  -- Enable assertion of EOI on the last byte of a command
    Self.Put("++eos 3");  -- No line terminators
    Self.Put("++auto 1"); -- Enable read after write
  END Initialize;

  -- IEEE-488 bus controller object constructor

  FUNCTION Create(name : String := DefaultDeviceNode) RETURN GPIB.Controller IS

    Self : ControllerSubclass;

  BEGIN
    Self.Initialize(name);
    RETURN NEW ControllerSubclass'(Self);
  END Create;

  -- Select a particular slave device for the next operation(s)

  PROCEDURE SelectSlave(Self : IN OUT ControllerSubclass; slave : GPIB.Address) IS

  BEGIN
    IF Natural(slave) /= Self.lastslave THEN
      Self.Put("++addr" & GPIB.Address'Image(slave));
      Self.lastslave := Natural(slave);
    END IF;
  END SelectSlave;

 -- Issue a text command to the most recently selected IEEE-488 slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; cmd : String) IS

    count : Integer;
    error : Integer;

  BEGIN
    DECLARE
      outbuf : String := cmd & ASCII.CR & ASCII.LF;
    BEGIN
      libSerial.Send(Self.fd, outbuf'Address, outbuf'Length, count, error);
    END;

    IF error /= 0 THEN
      RAISE GPIB.Error WITH "libSerial.Send() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Fetch a text response from the most recently selected IEEE-488 slave device

  FUNCTION Get(Self : IN OUT ControllerSubclass) RETURN String IS

    inbuf   : String(1 .. 1024) := (OTHERS => ASCII.NUL);
    count   : Natural := 0;
    files   : libLinux.FilesType(0 .. 0);
    events  : liblinux.EventsType(0 .. 0);
    results : liblinux.ResultsType(0 .. 0);
    dummy   : Integer;
    error   : Integer;

  BEGIN
    LOOP
      IF count = inbuf'Length THEN
        RAISE GPIB.Error WITH "Response buffer overrrun.";
      END IF;

      files(0)   := Self.fd;
      events(0)  := libLinux.POLLIN;
      results(0) := 0;

      libLinux.Poll(1, files, events, results, 1000, error);

      IF error /= 0 THEN
        RAISE GPIB.Error WITH "libLinux.Poll() failed, " & errno.strerror(error);
      END IF;

      libSerial.Receive(Self.fd, inbuf(count + 1)'Address, 1, dummy, error);

      IF error /= 0 THEN
        RAISE GPIB.Error WITH "libSerial.Receive() failed, " & errno.strerror(error);
      END IF;

      EXIT WHEN inbuf(count + 1) = ASCII.LF;

      count := count + 1;
    END LOOP;

    -- Strip trailing CR, if any

    IF inbuf(count) = ASCII.CR THEN
      count := count - 1;
    END IF;

    RETURN inbuf(1 .. count);
  END Get;

  -- Issue Device Clear (DCL) command to the most recently selected IEEE-488 slave device

  PROCEDURE Clear(Self : IN OUT ControllerSubclass) IS

  BEGIN
    Self.Put("++clr");
  END Clear;

END Prologix_GPIB_USB;

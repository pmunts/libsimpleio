-- Remote I/O Server Dispatcher for GPIO commands

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH GPIO.libsimpleio;
WITH Logging;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

PACKAGE RemoteIO.GPIO IS

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH PRIVATE;

  TYPE Dispatcher IS ACCESS DispatcherSubclass;

  TYPE Kinds IS (InputOnly, OutputOnly, InputOutput);

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

  -- Register libsimpleio GPIO pin by specified designator

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Standard.GPIO.libsimpleio.Designator;
    kind : Kinds := InputOutput);

  -- Register libsimpleio GPIO pin by specified chip and line

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    chip : Natural;
    line : Natural;
    kind : Kinds := InputOutput);

  -- Register an arbitrary preconfigured GPIO pin

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    pin  : Standard.GPIO.Pin;
    kind : Kinds := InputOutput);

PRIVATE

  TYPE PinRec IS RECORD
    registered : Boolean;
    configured : Boolean;
    preconfig  : Boolean;
    kind       : Kinds;
    desg       : Standard.GPIO.libsimpleio.Designator;
    obj        : Standard.GPIO.libsimpleio.Pin;
    pin        : Standard.GPIO.Pin;
  END RECORD;

  TYPE PinArray IS ARRAY (ChannelNumber) OF PinRec;

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH RECORD
    logger : Logging.Logger;
    pins   : PinArray;
  END RECORD;

  Unused : CONSTANT PinRec :=
    PinRec'(False, False, False, InputOutput,
      Standard.GPIO.libsimpleio.Unavailable, NULL, NULL);

END RemoteIO.GPIO;

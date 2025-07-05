-- Fixed length message services using WioE5 Ham Radio Protocol #1
--
-- Must be instantiated for each message size.

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

WITH Wio_E5.Ham1;

GENERIC

PACKAGE Messaging.Fixed.WioE5_Ham1 IS

  PACKAGE driver IS NEW Wio_E5.Ham1(Message'Length);

  -- Type definitions

  TYPE MessengerSubclass IS NEW MessengerInterface WITH PRIVATE;

  -- Constructor

  FUNCTION Create
   (dev     : driver.Device;
    node    : driver.NodeID;
    timeout : Natural := 1000) RETURN Messenger;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message);

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message);

PRIVATE

  TYPE MessengerSubclass IS NEW MessengerInterface WITH RECORD
    mydev  : driver.Device;
    mynode : driver.NodeID;
    mytime : Natural;
  END RECORD;

END Messaging.Fixed.WioE5_Ham1;

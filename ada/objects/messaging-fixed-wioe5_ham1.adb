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

WITH Ada.Unchecked_Conversion;

PACKAGE BODY Messaging.Fixed.WioE5_Ham1 IS

  FUNCTION ToPayload IS NEW Ada.Unchecked_Conversion(Message, driver.Payload);

  FUNCTION ToMessage IS NEW Ada.Unchecked_Conversion(driver.Payload, Message);

  -- Constructor

  FUNCTION Create
   (dev     : driver.Device;
    node    : driver.NodeID;
    timeout : Natural := 1000) RETURN Messenger IS

  BEGIN
    RETURN NEW MessengerSubclass'(dev, node, timeout);
  END Create;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message) IS

    len   : Natural;

  BEGIN
    len := msg'Length;

    -- Don't send trailing zero bytes

    WHILE (len > 1) AND (msg(len - 1) = 0) LOOP
      len := len - 1;
    END LOOP;

    Self.mydev.Send(ToPayload(msg), len, Self.mynode);
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message) IS

    pay : driver.Payload := (OTHERS => 0);
    len : Natural;
    src : driver.NodeID;
    dst : driver.NodeID;
    RSS : Integer;
    SNR : Integer;

    timeout : Natural := Self.mytime;

  BEGIN
    LOOP
      Self.mydev.Receive(pay, len, src, dst, RSS, SNR);
      EXIT WHEN len > 0;

      DELAY 0.001;

      IF Self.mytime > 0 THEN
        timeout := timeout - 1;

        IF timeout = 0 THEN
          RAISE Messaging.Timeout_Error;
        END IF;
      END IF;
    END LOOP;

    msg := ToMessage(pay);
  END Receive;

END Messaging.Fixed.WioE5_Ham1;

-- Remote I/O Server Services using Wio_E5.Ham1 transport

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

WITH Ada.Exceptions;
WITH Ada.Strings.Fixed;
WITH Ada.Unchecked_Conversion;

WITH libLinux;
WITH Logging.libsimpleio;
WITH Message64;
WITH Wio_E5.Ham1;

PACKAGE BODY RemoteIO.Server.WioE5_Ham1 IS

  USE TYPE Wio_E5.Byte;
  USE TYPE driver.NodeID;

  FUNCTION ToPayload IS NEW Ada.Unchecked_Conversion(Message64.Message, driver.Payload);

  FUNCTION ToMessage IS NEW Ada.Unchecked_Conversion(driver.Payload, Message64.Message);

  TASK BODY MessageHandlerTask IS

    myname : String(1 .. 80);
    mydev  : driver.Device;
    myexec : RemoteIO.Executive.Executor;
    pay    : driver.Payload;
    len    : Natural;
    src    : driver.NodeID;
    dst    : driver.NodeID;
    RSS    : Integer;
    SNR    : Integer;
    cmd    : Message64.Message;
    resp   : Message64.Message;

  BEGIN

    -- Get objects from the constructor

    ACCEPT SetName(name : String) DO
      Ada.Strings.Fixed.Move(name, myname, Ada.Strings.Right);
    END SetName;

    ACCEPT SetExecutor(exec : RemoteIO.Executive.Executor) DO
      myexec := exec;
    END SetExecutor;

    ACCEPT SetDevice(dev : driver.Device) DO
      mydev := dev;
    END SetDevice;

    -- Message loop follows

    Logging.libsimpleio.Note(Ada.Strings.Fixed.Trim(myname, Ada.Strings.Right) &
      " Server ready");

    LOOP
      BEGIN
        mydev.Receive(pay, len, src, dst, RSS, SNR);

        IF len > 0 AND THEN src /= driver.BroadcastNode AND THEN dst /= driver.BroadcastNode THEN
          IF len < pay'Length THEN
            pay(len + 1 .. pay'Last) := (OTHERS => 0);
          END IF;

          cmd := ToMessage(pay);
          myexec.Execute(cmd, resp);
          pay := ToPayload(resp);
          len := pay'Length;

          WHILE len > 1 AND pay(len) = 0 LOOP
            len := len - 1;
          END LOOP;

          mydev.Send(pay, len, src);
        END IF;

      EXCEPTION
        WHEN Error: OTHERS =>
          Logging.libsimpleio.Error("Caught exception " &
            Ada.Exceptions.Exception_Name(Error) & ": " &
            Ada.Exceptions.Exception_Message(error));
      END;
    END LOOP;
  END MessageHandlerTask;

  FUNCTION Create
   (exec : NOT NULL RemoteIO.Executive.Executor;
    name : String := "Wio-E5 Ham1";
    dev  : NOT NULL driver.Device := driver.Create) RETURN Instance IS

    mytask : MessageHandlerAccess := NEW MessageHandlerTask;

  BEGIN
    mytask.SetName(name);
    mytask.SetExecutor(exec);
    mytask.SetDevice(dev);

    RETURN NEW InstanceSubclass'(MessageHandler => mytask);
  END Create;

END RemoteIO.Server.WioE5_Ham1;

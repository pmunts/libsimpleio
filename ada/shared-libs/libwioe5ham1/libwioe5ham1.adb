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
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Interfaces.C.Strings;

WITH Wio_E5.Ham1;

PACKAGE BODY libWioE5Ham1 IS

  -- errno values

  ENOENT : CONSTANT := 2;
  EIO    : CONSTANT := 5;
  ENOMEM : CONSTANT := 12;
  EINVAL : CONSTANT := 22;

  USE TYPE LoRa.Device;

  MaxPortHandles : CONSTANT Positive := 10;

  PortHandles : ARRAY (1 .. MaxPortHandles) OF LoRa.Device :=
    (OTHERS => NULL);

  NextPortHandle : Positive := PortHandles'First;

  -- Infer errno number from exception message

  FUNCTION ToErrNum(E : Ada.Exceptions.Exception_Occurrence) RETURN Integer IS

    s : CONSTANT String := Ada.Exceptions.Exception_Message(E);

  BEGIN
    IF Ada.Strings.Fixed.Head(s, 7) = "Invalid" THEN
      RETURN EINVAL;
    ELSIF Ada.Strings.Fixed.Tail(s, 14) = "does not exist" THEN
      RETURN ENOENT;
    ELSE
      RETURN EIO;
    END IF;
  END ToErrNum;

  PROCEDURE Initialize
   (portname   : Interfaces.C.Strings.chars_ptr;
    baudrate   : Integer;
    freqmhz    : Float;
    spreading  : Integer;
    bandwidth  : Integer;
    txpreamble : Integer;
    rxpreamble : Integer;
    txpower    : Integer;
    network    : Interfaces.C.Strings.chars_ptr;
    node       : Integer;
    handle     : OUT Integer;
    err        : OUT Integer) IS

    port : String := Interfaces.C.Strings.Value(portname);
    net  : String := Ada.Strings.Fixed.Head(Interfaces.C.Strings.Value(network), 8);
    dev  : LoRa.Device;

  BEGIN
    handle := -1;

    -- Validate parameters

    IF node < 1 OR node > 255 THEN
      Put_Line(Standard_Error, "ERROR: Invalid node ID");
      err := EINVAL;
      RETURN;
    END IF;

    IF NextPortHandle > MaxPortHandles THEN
      Put_Line(Standard_Error, "ERROR: No more port handles");
      err := ENOMEM;
      RETURN;
    END IF;

    dev := LoRa.Create(port, baudrate, net, Wio_E5.Byte(node),
      Wio_E5.Frequency(freqmhz), spreading, bandwidth, txpreamble, rxpreamble,
      txpower);

    PortHandles(NextPortHandle) := dev;

    handle := NextPortHandle;
    err    := 0;

    NextPortHandle := NextPortHandle + 1;

  EXCEPTION
    WHEN E: OTHERS =>
      Put_Line("ERROR: Wio_E5.Ham1.Create() failed");
      handle := -1;
      err    := ToErrNum(E);
  END Initialize;

  PROCEDURE Shutdown
   (handle     : Integer;
    err        : OUT Integer) IS

  BEGIN
    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Shutdown;
    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Put_Line("ERROR: Wio_E5.Ham1.Shutdown() failed");
      err := ToErrNum(E);
  END Shutdown;

  PROCEDURE Receive
   (handle     : Integer;
    msg        : OUT LoRa.Frame;
    len        : OUT Integer;
    src        : OUT Integer;
    dst        : OUT Integer;
    RSS        : OUT Integer;
    SNR        : OUT Integer;
    err        : OUT Integer) IS

    bsrc : WIO_E5.Byte;
    bdst : WIO_E5.Byte;

  BEGIN

    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Receive(msg, len, bsrc, bdst, RSS, SNR);

    src := Integer(bsrc);
    dst := Integer(bdst);
    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Put_Line(Standard_Error, "ERROR: Wio_E5.Ham1.Receive() failed");
      err := ToErrNum(E);
  END Receive;

  PROCEDURE Send
   (handle     : Integer;
    msg        : LoRa.Frame;
    len        : Integer;
    dst        : Integer;
    err        : OUT Integer) IS

  BEGIN
    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF len < 1 OR len > LoRa.MaxPayloadLength THEN
      Put_Line(Standard_Error, "ERROR: Invalid payload length");
      err := EINVAL;
      RETURN;
    END IF;

    IF dst < 0 OR dst > 255 THEN
      Put_Line(Standard_Error, "ERROR: Invalid node ID");
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Send(msg, len, Wio_E5.Byte(dst));
    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Put_Line(Standard_Error, "ERROR: Wio_E5.Ham1.Send() failed");
      err := ToErrNum(E);
  END Send;

  PROCEDURE SendString
   (handle     : Integer;
    outbuf     : Interfaces.C.Strings.chars_ptr;
    dst        : Integer;
    err        : OUT Integer) IS

    s   : String := Interfaces.C.Strings.Value(outbuf);

  BEGIN

    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      Put_Line(Standard_Error, "ERROR: Invalid port handle");
      err := EINVAL;
      RETURN;
    END IF;

    IF s'Length < 1 OR s'Length > LoRa.MaxPayloadLength THEN
      Put_Line(Standard_Error, "ERROR: Invalid payload length");
      err := EINVAL;
      RETURN;
    END IF;

    IF dst < 0 OR dst > 255 THEN
      Put_Line(Standard_Error, "ERROR: Invalid node ID");
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Send(s, Wio_E5.Byte(dst));
    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Put_Line(Standard_Error, "ERROR: Wio_E5.Ham1.Send() failed");
      err := ToErrNum(E);
  END SendString;

END libWioE5Ham1;

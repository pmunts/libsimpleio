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
WITH Interfaces.C.Strings;

WITH Debug;
WITH Wio_E5.Ham2;

PACKAGE BODY libWioE5Ham2 IS

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

  PACKAGE Astr RENAMES Ada.Strings.Fixed;

  PACKAGE Cstr RENAMES Interfaces.C.Strings;

  -- Trim leading and trailing whitespace from an Ada string

  FUNCTION Trim(Source : String; Side : Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES Astr.Trim;

  -- Convert C string to Ada string

  FUNCTION ToString(Item : IN Cstr.chars_ptr) RETURN String RENAMES Cstr.Value;

  -- Convert C string to network ID

  FUNCTION ToNetworkID(s : Cstr.chars_ptr) RETURN LoRa.NetworkID IS

  BEGIN
    RETURN Astr.Head(ToString(s), 10);
  END ToNetworkID;

  -- Convert from Byte to NodeID

  FUNCTION ToNodeID(b : Integer) RETURN LoRa.NodeID IS

  BEGIN
    RETURN LoRa.NodeID(b);
  END ToNodeID;

  -- Infer errno number from exception message

  FUNCTION ToErrNum(E : Ada.Exceptions.Exception_Occurrence) RETURN Integer IS

    s : CONSTANT String := Ada.Exceptions.Exception_Message(E);

  BEGIN
    IF Astr.Head(s, 7) = "Invalid" THEN
      RETURN EINVAL;
    ELSIF Astr.Tail(s, 14) = "does not exist" THEN
      RETURN ENOENT;
    ELSE
      RETURN EIO;
    END IF;
  END ToErrNum;

  PROCEDURE Initialize
   (portname   : Cstr.chars_ptr;
    baudrate   : Integer;
    network    : Cstr.chars_ptr;
    node       : Integer;
    freqmhz    : Float;
    spreading  : Integer;
    bandwidth  : Integer;
    txpreamble : Integer;
    rxpreamble : Integer;
    txpower    : Integer;
    handle     : OUT Integer;
    err        : OUT Integer) IS

    port : String := ToString(portname);
    net  : String := ToNetworkID(network);
    dev  : LoRa.Device;

  BEGIN
    handle := -1;

    -- Validate parameters

    IF node < 1 OR node > 255 THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF NextPortHandle > MaxPortHandles THEN
      err := ENOMEM;
      RETURN;
    END IF;

    dev := LoRa.Create(port, baudrate, net, ToNodeID(node),
      Wio_E5.Frequency(freqmhz), spreading, bandwidth, txpreamble, rxpreamble,
      txpower);

    PortHandles(NextPortHandle) := dev;

    handle         := NextPortHandle;
    NextPortHandle := NextPortHandle + 1;

    err := 0;

  EXCEPTION
    WHEN E: OTHERS =>
      Debug.Put(E);
      handle := -1;
      err    := ToErrNum(E);
  END Initialize;

  PROCEDURE Shutdown
   (handle     : Integer;
    err        : OUT Integer) IS

  BEGIN
    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Shutdown;

    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Debug.Put(E);
      err := ToErrNum(E);
  END Shutdown;

  PROCEDURE Receive
   (handle     : Integer;
    msg        : OUT LoRa.Payload;
    len        : OUT Integer;
    srcnet     : Interfaces.C.Strings.chars_ptr;
    srcnode    : OUT Integer;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : OUT Integer;
    RSS        : OUT Integer;
    SNR        : OUT Integer;
    err        : OUT Integer) IS

    bsrcnet  : LoRa.NetworkID;
    bsrcnode : LoRa.NodeID;
    bdstnet  : LoRa.NetworkID;
    bdstnode : LoRa.NodeID;

  BEGIN

    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Receive(msg, len, bsrcnet, bsrcnode, bdstnet,
      bdstnode, RSS, SNR);

    Cstr.Update(srcnet, 0, Trim(String(bsrcnet)) & ASCII.NUL, False);
    srcnode := Integer(bsrcnode);
    Cstr.Update(dstnet, 0, Trim(String(bdstnet)) & ASCII.NUL, False);
    dstnode := Integer(bdstnode);

    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Debug.Put(E);
      err := ToErrNum(E);
  END Receive;

  PROCEDURE Send
   (handle     : Integer;
    msg        : LoRa.Payload;
    len        : Integer;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : Integer;
    err        : OUT Integer) IS

  BEGIN
    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF len < 1 OR len > LoRa.Payload'Length THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF dstnode < 0 OR dstnode > 255 THEN
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Send(msg, len, ToNetworkID(dstnet), ToNodeID(dstnode));

    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Debug.Put(E);
      err := ToErrNum(E);
  END Send;

  PROCEDURE SendString
   (handle     : Integer;
    outbuf     : Interfaces.C.Strings.chars_ptr;
    dstnet     : Interfaces.C.Strings.chars_ptr;
    dstnode    : Integer;
    err        : OUT Integer) IS

    s : String := ToString(outbuf);

  BEGIN

    -- Validate parameters

    IF handle < 1 OR handle > MaxPortHandles THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF PortHandles(handle) = NULL THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF s'Length < 1 OR s'Length > LoRa.Payload'Length THEN
      err := EINVAL;
      RETURN;
    END IF;

    IF dstnode < 0 OR dstnode > 255 THEN
      err := EINVAL;
      RETURN;
    END IF;

    PortHandles(handle).Send(s, ToNetworkID(dstnet), ToNodeID(dstnode));

    err := 0;

  EXCEPTION
    WHEN E : OTHERS =>
      Debug.Put(E);
      err := ToErrNum(E);
  END SendString;

END libWioE5Ham2;

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

WITH Ada.Streams;

PACKAGE BODY Prologix_GPIB_USB_GNAT IS

  -- IEEE-488 bus controller object initializer

  PROCEDURE Initialize(Self : OUT ControllerSubclass; name : String) IS

  BEGIN
    Self.port := NEW Standard.GNAT.Serial_Communications.Serial_Port;

    Standard.GNAT.Serial_Communications.Open(Self.port.ALL,
      Standard.GNAT.Serial_Communications.Port_Name(name));

    Standard.GNAT.Serial_Communications.Set(Self.port.ALL,
      Rate      => Standard.GNAT.Serial_Communications.B115200,
      Parity    => Standard.GNAT.Serial_Communications.None,
      Bits      => Standard.GNAT.Serial_Communications.CS8,
      Stop_Bits => Standard.GNAT.Serial_Communications.One);

    Self.Put("++mode 1"); -- Controller mode
    Self.Put("++eos 3");  -- No line terminators
  END Initialize;

  -- IEEE-488 bus controller object constructor

  FUNCTION Create(name : String) RETURN GPIB.Controller IS

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

  -- Send a single character to the most recently selected slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; c : Character) IS

    outbuf : Ada.Streams.Stream_Element_Array(0 .. 0);

  BEGIN
    outbuf(0) := Character'Pos(c);
    Standard.GNAT.Serial_Communications.Write(Self.port.ALL, outbuf);
  END Put;

  -- Send a single byte to the most recently selected slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; b : GPIB.Byte) IS

    outbuf : Ada.Streams.Stream_Element_Array(0 .. 0);

  BEGIN
    CASE b IS
      WHEN 10|13|27|43 =>
        outbuf(0) := 27;
        Standard.GNAT.Serial_Communications.Write(Self.port.ALL, outbuf);

      WHEN OTHERS =>
        NULL;
    END CASE;

    outbuf(0) := Ada.Streams.Stream_Element(b);
    Standard.GNAT.Serial_Communications.Write(Self.port.ALL, outbuf);
  END Put;

 -- Issue a text command to the most recently selected IEEE-488 slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; cmd : String) IS

  BEGIN
    FOR c OF cmd LOOP
      Self.Put(c);
    END LOOP;

    Self.Put(ASCII.CR);
    Self.Put(ASCII.LF);
  END Put;

 -- Issue a binary command to the most recently selected IEEE-488 slave device

  PROCEDURE Put(Self : IN OUT ControllerSubclass; cmd : GPIB.ByteArray) IS

  BEGIN
    FOR b OF cmd LOOP
      Self.Put(b);
    END LOOP;
  END Put;

END Prologix_GPIB_USB_GNAT;

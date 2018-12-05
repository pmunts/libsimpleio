-- GPIO pin services using the GPIO extension HTTP server on TCP port 8083

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

WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH GNAT.Sockets;

WITH WebClient;

PACKAGE BODY GPIO.HTTP IS

  TrimSet : CONSTANT Ada.Strings.Maps.Character_Set :=
    Ada.Strings.Maps.To_Set(' ' & ASCII.CR & ASCII.LF & ASCII.NUL);

  FUNCTION FTrim(s : String) RETURN Unbounded_String IS

  BEGIN
    RETURN To_Unbounded_String(Ada.Strings.Fixed.Trim(s, TrimSet, TrimSet));
  END FTrim;

  -- GPIO pin object constructor

  FUNCTION Create
   (hostname : String;
    num      : Natural;
    dir      : Direction;
    state    : Boolean := False) RETURN Pin IS

    hostaddr : GNAT.Sockets.Inet_Addr_Type;

    CfgCmd   : Unbounded_String;
    GetCmd   : Unbounded_String;
    ClrCmd   : Unbounded_String;
    SetCmd   : Unbounded_String;

    CfgRsp   : Unbounded_String;
    ClrRsp   : Unbounded_String;
    SetRsp   : Unbounded_string;

  BEGIN
    -- Resolve the GPIO server's IP address

    hostaddr := GNAT.Sockets.Addresses(GNAT.Sockets.Get_Host_By_Name(hostname));

    -- Precalculate commands and responses

    CfgCmd := "http://" & GNAT.Sockets.Image(hostaddr) & ":8083/GPIO/DDR/" & FTrim(Natural'Image(num)) & "," & FTrim(Integer'Image(Direction'Pos(dir)));
    GetCmd := "http://" & GNAT.Sockets.Image(hostaddr) & ":8083/GPIO/GET/" & FTrim(Natural'Image(num));
    ClrCmd := "http://" & GNAT.Sockets.Image(hostaddr) & ":8083/GPIO/PUT/" & FTrim(Natural'Image(num)) & ",0";
    SetCmd := "http://" & GNAT.Sockets.Image(hostaddr) & ":8083/GPIO/PUT/" & FTrim(Natural'Image(num)) & ",1";

    CfgRsp := "DDR" & FTrim(Natural'Image(num)) & "=" & FTrim(Integer'Image(Direction'Pos(dir))) & ASCII.CR & ASCII.LF;
    ClrRsp := "GPIO" & FTrim(Natural'Image(num)) & "=0" & ASCII.CR & ASCII.LF;
    SetRsp := "GPIO" & FTrim(Natural'Image(num)) & "=1" & ASCII.CR & ASCII.LF;

    -- Configure the GPIO pin

    IF WebClient.Get(To_String(CfgCmd)) /= CfgRsp THEN
      RAISE GPIO_Error WITH "Unexpected response from server";
    END IF;

    -- Write the initial output state

    IF dir = Output THEN
      IF state THEN
        IF WebClient.Get(To_String(SetCmd)) /= SetRsp THEN
          RAISE GPIO_Error WITH "Unexpected response from server";
        END IF;
      ELSE
        IF WebClient.Get(To_String(ClrCmd)) /= ClrRsp THEN
          RAISE GPIO_Error WITH "Unexpected response from server";
        END IF;
      END IF;
    END IF;

    RETURN NEW PinSubclass'(GetCmd, ClrCmd, SetCmd, ClrRsp, SetRsp);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

    resp : Unbounded_String;

  BEGIN
    resp := To_Unbounded_String(WebClient.Get(To_String(self.GetCmd)));

    IF resp = self.SetRsp THEN
      RETURN True;
    ELSIF resp = self.ClrRsp THEN
      RETURN False;
    ELSE
      RAISE GPIO_Error WITH "Unexpected response from server";
    END IF;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

  BEGIN
    IF state THEN
      IF WebClient.Get(To_String(self.SetCmd)) /= self.SetRsp THEN
        RAISE GPIO_Error WITH "Unexpected response from server";
      END IF;
    ELSE
      IF WebClient.Get(To_String(self.ClrCmd)) /= self.ClrRsp THEN
        RAISE GPIO_Error WITH "Unexpected response from server";
      END IF;
    END IF;
  END Put;

END GPIO.HTTP;

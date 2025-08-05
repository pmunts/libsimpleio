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

PACKAGE BODY BuildHAT.PassiveMotor IS

  FUNCTION ToString(p : Ports) RETURN String IS

  BEGIN
    RETURN Ports'Pos(p)'Image;
  END ToString;

  FUNCTION ToString(v : Motor.Velocity) RETURN String IS

    s : String(1 .. 6);

  BEGIN
    Motor.Velocity_IO.Put(s, v, 3, 0);
    RETURN s;
  END ToString;

  FUNCTION Create
   (dev      : Device;
    port     : Ports;
    velocity : Motor.Velocity := 0.0) RETURN Motor.Output IS

    outp : OutputSubclass;

  BEGIN
    outp.Initialize(dev, port, velocity);
    RETURN NEW OutputSubclass'(outp);
  END Create;

  PROCEDURE Initialize
   (Self     : IN OUT OutputSubclass;
    dev      : Device;
    port     : Ports;
    velocity : Motor.Velocity := 0.0) IS

  BEGIN
    Self.mydev  := dev;
    Self.myport := port;
    Self.mydev.Send("port" & ToString(Self.myport) & " ; port_plimit 1.0" &
      ASCII.CR);
    Self.Put(velocity);
  END Initialize;

  PROCEDURE Put
   (Self     : IN OUT OutputSubclass;
    velocity : Motor.Velocity) IS


  BEGIN
    Self.mydev.Send("port" & ToString(Self.myport) & " ; pwm ; set " &
      ToString(velocity) & ASCII.CR);
  END Put;

END BuildHAT.PassiveMotor;

{ PWM output services using the Remote I/O Protocol                           }

{ Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.             }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT RemoteIO_PWM;

INTERFACE

  USES
    PWM,
    RemoteIO,
    RemoteIO_Client;

  TYPE
    OutputSubclass = CLASS(TInterfacedObject, PWM.Output)
      CONSTRUCTOR Create
       (dev  : Device;
        num  : Channels;
        freq : Cardinal);

      PROCEDURE Write(dutycycle : Real);

      PROPERTY dutycycle : Real WRITE Write;
    PRIVATE
      mydev  : Device;
      mynum  : Channels;
      period : Cardinal;
    END;

IMPLEMENTATION

  USES
    Message64,
    SysUtils;

  CONSTRUCTOR OutputSubclass.Create
   (dev  : Device;
    num  : Channels;
    freq : Cardinal);

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    Self.mydev := dev;
    Self.mynum := num;
    Self.period := 1000000000 DIV freq;

    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(PWM_CONFIGURE_REQUEST);
    cmd[2] := num;
    cmd[3] := Self.period DIV 16777216;
    cmd[4] := Self.period DIV 65536 MOD 256;
    cmd[5] := Self.period DIV 256 MOD 256;
    cmd[6] := Self.period MOD 256;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(resp[2]));
  END;

  PROCEDURE OutputSubclass.Write(dutycycle : Real);

  VAR
    ontime : Cardinal;
    cmd    : Message64.Message;
    resp   : Message64.Message;

  BEGIN
    ontime := Round(dutycycle/100.0*Real(Self.period));

    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(PWM_WRITE_REQUEST);
    cmd[2] := mynum;
    cmd[3] := ontime DIV 16777216;
    cmd[4] := ontime DIV 65536 MOD 256;
    cmd[5] := ontime DIV 256 MOD 256;
    cmd[6] := ontime MOD 256;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(resp[2]));
  END;

END.

{ D/A converter output services using the Remote I/O Protocol                 }

{ Copyright (C)2019, Philip Munts, President, Munts AM Corp.                  }
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

UNIT RemoteIO_DAC;

INTERFACE

  USES
    DAC,
    RemoteIO;

  TYPE
    OutputSubclass = CLASS(TInterfacedObject, DAC.Output)
      CONSTRUCTOR Create
       (dev : RemoteIO.Device;
        num : RemoteIO.Channels);

      PROCEDURE Write(sample : Integer);

      PROPERTY sample : Integer WRITE Write;

      FUNCTION resolution : Cardinal;
    PRIVATE
      mydev  : RemoteIO.Device;
      mynum  : RemoteIO.Channels;
      myres  : Cardinal;
    END;

IMPLEMENTATION

  USES
    errno,
    Message64;

  CONSTRUCTOR OutputSubclass.Create
   (dev : RemoteIO.Device;
    num : RemoteIO.Channels);

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    Self.mydev := dev;
    Self.mynum := num;

    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(RemoteIO.DAC_CONFIGURE_REQUEST);
    cmd[2] := num;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE RemoteIO.Error.Create
       ('ERROR: Remote IO transaction failed, ' + errno.strerror(resp[2]));

    Self.myres := resp[3];
  END;

  PROCEDURE OutputSubclass.Write(sample : Integer);

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(RemoteIO.DAC_WRITE_REQUEST);
    cmd[2] := mynum;
    cmd[3] := sample DIV 16777216;
    cmd[4] := sample DIV 65536 MOD 256;
    cmd[5] := sample DIV 256 MOD 256;
    cmd[6] := sample MOD 256;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE RemoteIO.Error.Create
       ('ERROR: Remote IO transaction failed, ' + errno.strerror(resp[2]));
  END;

  FUNCTION OutputSubclass.resolution : Cardinal;

  BEGIN
    resolution := Self.myres;
  END;

END.

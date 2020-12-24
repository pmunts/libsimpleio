{ A/D converter input services using the Remote I/O Protocol                  }

{ Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.             }
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

UNIT RemoteIO_ADC;

INTERFACE

  USES
    ADC,
    RemoteIO,
    RemoteIO_Client;

  TYPE
    InputSubclass = CLASS(TInterfacedObject, ADC.Input)
      CONSTRUCTOR Create
       (dev : Device;
        num : Channels);

      FUNCTION sample : Integer;

      FUNCTION resolution : Cardinal;
    PRIVATE
      mydev  : Device;
      mynum  : Channels;
      myres  : Cardinal;
    END;

IMPLEMENTATION

  USES
    Errors,
    Message64;

  CONSTRUCTOR InputSubclass.Create
   (dev : Device;
    num : Channels);

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    Self.mydev := dev;
    Self.mynum := num;

    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(ADC_CONFIGURE_REQUEST);
    cmd[2] := num;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, ' + StrError(resp[2]));

    Self.myres := resp[3];
  END;

  FUNCTION InputSubclass.sample : Integer;

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(ADC_READ_REQUEST);
    cmd[2] := mynum;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, ' + StrError(resp[2]));

    sample := Integer((resp[3] SHL 24) + (resp[4] SHL 16) + (resp[5] SHL 8) +
      resp[6]);
  END;

  FUNCTION InputSubclass.resolution : Cardinal;

  BEGIN
    resolution := Self.myres;
  END;

END.

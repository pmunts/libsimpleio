{ Remote I/O Protocol Client Services                                         }

{ Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.             }
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

UNIT RemoteIO_Client;

INTERFACE

  USES
    ADC,
    DAC,
    GPIO,
    I2C,
    Message64,
    PWM,
    RemoteIO,
    SPI,
    SysUtils;

  TYPE
    Device = CLASS
      CONSTRUCTOR Create(msg : Message64.Messenger);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      { Queries }

      FUNCTION Version     : String;
      FUNCTION Capability  : String;
      FUNCTION ADC_Inputs  : ChannelArray;
      FUNCTION DAC_Outputs : ChannelArray;
      FUNCTION GPIO_Pins   : ChannelArray;
      FUNCTION I2C_Buses   : ChannelArray;
      FUNCTION PWM_Outputs : ChannelArray;
      FUNCTION SPI_Devices : ChannelArray;

      { I/O Object Constructors }

      FUNCTION ADC
       (num      : Channels) : ADC.Input;

      FUNCTION DAC
       (num      : Channels) : DAC.Output;

      FUNCTION GPIO
       (num      : Channels;
        dir      : GPIO.Direction;
        state    : Boolean = False) : GPIO.Pin;

      FUNCTION I2C
       (num      : Channels;
        speed    : Cardinal = I2C.SpeedStandard) : I2C.Bus;

      FUNCTION PWM
       (num      : Channels;
        freq     : Cardinal) : PWM.Output;

      FUNCTION SPI
       (num      : Channels;
        mode     : Byte;
        wordsize : Byte;
        speed    : Cardinal) : SPI.Device;

    PRIVATE
      msg : Message64.Messenger;
      num : Byte;

      FUNCTION QueryChannels(query : MessageTypes) : ChannelArray;
    END;

IMPLEMENTATION

  USES
    errno,
    RemoteIO_ADC,
    RemoteIO_DAC,
    RemoteIO_GPIO,
    RemoteIO_I2C,
    RemoteIO_PWM,
    RemoteIO_SPI;

  CONSTRUCTOR Device.Create(msg : Message64.Messenger);

  BEGIN
    Self.msg := msg;
    Self.num := 0;
  END;

  { Perform a Remote I/O Protocol operation }

  PROCEDURE Device.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Self.num := Self.num + 17;
    cmd[1] := Self.num;

    Self.msg.Transaction(cmd, resp);

    IF resp[0] <> cmd[0] + 1 THEN
      RAISE Error.Create('ERROR: Incorrect response message type');

    IF resp[1] <> cmd[1] THEN
      RAISE Error.Create('ERROR: Incorrect response message number');

    IF resp[2] <> EOK THEN
      RAISE Error.Create('ERROR: Command failed, ' + strerror(resp[2]));
  END;

  { Fetch the Remote I/O Protocol device version string }

  FUNCTION Device.Version : String;

  VAR
    cmd  : Message;
    resp : Message;
    vers : ARRAY [0 .. 60] OF Char;
    i    : Cardinal;

  BEGIN
    FillChar(cmd, SizeOf(cmd), 0);

    cmd[0] := Ord(VERSION_REQUEST);

    Self.Transaction(cmd, resp);

    FOR i := 0 TO 60 DO
      vers[i] := Char(resp[3 + i]);

    Version := vers;
  END;

  { Fetch the Remote I/O Protocol device capability string }

  FUNCTION Device.Capability : String;

  VAR
    cmd  : Message;
    resp : Message;
    caps : ARRAY [0 .. 60] OF Char;
    i    : Cardinal;

  BEGIN
    FillChar(cmd, SizeOf(cmd), 0);

    cmd[0] := Ord(CAPABILITY_REQUEST);

    Self.Transaction(cmd, resp);

    FOR i := 0 TO 60 DO
      caps[i] := Char(resp[3 + i]);

    Capability := caps;
  END;

  FUNCTION Device.QueryChannels(query : MessageTypes) : ChannelArray;

  VAR
    cmd   : Message64.Message;
    resp  : Message64.Message;
    i     : Cardinal;
    chans : ARRAY OF Channels;

  BEGIN
    chans := NIL;

    cmd[0] := Ord(query);

    Self.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, ' + errno.strerror(resp[2]));

    FOR i := 0 TO 127 DO
      IF resp[3 + i DIV 8] AND (1 SHL (7 - i MOD 8)) <> 0 THEN
        BEGIN
          SetLength(chans, Length(chans) + 1);
          chans[Length(chans)-1] := i;
        END;

    QueryChannels := chans;
  END;

  FUNCTION Device.ADC_Inputs : ChannelArray;

  BEGIN
    ADC_Inputs := Self.QueryChannels(ADC_PRESENT_REQUEST);
  END;

  FUNCTION Device.DAC_Outputs : ChannelArray;

  BEGIN
    DAC_Outputs := Self.QueryChannels(DAC_PRESENT_REQUEST);
  END;

  FUNCTION Device.GPIO_Pins : ChannelArray;

  BEGIN
    GPIO_Pins := Self.QueryChannels(GPIO_PRESENT_REQUEST);
  END;

  FUNCTION Device.I2C_Buses : ChannelArray;

  BEGIN
    I2C_Buses := Self.QueryChannels(I2C_PRESENT_REQUEST);
  END;

  FUNCTION Device.PWM_Outputs : ChannelArray;

  BEGIN
    PWM_Outputs := Self.QueryChannels(PWM_PRESENT_REQUEST);
  END;

  FUNCTION Device.SPI_Devices : ChannelArray;

  BEGIN
    SPI_Devices := Self.QueryChannels(SPI_PRESENT_REQUEST);
  END;

  { I/O Object Constructors }

  FUNCTION Device.ADC
   (num      : Channels) : ADC.Input;

  BEGIN
    ADC := RemoteIO_ADC.InputSubclass.Create(Self, num);
  END;

  FUNCTION Device.DAC
   (num      : Channels) : DAC.Output;

  BEGIN
    DAC := RemoteIO_DAC.OutputSubclass.Create(Self, num);
  END;

  FUNCTION Device.GPIO
   (num      : Channels;
    dir      : GPIO.Direction;
    state    : Boolean) : GPIO.Pin;

  BEGIN
    GPIO := RemoteIO_GPIO.PinSubclass.Create(Self, num, dir, state);
  END;

  FUNCTION Device.I2C
   (num      : Channels;
    speed    : Cardinal) : I2C.Bus;

  BEGIN
    I2C := RemoteIO_I2C.BusSubclass.Create(Self, num, speed);
  END;

  FUNCTION Device.PWM
   (num      : Channels;
    freq     : Cardinal) : PWM.Output;

  BEGIN
    PWM := RemoteIO_PWM.OutputSubclass.Create(Self, num, freq);
  END;

  FUNCTION Device.SPI
   (num      : Channels;
    mode     : Byte;
    wordsize : Byte;
    speed    : Cardinal) : SPI.Device;

  BEGIN
    SPI := RemoteIO_SPI.DeviceSubclass.Create(Self, num, mode,
      wordsize, speed);
  END;

END.

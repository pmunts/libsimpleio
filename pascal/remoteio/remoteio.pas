{ Remote I/O Protocol Implementation                                          }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT RemoteIO;

INTERFACE

  USES
    ADC,
    GPIO,
    I2C,
    Message64,
    SPI,
    SysUtils;

  TYPE
    Error = CLASS(Exception);

    Channels = 0 .. 127;

    ChannelArray = ARRAY OF Channels;

    MessageTypes =
     (LOOPBACK_REQUEST,
      LOOPBACK_RESPONSE,
      VERSION_REQUEST,
      VERSION_RESPONSE,
      CAPABILITY_REQUEST,
      CAPABILITY_RESPONSE,
      GPIO_PRESENT_REQUEST,
      GPIO_PRESENT_RESPONSE,
      GPIO_CONFIGURE_REQUEST,
      GPIO_CONFIGURE_RESPONSE,
      GPIO_READ_REQUEST,
      GPIO_READ_RESPONSE,
      GPIO_WRITE_REQUEST,
      GPIO_WRITE_RESPONSE,
      I2C_PRESENT_REQUEST,
      I2C_PRESENT_RESPONSE,
      I2C_CONFIGURE_REQUEST,
      I2C_CONFIGURE_RESPONSE,
      I2C_TRANSACTION_REQUEST,
      I2C_TRANSACTION_RESPONSE,
      SPI_PRESENT_REQUEST,
      SPI_PRESENT_RESPONSE,
      SPI_CONFIGURE_REQUEST,
      SPI_CONFIGURE_RESPONSE,
      SPI_TRANSACTION_REQUEST,
      SPI_TRANSACTION_RESPONSE,
      ADC_PRESENT_REQUEST,
      ADC_PRESENT_RESPONSE,
      ADC_CONFIGURE_REQUEST,
      ADC_CONFIGURE_RESPONSE,
      ADC_READ_REQUEST,
      ADC_READ_RESPONSE);

    Device = CLASS
      CONSTRUCTOR Create;

      CONSTRUCTOR Create(msg : Message64.Messenger);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      { Queries }

      FUNCTION Version     : String;
      FUNCTION Capability  : String;
      FUNCTION ADC_Inputs  : ChannelArray;
      FUNCTION GPIO_Pins   : ChannelArray;
      FUNCTION I2C_Buses   : ChannelArray;
      FUNCTION SPI_Devices : ChannelArray;

      { I/O Object Constructors }

      FUNCTION ADC
       (num      : Channels) : ADC.Sample;

      FUNCTION GPIO
       (num      : Channels;
        dir      : GPIO.Direction;
        state    : Boolean = False) : GPIO.Pin;

      FUNCTION I2C
       (num      : Channels;
        speed    : Cardinal = I2C.SpeedStandard) : I2C.Bus;

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

{$IFDEF MUNTSOS}
{$DEFINE LIBSIMPLEIO}
{$ENDIF}

  USES
    errno,
{$IFDEF LIBSIMPLEIO}
    HID_libsimpleio,
{$ELSE}
    HID_hidapi,
{$ENDIF}
    RemoteIO_ADC,
    RemoteIO_GPIO,
    RemoteIO_I2C,
    RemoteIO_SPI;

  CONSTRUCTOR Device.Create;

  BEGIN
{$IFDEF LIBSIMPLEIO}
    Self.msg := HID_libsimpleio.MessengerSubclass.Create;
{$ELSE}
    Self.msg := HID_hidapi.MessengerSubclass.Create;
{$ENDIF}

    Self.num := 0;
  END;

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
      RAISE RemoteIO.Error.Create('ERROR: Incorrect response message type');

    IF resp[1] <> cmd[1] THEN
      RAISE RemoteIO.Error.Create('ERROR: Incorrect response message number');

    IF resp[2] <> EOK THEN
      RAISE RemoteIO.Error.Create('ERROR: Command failed, ' + strerror(resp[2]));
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
    chans : ARRAY OF RemoteIO.Channels;

  BEGIN
    chans := NIL;

    cmd[0] := Ord(query);

    Self.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE RemoteIO.Error.Create
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

  FUNCTION Device.GPIO_Pins : ChannelArray;

  BEGIN
    GPIO_Pins := Self.QueryChannels(GPIO_PRESENT_REQUEST);
  END;

  FUNCTION Device.I2C_Buses : ChannelArray;

  BEGIN
    I2C_Buses := Self.QueryChannels(I2C_PRESENT_REQUEST);
  END;

  FUNCTION Device.SPI_Devices : ChannelArray;

  BEGIN
    SPI_Devices := Self.QueryChannels(SPI_PRESENT_REQUEST);
  END;

  { I/O Object Constructors }

  FUNCTION Device.ADC
   (num      : Channels) : ADC.Sample;

  BEGIN
    ADC := RemoteIO_ADC.SampleSubclass.Create(Self, num);
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
